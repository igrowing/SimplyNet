import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/services/log_service.dart';

/// Cellular Info screen.
/// Shows Rx/Tx signal levels, connected cell tower data, provider, and
/// technology (LTE/5G/3G) sourced from Android's TelephonyManager
/// via a MethodChannel (simplynet/cellular).
///
/// Also shows approximate GPS location and nearest city/village using
/// the OS location service (no extra permissions beyond ACCESS_FINE_LOCATION
/// which is already declared in AndroidManifest.xml for Wi-Fi scanning).
///
/// Falls back to informative placeholders on iOS / unsupported devices.
class CellularScreen extends StatefulWidget {
  const CellularScreen({super.key});
  @override
  State<CellularScreen> createState() => _CellularScreenState();
}

class _CellularScreenState extends State<CellularScreen> {
  static const _channel = MethodChannel('simplynet/cellular');

  Map<String, String> _data    = {};
  bool   _loading              = false;
  String _error                = '';

  // ── Location state ────────────────────────────────────────────────────────
  String _locationLine  = '';   // "lat, lon"
  String _placeName     = '';   // nearest city/village from Nominatim
  bool   _locationBusy  = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final raw = await _channel.invokeMethod<Map>('getCellularInfo');
      if (raw != null) {
        setState(() => _data = raw.map(
            (k, v) => MapEntry(k.toString(), v.toString())));
      } else {
        setState(() => _error = 'No data returned from device.');
      }
    } on PlatformException catch (e) {
      setState(() {
        _error = 'Platform error: \${e.message}';
        _data  = _demoData();
      });
    } catch (e) {
      setState(() {
        _error = 'Error: \$e';
        _data  = _demoData();
      });
    } finally {
      setState(() => _loading = false);
    }

    // Fetch location in parallel after cellular data is shown
    unawaited(_fetchLocation());

    // Log the result
    if (context.mounted) {
      final settings = context.read<SettingsProvider>().settings;
      if (settings.loggingEnabled && _data.isNotEmpty) {
        final buf = StringBuffer();
        _data.forEach((k, v) => buf.writeln('$k: $v'));
        await LogService.createLog(
          function: 'cellular',
          content:  buf.toString(),
          summary:  'Cellular info: \${_data["provider"] ?? "?"} \${_data["technology"] ?? ""}',
        );
      }
    }
  }

  Future<void> _fetchLocation() async {
    setState(() { _locationBusy = true; _locationLine = ''; _placeName = ''; });
    try {
      // Check permission — we only use what's already granted.
      // ACCESS_FINE_LOCATION is already in AndroidManifest for Wi-Fi scanning.
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        // Try to request it once — the AndroidManifest already declares it.
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() {
          _locationLine = 'Denied by the user';
          _placeName    = '';
          _locationBusy = false;
        });
        return;
      }

      // Get last known position first (fast, no GPS cold-start delay)
      Position? pos = await Geolocator.getLastKnownPosition();
      // Fall back to current position if no cached fix
      pos ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,   // cell/wifi accuracy, no GPS needed
          timeLimit: Duration(seconds: 8),
        ),
      );

      final lat = pos.latitude;
      final lon = pos.longitude;
      setState(() => _locationLine = '\${lat.toStringAsFixed(5)}, \${lon.toStringAsFixed(5)}');

      // Reverse-geocode via OpenStreetMap Nominatim (no API key required)
      final place = await _reverseGeocode(lat, lon);
      setState(() {
        _placeName    = place;
        _locationBusy = false;
      });
    } catch (e) {
      setState(() {
        _locationLine = 'Unavailable: \$e';
        _locationBusy = false;
      });
    }
  }

  Future<String> _reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json&lat=\$lat&lon=\$lon&zoom=14',
      );
      final resp = await http
          .get(uri, headers: {'User-Agent': 'SimplyNet/1.0'})
          .timeout(const Duration(seconds: 6));
      if (resp.statusCode == 200) {
        final j   = json.decode(resp.body) as Map<String, dynamic>;
        final adr = j['address'] as Map<String, dynamic>? ?? {};
        // Pick the most specific populated place name available
        final place =
            (adr['village']      ??
             adr['town']         ??
             adr['city']         ??
             adr['municipality'] ??
             adr['county']       ??
             adr['state']        ?? '') as String;
        final country = (adr['country_code'] as String? ?? '').toUpperCase();
        if (place.isEmpty) return '';
        return country.isEmpty ? place : '\$place (\$country)';
      }
    } catch (_) {}
    return '';
  }

  Map<String, String> _demoData() => {
    'provider':       'Demo Carrier',
    'technology':     'LTE (4G)',
    'rssi':           '-78 dBm',
    'rsrp':           '-105 dBm',
    'rsrq':           '-12 dB',
    'sinr':           '8 dB',
    'cell_id':        '12345678',
    'lac_tac':        '1234',
    'mcc_mnc':        '234-15',
    'band':           'B3 (1800 MHz)',
    'earfcn':         '1300',
    'pci':            '42',
    'tower_est_dist': '~0.8 km (estimated)',
    'data_state':     'Connected',
    'roaming':        'No',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cellular Info',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2,
                      color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: _refresh,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_error.isNotEmpty)
            Container(
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                Icon(Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onErrorContainer),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('\${_error}\nShowing demo data.',
                      style: TextStyle(fontSize: 12,
                          color: Theme.of(context).colorScheme.onErrorContainer)),
                ),
              ]),
            ),
          Expanded(
            child: _data.isEmpty && _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      _section('Carrier', [
                        _row('Provider',    _data['provider']    ?? '—'),
                        _row('Technology',  _data['technology']  ?? '—'),
                        _row('MCC-MNC',     _data['mcc_mnc']     ?? '—'),
                        _row('Roaming',     _data['roaming']     ?? '—'),
                        _row('Data state',  _data['data_state']  ?? '—'),
                      ]),
                      const SizedBox(height: 12),
                      _section('Signal Quality', [
                        _row('RSSI',        _data['rssi']        ?? '—'),
                        _row('RSRP',        _data['rsrp']        ?? '—',
                            hint: 'Reference Signal Received Power'),
                        _row('RSRQ',        _data['rsrq']        ?? '—',
                            hint: 'Reference Signal Received Quality'),
                        _row('SINR',        _data['sinr']        ?? '—',
                            hint: 'Signal to Interference+Noise Ratio'),
                        const SizedBox(height: 4),
                        _signalBar(context, _data['rsrp'] ?? ''),
                      ]),
                      const SizedBox(height: 12),
                      _section('Cell Tower', [
                        _row('Cell ID',     _data['cell_id']     ?? '—'),
                        _row('LAC / TAC',   _data['lac_tac']     ?? '—'),
                        _row('PCI',         _data['pci']         ?? '—',
                            hint: 'Physical Cell ID (LTE/5G)'),
                        _row('Band',        _data['band']        ?? '—'),
                        _row('EARFCN',      _data['earfcn']      ?? '—',
                            hint: 'E-UTRA Absolute Radio Freq Channel Number'),
                        _row('Est. distance', _data['tower_est_dist'] ?? '—',
                            hint: 'Very rough estimate from timing advance'),
                      ]),
                      const SizedBox(height: 12),
                      // ── Location section ──────────────────────────────────
                      _section('Location', [
                        _row('Coordinates',
                          _locationBusy
                              ? 'Locating…'
                              : _locationLine.isEmpty ? '—' : _locationLine),
                        if (_locationBusy)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: LinearProgressIndicator(),
                          ),
                        if (_placeName.isNotEmpty)
                          _row('Nearest place', _placeName),
                      ]),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        const Divider(),
        ...children,
      ],
    );
  }

  Widget _row(String label, String value, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: hint != null
                ? Tooltip(
                    message: hint,
                    child: Row(children: [
                      Text(label, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 2),
                      Icon(Icons.help_outline, size: 11,
                          color: Colors.grey.shade500),
                    ]),
                  )
                : Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  Widget _signalBar(BuildContext context, String rsrpStr) {
    final match = RegExp(r'(-?\d+)').firstMatch(rsrpStr);
    final rsrp  = match != null ? int.tryParse(match.group(1)!) ?? -120 : -120;
    final frac  = ((rsrp + 120) / 40.0).clamp(0.0, 1.0);
    final color = frac > 0.7
        ? Colors.green
        : frac > 0.4
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Signal strength', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value:           frac,
              minHeight:       14,
              backgroundColor: Colors.grey.shade300,
              valueColor:      AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            frac > 0.7
                ? 'Excellent'
                : frac > 0.4
                    ? 'Fair'
                    : 'Poor',
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}

// Convenience to fire-and-forget a Future without needing async context.
void unawaited(Future<void> future) => future.ignore();
