package com.simplynet.app

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
        private const val SCREEN_CHANNEL   = "com.simplynet.app/screen"
        private const val WIFI_CHANNEL     = "simplynet/wifi"
        private const val CELLULAR_CHANNEL = "simplynet/cellular"
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
    }

    // ── Wi-Fi scan ───────────────────────────────────────────────────────────
    @SuppressLint("MissingPermission")
    private fun getWifiScanResults(): List<Map<String, Any>> {
        val wifiManager = applicationContext
            .getSystemService(WIFI_SERVICE) as WifiManager

        // On API 28+ startScan() is throttled; getScanResults() returns the
        // most recent cached scan which is good enough for interference display.
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

        // Technology
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            result["technology"] = networkTypeString(tm.dataNetworkType)
        } else {
            result["technology"] = "Permission denied"
        }

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
                        result["tower_est_dist"] = estimateDist(sig.dbm)
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
                            result["tower_est_dist"] = estimateDist(sig.dbm)
                            break
                        }
                    }
                    is CellInfoGsm -> {
                        val id  = info.cellIdentity
                        val sig = info.cellSignalStrength
                        result["rssi"]     = "${sig.dbm} dBm"
                        result["cell_id"]  = id.cid.toString()
                        result["lac_tac"]  = id.lac.toString()
                        result["band"]     = "GSM"
                        break
                    }
                    is CellInfoWcdma -> {
                        val id  = info.cellIdentity
                        val sig = info.cellSignalStrength
                        result["rssi"]     = "${sig.dbm} dBm"
                        result["cell_id"]  = id.cid.toString()
                        result["lac_tac"]  = id.lac.toString()
                        result["band"]     = "WCDMA / 3G"
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

    /** Very rough distance estimate from RSRP using free-space path loss. */
    private fun estimateDist(rsrpDbm: Int): String {
        // Rough heuristic: towers typically transmit at ~46 dBm EIRP on 1800 MHz.
        // d(km) = 10^((46 - pathloss) / 20) where pathloss = 46 - rsrp (approx)
        if (rsrpDbm <= -140 || rsrpDbm >= 0) return "N/A"
        val pathloss = 46.0 - rsrpDbm
        val distKm   = Math.pow(10.0, (pathloss - 20) / 20.0)
        return "~${(distKm * 10).roundToInt() / 10.0} km (estimated)"
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
