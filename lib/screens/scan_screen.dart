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
  @override
  void initState() {
    super.initState();
    // Auto-start scan when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scan = context.read<ScanProvider>();
      final settings = context.read<SettingsProvider>().settings;
      if (!scan.isScanning && scan.isValidTarget) {
        scan.startScan(
          resolveNames: settings.resolveNames,
          logging: settings.loggingEnabled,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<ScanProvider>();
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
          // Re-run button (cycled arrow), disabled while scanning
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Re-scan',
            onPressed: scan.isScanning || !scan.isValidTarget
                ? null
                : () => scan.startScan(
                      resolveNames: settings.resolveNames,
                      logging: settings.loggingEnabled,
                    ),
          ),
          // Stop button shown while scanning
          if (scan.isScanning)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined),
              tooltip: 'Stop scan',
              onPressed: scan.stopScan,
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          if (scan.isScanning) const LinearProgressIndicator(),

          // Host count
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

          // Table header
          _ScanHeader(scan: scan, settings: settings),

          // Results
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

// ── Table header ─────────────────────────────────────────────────────────────

class _ScanHeader extends StatelessWidget {
  final ScanProvider scan;
  final dynamic settings;
  const _ScanHeader({required this.scan, required this.settings});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      color: bg,
      child: Row(
        children: [
          _HeaderCell(label: 'IP', col: ScanSortColumn.ip, scan: scan, flex: 5),
          if (settings.showMac)
            _HeaderCell(label: 'MAC', col: ScanSortColumn.mac, scan: scan, flex: 5),
          if (settings.resolveNames)
            _HeaderCell(label: 'Hostname', col: ScanSortColumn.hostname,
                scan: scan, flex: 6),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final ScanSortColumn col;
  final ScanProvider scan;
  final int flex;
  const _HeaderCell({
    required this.label, required this.col,
    required this.scan, required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    final active = scan.sortColumn == col;
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => scan.toggleSort(col),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Text(label,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                    color: active ? primary : null,
                  )),
              if (active)
                Icon(
                  scan.sortAsc
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Table row ─────────────────────────────────────────────────────────────────

class _ScanRow extends StatelessWidget {
  final HostResult host;
  final dynamic settings;
  final VoidCallback onTap;
  const _ScanRow({required this.host, required this.settings, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Expanded(flex: 5,
                child: Text(host.ip, style: const TextStyle(fontSize: 13))),
            if (settings.showMac)
              Expanded(
                flex: 5,
                child: Text(host.mac,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                    overflow: TextOverflow.ellipsis),
              ),
            if (settings.resolveNames)
              Expanded(
                flex: 6,
                child: Text(
                  host.hostname.isEmpty ? '–' : host.hostname,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6)),
                  overflow: TextOverflow.ellipsis,
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
          Icon(Icons.network_check,
              size: 72,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            isValid ? 'Starting scan…' : 'Enter a valid CIDR first',
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}
