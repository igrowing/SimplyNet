import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/services/foreground_service.dart';
import 'package:simply_net/services/iot_scanner.dart';
import 'package:simply_net/services/log_service.dart';

class IotScanScreen extends StatefulWidget {
  final String cidr;
  const IotScanScreen({super.key, required this.cidr});

  @override
  State<IotScanScreen> createState() => _IotScanScreenState();
}

class _IotScanScreenState extends State<IotScanScreen> {
  List<IotDevice> _devices = [];
  bool   _scanning = false;
  int    _done     = 0;
  int    _total    = 0;
  StreamSubscription<IotDevice>? _sub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScan());
  }

  @override
  void dispose() {
    _sub?.cancel();
    FgService.stop();
    super.dispose();
  }

  /// Called by the Rescan button — always does a fresh full scan,
  /// discarding any cached host list from ScanProvider.
  void _rescan() {
    context.read<ScanProvider>().clearCache();
    _startScan(forceFullScan: true);
  }

  void _startScan({bool forceFullScan = false}) {
    if (_scanning) return;
    _sub?.cancel();
    setState(() {
      _devices  = [];
      _scanning = true;
      _done     = 0;
    });

    final scanProv = context.read<ScanProvider>();

    if (!forceFullScan && scanProv.hasValidResults(widget.cidr)) {
      // ── Fast path: reuse already-discovered IPs from ScanProvider ────────
      // Skip the full subnet sweep and probe only the live hosts we already know.
      final ips = scanProv.rawResults.map((h) => h.ip).toList();
      _total = ips.length;
      FgService.start(title: 'IoT Scan', body: 'Probing ${ips.length} known hosts…');

      _sub = IotScanner.scanHosts(ips).listen(
        (dev) => setState(() {
          _devices.add(dev);
          _done++;
        }),
        onDone: () async {
          setState(() => _scanning = false);
          FgService.stop(doneBody: 'IoT scan complete — ${_devices.length} device(s) found.');
          await _writeLog();
        },
        onError: (_) => setState(() => _scanning = false),
      );
    } else {
      // ── Full scan path: no cached results yet ────────────────────────────
      final parts  = widget.cidr.split('/');
      final prefix = int.tryParse(parts.length > 1 ? parts[1] : '24') ?? 24;
      _total = (1 << (32 - prefix)) - 2;

      FgService.start(title: 'IoT Scan', body: 'Scanning ${widget.cidr} for IoT devices…');

      _sub = IotScanner.scanSubnet(widget.cidr).listen(
        (dev) => setState(() => _devices.add(dev)),
        onDone: () async {
          setState(() => _scanning = false);
          FgService.stop(doneBody: 'IoT scan complete — ${_devices.length} device(s) found.');
          await _writeLog();
        },
        onError: (_) => setState(() => _scanning = false),
      );

      // Progress ticker (full scan gives no per-host progress)
      Timer.periodic(const Duration(milliseconds: 400), (t) {
        if (!_scanning) { t.cancel(); return; }
        setState(() => _done = (_done + 8).clamp(0, _total));
      });
    }
  }

  Future<void> _writeLog() async {
    if (!context.mounted) return;
    final settings = context.read<SettingsProvider>().settings;
    if (!settings.loggingEnabled) return;
    final buf = StringBuffer();
    for (final dev in _devices) {
      buf.writeln('${dev.ip}  ${dev.protocol}  ${dev.vendor}  '
          '[${dev.detectionMethod}, ${dev.confidence.name}]');
    }
    await LogService.createLog(
      function: 'iot_scan',
      content:  buf.toString(),
      summary:  'IoT scan ${widget.cidr}: ${_devices.length} device(s) found',
    );
  }

  void _stopScan() {
    _sub?.cancel();
    setState(() => _scanning = false);
    FgService.stop();
    // Wipe the shared host cache so the next Rescan triggers a fresh
    // full subnet discovery rather than reusing stale results.
    context.read<ScanProvider>().clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('IoT Devices', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.cidr, style: const TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _scanning
                  ? const Icon(Icons.stop_rounded,   key: ValueKey('s'), size: 28)
                  : const Icon(Icons.refresh_rounded, key: ValueKey('r'), size: 26),
            ),
            tooltip: _scanning ? 'Stop' : 'Re-scan',
            onPressed: _scanning ? _stopScan : _rescan,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_scanning) LinearProgressIndicator(
            value: _total > 0 ? _done / _total : null,
          ),
          if (_scanning)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Scanning… ${_devices.length} IoT device(s) found',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          if (!_scanning && _devices.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No IoT devices detected.\nTry re-scanning.',
                    textAlign: TextAlign.center),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: _devices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) => _DeviceCard(device: _devices[i]),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Device card ───────────────────────────────────────────────────────────────

