import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/host_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // Per-column widths (flex units) — user can drag to resize
  double _wIp   = 3;
  double _wMac  = 3;
  double _wHost = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scan     = context.read<ScanProvider>();
      final settings = context.read<SettingsProvider>().settings;
      if (!scan.isScanning && scan.isValidTarget) {
        scan.startScan(
          resolveNames: settings.resolveNames,
          logging: settings.loggingEnabled,
        );
      }
    });
  }

  void _toggleScan() {
    final scan     = context.read<ScanProvider>();
    final settings = context.read<SettingsProvider>().settings;
    if (scan.isScanning) {
      scan.stopScan();
    } else if (scan.isValidTarget) {
      scan.startScan(
        resolveNames: settings.resolveNames,
        logging: settings.loggingEnabled,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scan     = context.watch<ScanProvider>();
    final settings = context.watch<SettingsProvider>().settings;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scan', style: TextStyle(fontWeight: FontWeight.bold)),
            if (scan.target.isNotEmpty)
              Text(scan.target, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          // Single toggle button: round-arrow (idle) ↔ square-stop (running)
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: scan.isScanning
                  ? const Icon(Icons.stop_rounded,
                      key: ValueKey('stop'), size: 28)
                  : const Icon(Icons.refresh_rounded,
                      key: ValueKey('refresh'), size: 26),
            ),
            tooltip: scan.isScanning ? 'Stop scan' : 'Re-scan',
            onPressed: scan.isValidTarget ? _toggleScan : null,
          ),
        ],
      ),
      body: Column(
        children: [
          if (scan.isScanning) const LinearProgressIndicator(),

          if (scan.results.isNotEmpty || scan.isScanning)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${scan.results.length} host(s) found',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),

          // Resizable header
          _ResizableHeader(
            scan: scan,
            showMac: settings.showMac,
            wIp: _wIp, wMac: _wMac, wHost: _wHost,
            onResize: (ip, mac, host) =>
                setState(() { _wIp = ip; _wMac = mac; _wHost = host; }),
          ),

          Expanded(
            child: scan.results.isEmpty && !scan.isScanning
                ? _EmptyState(isValid: scan.isValidTarget)
                : ListView.separated(
                    itemCount: scan.results.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, thickness: 0.5),
                    itemBuilder: (ctx, i) {
                      final host = scan.results[i];
                      return _ScanRow(
                        host: host,
                        settings: settings,
                        wIp: _wIp, wMac: _wMac, wHost: _wHost,
                        onTap: () => Navigator.push(
                          ctx,
                          MaterialPageRoute(
                              builder: (_) => HostScreen(host: host)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Resizable column header ───────────────────────────────────────────────────

class _ResizableHeader extends StatelessWidget {
  final ScanProvider scan;
  final bool showMac;
  final double wIp, wMac, wHost;
  final void Function(double ip, double mac, double host) onResize;

  const _ResizableHeader({
    required this.scan,
    required this.showMac,
    required this.wIp,
    required this.wMac,
    required this.wHost,
    required this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;

    Widget headerCell(
      String label,
      ScanSortColumn col,
      double flex,
    ) {
      final active = scan.sortColumn == col;
      return Expanded(
        flex: flex.round().clamp(1, 20),
        child: InkWell(
          onTap: () => scan.toggleSort(col),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12)),
                if (active)
                  Icon(
                    scan.sortAsc
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 12,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Drag divider between two columns: adjusts widths
    Widget divider(
      double leftFlex,
      double rightFlex,
      void Function(double, double) onDrag,
    ) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (d) {
          const unit = 0.01;
          final delta = d.delta.dx * unit;
          final newLeft  = (leftFlex  + delta).clamp(0.5, 10.0);
          final newRight = (rightFlex - delta).clamp(0.5, 10.0);
          onDrag(newLeft, newRight);
        },
        child: Container(
          width: 8,
          color: bg,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left, size: 10, color: Theme.of(context).dividerColor),
                Container(width: 1.5, height: 8, color: Theme.of(context).dividerColor),
                Icon(Icons.chevron_right, size: 10, color: Theme.of(context).dividerColor),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      color: bg,
      child: Row(
        children: [
          headerCell('IP', ScanSortColumn.ip, wIp),
          if (showMac) ...[
            divider(wIp, wMac,
                (l, r) => onResize(l, r, wHost)),
            headerCell('MAC', ScanSortColumn.mac, wMac),
            divider(wMac, wHost,
                (l, r) => onResize(wIp, l, r)),
          ] else
            divider(wIp, wHost,
                (l, r) => onResize(l, wMac, r)),
          headerCell('Hostname', ScanSortColumn.hostname, wHost),
        ],
      ),
    );
  }
}

// ── Row ───────────────────────────────────────────────────────────────────────

class _ScanRow extends StatelessWidget {
  final HostResult host;
  final dynamic settings;
  final double wIp, wMac, wHost;
  final VoidCallback onTap;

  const _ScanRow({
    required this.host,
    required this.settings,
    required this.wIp,
    required this.wMac,
    required this.wHost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        child: Row(
          children: [
            Expanded(
              flex: wIp.round().clamp(1, 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(host.ip,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
              ),
            ),
            if (settings.showMac)
              Expanded(
                flex: wMac.round().clamp(1, 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(host.mac,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                ),
              ),
            Expanded(
              flex: wHost.round().clamp(1, 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  host.hostname.isEmpty ? host.manufacturer : host.hostname,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isValid;
  const _EmptyState({required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            isValid ? 'No hosts found' : 'No network target set',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (!isValid)
            const Text('Set a target on the Home screen',
                style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
