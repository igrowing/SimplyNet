package com.simplytools.simplynet

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.telephony.*
import android.view.WindowManager
import androidx.core.app.ActivityCompat
import com.pravera.flutter_foreground_task.FlutterForegroundTaskPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt

class MainActivity : FlutterActivity() {

    companion object {
        private const val SCREEN_CHANNEL   = "com.simplytools.simplynet/screen"
        private const val WIFI_CHANNEL     = "simplynet/wifi"
        private const val CELLULAR_CHANNEL = "simplynet/cellular"
        private const val MAC_CHANNEL      = "com.simplytools.simplynet/mac"
    }

    // ── Foreground service initialization is handled by the plugin ──────────

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ── Screen keep-on ───────────────────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCREEN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setScreenTimeout" -> {
                        val mode = call.argument<Int>("mode") ?: 0
                        when (mode) {
                            0    -> window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                            else -> window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // ── Wi-Fi scan results ───────────────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIFI_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getScanResults" -> {
                        try {
                            result.success(getWifiScanResults())
                        } catch (e: Exception) {
                            result.error("WIFI_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ── Cellular info ────────────────────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CELLULAR_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getCellularInfo" -> {
                        try {
                            result.success(getCellularInfo())
                        } catch (e: Exception) {
                            result.error("CELLULAR_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ── MAC address for local interface ─────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MAC_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getMacForInterface" -> {
                        val name = call.argument<String>("name")
                        if (name.isNullOrEmpty()) {
                            result.error("INVALID_ARG", "interface name required", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val mac = getMacFromSysFs(name)
                            if (mac != null) result.success(mac)
                            else result.error("MAC_NOT_FOUND", "no MAC for $name", null)
                        } catch (e: Exception) {
                            result.error("MAC_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // ── Wi-Fi scan ───────────────────────────────────────────────────────────
    private fun getMacFromSysFs(ifaceName: String): String? {
        return try {
            val file = java.io.File("/sys/class/net/$ifaceName/address")
            if (!file.exists() || !file.canRead()) return null
            val raw = file.readText().trim()
            if (raw.isEmpty() || raw == "00:00:00:00:00:00") null
            else raw.uppercase()
        } catch (_: Exception) { null }
    }

    @SuppressLint("MissingPermission")
    private fun getWifiScanResults(): List<Map<String, Any>> {
        val wifiManager = applicationContext
            .getSystemService(WIFI_SERVICE) as WifiManager

        // Best-effort: ask the OS for a fresh scan so both bands are refreshed.
        // startScan() is throttled/deprecated on API 28+, but it is harmless and
        // the caller merges several reads, so a band missing from one cached
        // snapshot is still picked up on a later pass.
        try {
            @Suppress("DEPRECATION")
            wifiManager.startScan()
        } catch (_: Exception) {}
        val results = wifiManager.scanResults
        return results.map { ap ->
            mapOf(
                "ssid"  to (if (Build.VERSION.SDK_INT >= 33) ap.wifiSsid?.toString()?.trim('"') ?: "" else @Suppress("DEPRECATION") ap.SSID ?: ""),
                "bssid" to (ap.BSSID ?: ""),
                "rssi"  to ap.level,
                "freq"  to ap.frequency,
            )
        }
    }

    // ── Cellular info ─────────────────────────────────────────────────────────
    @SuppressLint("MissingPermission", "NewApi")
    private fun getCellularInfo(): Map<String, String> {
        val result = mutableMapOf<String, String>()

        val tm = getSystemService(TELEPHONY_SERVICE) as TelephonyManager

        // Provider / carrier
        result["provider"]    = tm.networkOperatorName.ifEmpty { "Unknown" }
        result["mcc_mnc"]     = tm.networkOperator.let {
            if (it.length >= 5) "${it.substring(0,3)}-${it.substring(3)}" else it
        }
        result["roaming"]     = if (tm.isNetworkRoaming) "Yes" else "No"
        result["data_state"]  = when (tm.dataState) {
            TelephonyManager.DATA_CONNECTED    -> "Connected"
            TelephonyManager.DATA_CONNECTING   -> "Connecting"
            TelephonyManager.DATA_DISCONNECTED -> "Disconnected"
            TelephonyManager.DATA_SUSPENDED    -> "Suspended"
            else                               -> "Unknown"
        }

        // Technology is derived from the CellInfo subclass type.
        // This requires only ACCESS_FINE_LOCATION (already granted), NOT READ_PHONE_STATE.
        // We will fill it in the allCellInfo loop below so it matches the serving cell.

        // Signal metrics via getAllCellInfo()
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            val cellInfos = tm.allCellInfo ?: emptyList()
            for (info in cellInfos) {
                if (!info.isRegistered) continue
                when (info) {
                    is CellInfoLte -> {
                        val id  = info.cellIdentity
                        val sig = info.cellSignalStrength
                        result["rssi"]           = "${sig.dbm} dBm"
                        result["rsrp"]           = "${sig.rsrp} dBm"
                        result["rsrq"]           = "${sig.rsrq} dB"
                        if (Build.VERSION.SDK_INT >= 29) {
                            result["sinr"]       = "${sig.rssnr} dB"
                        }
                        result["cell_id"]        = id.ci.toString()
                        result["lac_tac"]        = id.tac.toString()
                        result["pci"]            = id.pci.toString()
                        result["band"]           = earfcnToBand(id.earfcn)
                        result["earfcn"]         = id.earfcn.toString()
                        result["technology"]     = "LTE (4G)"
                        result["tower_est_dist"] =
                            estimateDist(sig.dbm, earfcnToFreqMhz(id.earfcn))
                        break
                    }
                    is CellInfoNr -> {
                        if (Build.VERSION.SDK_INT >= 29) {
                            val id  = info.cellIdentity as CellIdentityNr
                            val sig = info.cellSignalStrength as CellSignalStrengthNr
                            result["rssi"]       = "${sig.dbm} dBm"
                            result["rsrp"]       = "${sig.ssRsrp} dBm"
                            result["rsrq"]       = "${sig.ssRsrq} dB"
                            result["sinr"]       = "${sig.ssSinr} dB"
                            result["cell_id"]    = id.nci.toString()
                            result["lac_tac"]    = id.tac.toString()
                            result["pci"]        = id.pci.toString()
                            result["band"]       = "5G NR (${id.nrarfcn})"
                            result["earfcn"]     = id.nrarfcn.toString()
                            result["technology"]     = "5G NR"
                            // 5G mid-band is the common case; a representative
                            // 3500 MHz keeps the estimate in a sane range.
                            result["tower_est_dist"] = estimateDist(sig.dbm, 3500)
                            break
                        }
                    }
                    is CellInfoGsm -> {
                        val id  = info.cellIdentity
                        val sig = info.cellSignalStrength
                        result["rssi"]     = "${sig.dbm} dBm"
                        result["cell_id"]  = id.cid.toString()
                        result["lac_tac"]  = id.lac.toString()
                        result["technology"] = "GSM (2G)"
                        result["band"]       = "GSM"
                        break
                    }
                    is CellInfoWcdma -> {
                        val id  = info.cellIdentity
                        val sig = info.cellSignalStrength
                        result["rssi"]     = "${sig.dbm} dBm"
                        result["cell_id"]  = id.cid.toString()
                        result["lac_tac"]  = id.lac.toString()
                        result["technology"] = "WCDMA (3G)"
                        result["band"]       = "WCDMA / 3G"
                        break
                    }
                }
            }
        }

        return result
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private fun networkTypeString(type: Int): String = when (type) {
        TelephonyManager.NETWORK_TYPE_LTE    -> "LTE (4G)"
        TelephonyManager.NETWORK_TYPE_NR     -> "5G NR"
        TelephonyManager.NETWORK_TYPE_HSPA,
        TelephonyManager.NETWORK_TYPE_HSDPA,
        TelephonyManager.NETWORK_TYPE_HSUPA  -> "HSPA (3.5G)"
        TelephonyManager.NETWORK_TYPE_UMTS   -> "UMTS (3G)"
        TelephonyManager.NETWORK_TYPE_EDGE   -> "EDGE (2.5G)"
        TelephonyManager.NETWORK_TYPE_GPRS   -> "GPRS (2G)"
        TelephonyManager.NETWORK_TYPE_GSM    -> "GSM (2G)"
        else                                 -> "Unknown ($type)"
    }

    /**
     * Very rough distance estimate from RSRP using the Okumura-Hata urban
     * propagation model. Free-space path loss (the previous approach) hugely
     * underestimates real cellular attenuation and produced absurd distances of
     * millions of km. Hata is realistic for macro cells; the result is still
     * only an order-of-magnitude indication.
     *
     * Assumes a macro base station (~30 m antenna), a 1.5 m mobile and a
     * typical ~46 dBm EIRP, so path loss = EIRP - RSRP.
     */
    private fun estimateDist(rsrpDbm: Int, freqMhz: Int): String {
        if (rsrpDbm <= -140 || rsrpDbm >= 0 || freqMhz <= 0) return "N/A"

        val f  = freqMhz.toDouble().coerceIn(150.0, 3800.0)
        val hb = 30.0   // base-station antenna height (m)
        val hm = 1.5    // mobile height (m)
        val pathLoss = 46.0 - rsrpDbm

        val logF  = Math.log10(f)
        val logHb = Math.log10(hb)
        // Mobile-antenna correction for a small/medium city.
        val aHm   = (1.1 * logF - 0.7) * hm - (1.56 * logF - 0.8)
        val constTerm = 69.55 + 26.16 * logF - 13.82 * logHb - aHm
        val slope     = 44.9 - 6.55 * logHb

        val distKm = Math.pow(10.0, (pathLoss - constTerm) / slope)
        if (distKm.isNaN() || distKm <= 0 || distKm > 100) return "N/A"
        return if (distKm < 1.0)
            "~${(distKm * 1000).roundToInt()} m (estimated)"
        else
            "~${(distKm * 10).roundToInt() / 10.0} km (estimated)"
    }

    /** Representative downlink centre frequency (MHz) for an LTE EARFCN band. */
    private fun earfcnToFreqMhz(earfcn: Int): Int = when {
        earfcn in 0..599      -> 2100
        earfcn in 600..1199   -> 1900
        earfcn in 1200..1949  -> 1800
        earfcn in 1950..2399  -> 1700
        earfcn in 2400..2649  -> 850
        earfcn in 2750..3449  -> 2600
        earfcn in 3450..3799  -> 900
        earfcn in 6150..6449  -> 800
        earfcn in 9210..9659  -> 700
        else                  -> 1800
    }

    private fun earfcnToBand(earfcn: Int): String = when {
        earfcn in 0..599      -> "B1 (2100 MHz)"
        earfcn in 600..1199   -> "B2 (1900 MHz)"
        earfcn in 1200..1949  -> "B3 (1800 MHz)"
        earfcn in 1950..2399  -> "B4 (AWS)"
        earfcn in 2400..2649  -> "B5 (850 MHz)"
        earfcn in 2750..3449  -> "B7 (2600 MHz)"
        earfcn in 3450..3799  -> "B8 (900 MHz)"
        earfcn in 6150..6449  -> "B20 (800 MHz)"
        earfcn in 9210..9659  -> "B28 (700 MHz)"
        else                  -> "Band $earfcn"
    }
}
