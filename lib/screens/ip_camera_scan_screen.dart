import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/camera_scan_provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/services/ip_camera_detector.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/widgets/pulsing_icon.dart';

// ════════════════════════════════════════════════════════════════════
//  3. IP CAMERA SCAN  (fixed: always terminates; toggle button)
// ════════════════════════════════════════════════════════════════════

class IpCameraScanScreen extends StatefulWidget {
  final String cidr;
  const IpCameraScanScreen({super.key, required this.cidr});
  @override
  State<IpCameraScanScreen> createState() => _IpCameraScanState();
}

class _IpCameraScanState extends State<IpCameraScanScreen> {
  // The scan is owned by CameraScanProvider, so it keeps running in the
  // background when the user leaves this screen. The provider already holds the
  // last results (loaded from local storage); we only auto-scan when nothing is
  // cached, otherwise the user refreshes manually.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoScan());
  }

  Future<void> _maybeAutoScan() async {
    if (!NetworkScanner.isValidCidr(widget.cidr)) return;
    final cams = context.read<CameraScanProvider>();
    if (!await cams.shouldAutoScan() || !mounted) return;
    _startScan();
  }

  void _toggle() {
    final cams = context.read<CameraScanProvider>();
    if (cams.scanning) {
      cams.stopScan();
    } else {
      _startScan();
    }
  }

  void _startScan() {
    final cams = context.read<CameraScanProvider>();
    final scanProv = context.read<ScanProvider>();
    final logging = context.read<SettingsProvider>().settings.loggingEnabled;
    final knownIps = scanProv.hasValidResults(widget.cidr)
        ? scanProv.rawResults.map((h) => h.ip).toList()
        : null;
    cams.startScan(widget.cidr, knownIps: knownIps, logging: logging);
  }

  // ── Label helpers ──────────────────────────────────────────────────────────

  String _methodLabel(CameraDetectionMethod m) => switch (m) {
    CameraDetectionMethod.specificPort => 'Protocol port',
    CameraDetectionMethod.genericPortMfr => 'Known vendor',
    CameraDetectionMethod.genericPortHttp => 'HTTP fingerprint',
    CameraDetectionMethod.wsDiscovery => 'WS-Discovery',
  };

  Color _methodColor(CameraDetectionMethod m) => switch (m) {
    CameraDetectionMethod.specificPort => Colors.green,
    CameraDetectionMethod.genericPortMfr => Colors.blue,
    CameraDetectionMethod.genericPortHttp => Colors.orange,
    CameraDetectionMethod.wsDiscovery => Colors.purple,
  };

  IconData _methodIcon(CameraDetectionMethod m) => switch (m) {
    CameraDetectionMethod.specificPort => Icons.videocam,
    CameraDetectionMethod.genericPortMfr => Icons.business,
    CameraDetectionMethod.genericPortHttp => Icons.language,
    CameraDetectionMethod.wsDiscovery => Icons.wifi_tethering,
  };

  @override
  Widget build(BuildContext context) {
    final cams = context.watch<CameraScanProvider>();
    final results = cams.results;
    final scanning = cams.scanning;
    final done = cams.done;
    final total = cams.total;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IP Camera Scan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: scanning
                  ? const Icon(
                      Icons.stop_rounded,
                      key: ValueKey('stop'),
                      size: 26,
                    )
                  : const PulsingIcon(
                      key: ValueKey('refresh'),
                      child: Icon(Icons.refresh_rounded, size: 24),
                    ),
            ),
            tooltip: scanning ? 'Stop scan' : 'Re-scan',
            onPressed: _toggle,
          ),
        ],
      ),
      body: Column(
        children: [
          if (scanning && total > 0)
            LinearProgressIndicator(value: total > 0 ? done / total : null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                scanning
                    ? 'Scanning… $done/$total hosts — ${results.length} camera(s)'
                    : results.isEmpty
                    ? 'No saved results — tap refresh to scan ${widget.cidr}'
                    : '${results.length} camera(s) found — ${widget.cidr}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          // Legend
          if (results.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: CameraDetectionMethod.values
                    .map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _methodIcon(m),
                              size: 14,
                              color: _methodColor(m),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _methodLabel(m),
                              style: TextStyle(
                                fontSize: 11,
                                color: _methodColor(m),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: results.isEmpty && !scanning
                ? const Center(child: Text('No cameras found.'))
                : ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, thickness: 0.5),
                    itemBuilder: (ctx, i) {
                      final c = results[i];
                      return ListTile(
                        leading: Icon(
                          _methodIcon(c.method),
                          color: _methodColor(c.method),
                        ),
                        title: Row(
                          children: [
                            Text(
                              c.ip,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _methodColor(
                                  c.method,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ':${c.port}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _methodColor(c.method),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.evidence,
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (c.manufacturer.isNotEmpty)
                              Text(
                                c.manufacturer,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                        isThreeLine: c.manufacturer.isNotEmpty,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