class _DeviceCard extends StatelessWidget {
  final IotDevice device;
  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    final color = _protocolColor(device.protocol);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Protocol icon
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_protocolIcon(device.protocol), color: color, size: 22),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(device.ip,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                    _ConfidenceBadge(device.confidence),
                  ]),
                  const SizedBox(height: 2),
                  Text(device.protocol.isEmpty ? 'Unknown' : device.protocol,
                      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
                  if (device.model.isNotEmpty)
                    Text(device.model, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 3),
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      if (device.vendor.isNotEmpty)
                        _Chip(device.vendor, Colors.blueGrey),
                      if (device.mac != 'N/A')
                        _Chip(device.mac, Colors.grey),
                      ...device.openPorts.take(5).map(
                          (p) => _Chip(':$p', Colors.teal)),
                    ],
                  ),
                  if (device.extra.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    ...device.extra.entries.take(3).map((e) =>
                      Text('${e.key}: ${e.value}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey))),
                  ],
                  const SizedBox(height: 2),
                  Text('via ${device.detectionMethod}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            // Copy IP button
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              tooltip: 'Copy IP',
              onPressed: () => Clipboard.setData(ClipboardData(text: device.ip)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ),
    );
  }

  static Color _protocolColor(String p) {
    p = p.toLowerCase();
    if (p.contains('tasmota'))         return Colors.orange;
    if (p.contains('esphome'))         return Colors.teal;
    if (p.contains('shelly'))          return Colors.green;
    if (p.contains('home assistant'))  return Colors.blue;
    if (p.contains('openhab'))         return Colors.indigo;
    if (p.contains('matter'))          return Colors.purple;
    if (p.contains('ewelink') ||
        p.contains('sonoff'))          return Colors.red;
    if (p.contains('tp-link') ||
        p.contains('kasa'))            return Colors.cyan;
    if (p.contains('xiaomi'))          return Colors.orange;
    if (p.contains('philips hue'))     return Colors.yellow.shade800;
    if (p.contains('ikea'))            return Colors.blue.shade800;
    if (p.contains('mqtt'))            return Colors.deepOrange;
    if (p.contains('zigbee'))          return Colors.green.shade800;
    if (p.contains('meross'))          return Colors.deepPurple;
    return Colors.blueGrey;
  }

  static IconData _protocolIcon(String p) {
    p = p.toLowerCase();
    if (p.contains('camera'))          return Icons.videocam;
    if (p.contains('home assistant'))  return Icons.home;
    if (p.contains('openhab'))         return Icons.hub;
    if (p.contains('matter'))          return Icons.device_hub;
    if (p.contains('mqtt'))            return Icons.cloud_queue;
    if (p.contains('tasmota') ||
        p.contains('esphome') ||
        p.contains('ewelink') ||
        p.contains('shelly'))          return Icons.electrical_services;
    if (p.contains('tp-link') ||
        p.contains('kasa'))            return Icons.power;
    if (p.contains('hue'))             return Icons.lightbulb;
    if (p.contains('zigbee'))          return Icons.blur_circular;
    return Icons.devices_other;
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final IotConfidence confidence;
  const _ConfidenceBadge(this.confidence);

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (confidence) {
      IotConfidence.definite  => ('✓ definite',  Colors.green),
      IotConfidence.probable  => ('~ probable',  Colors.orange),
      IotConfidence.possible  => ('? possible',  Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color)),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color  color;
  const _Chip(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, color: color)),
    );
  }
}
