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
  double _wIp = 3;
  double _wMac = 3;
  double _wHost = 4;

  // The provider holds the last results (loaded from local storage at app
  // start), so the screen shows them without rescanning. Only when there is
  // nothing cached do we kick off an automatic first scan. A scan started here
  // keeps running in the background even after the user leaves, because the
  // provider outlives this screen.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoScan());
  }

  Future<void> _maybeAutoScan() async {
    final scan = context.read<ScanProvider>();
    if (!scan.isValidTarget) return;
    if (!await scan.shouldAutoScan() || !mounted) return;
    final settings = context.read<SettingsProvider>().settings;
    scan.startScan(
      resolveNames: settings.resolveNames,
      logging: settings.loggingEnabled,
    );
  }

  void _toggleScan() {
    final scan = context.read<ScanProvider>();
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

  void _showInfo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About this scan'),
        content: const Text(
          "Devices blocking ICMP (pings) will not appear here. Run the "
          "'IoT Devices' or 'IP Cameras' scan to locate them via their open "
          "ports and services.\n\n"
          "In Android 11+ devices, MAC addresses cannot be retrieved due to "
          "Google's privacy restrictions, so they are not displayed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About this scan',
            onPressed: _showInfo,
          ),
          // Single toggle button: round-arrow (idle) ↔ square-stop (running)
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: scan.isScanning
                  ? const Icon(
                      Icons.stop_rounded,
                      key: ValueKey('stop'),
                      size: 28,
                    )
                  : const Icon(
                      Icons.refresh_rounded,
                      key: ValueKey('refresh'),
                      size: 26,
                    ),
            ),
            tooltip: scan.isScanning ? 'Stop scan' : 'Re-scan',
            onPressed: scan.isValidTarget ? _toggleScan : null,
          ),
        ],
      ),
      body: Column(
        children: [
          if (scan.isScanning) const LinearProgressIndicator(),
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) =>
                  orientation == Orientation.landscape
                  ? _tableLayout(context, scan, settings)
                  : _cardLayout(context, scan, settings),
            ),
          ),
        ],
      ),
    );
  }

  void _openHost(BuildContext context, HostResult host) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => HostScreen(host: host)),
  );

  Widget _hostCount(ScanProvider scan) => Text(
    '${scan.results.length} host(s) found',
    style: const TextStyle(fontSize: 12),
  );

  // ── Landscape: resizable table ─────────────────────────────────────────────
  Widget _tableLayout(
    BuildContext context,
    ScanProvider scan,
    dynamic settings,
  ) {
    return Column(
      children: [
        if (scan.results.isNotEmpty || scan.isScanning)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(alignment: Alignment.centerLeft, child: _hostCount(scan)),
          ),
        _ResizableHeader(
          scan: scan,
          showMac: settings.showMac,
          wIp: _wIp,
          wMac: _wMac,
          wHost: _wHost,
          onResize: (ip, mac, host) => setState(() {
            _wIp = ip;
            _wMac = mac;
            _wHost = host;
          }),
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
                      wIp: _wIp,
                      wMac: _wMac,
                      wHost: _wHost,
                      onTap: () => _openHost(ctx, host),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Portrait: card list with sort dropdown ─────────────────────────────────
  Widget _cardLayout(
    BuildContext context,
    ScanProvider scan,
    dynamic settings,
  ) {
    return Column(
      children: [
        if (scan.results.isNotEmpty || scan.isScanning)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
            child: Row(
              children: [
                Expanded(child: _hostCount(scan)),
                _SortDropdown(
                  column: scan.sortColumn,
                  showMac: settings.showMac,
                  onChanged: scan.setSort,
                ),
              ],
            ),
          ),
        Expanded(
          child: scan.results.isEmpty && !scan.isScanning
              ? _EmptyState(isValid: scan.isValidTarget)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  itemCount: scan.results.length,
                  itemBuilder: (ctx, i) {
                    final host = scan.results[i];
                    return _ScanCard(
                      host: host,
                      showMac: settings.showMac,
                      onTap: () => _openHost(ctx, host),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Sort dropdown (portrait) ──────────────────────────────────────────────────

class _SortDropdown extends StatelessWidget {
  final ScanSortColumn column;
  final bool showMac;
  final ValueChanged<ScanSortColumn> onChanged;

  const _SortDropdown({
    required this.column,
    required this.showMac,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<ScanSortColumn>>[
      const DropdownMenuItem(value: ScanSortColumn.ip, child: Text('IP')),
      if (showMac)
        const DropdownMenuItem(value: ScanSortColumn.mac, child: Text('MAC')),
      const DropdownMenuItem(
        value: ScanSortColumn.hostname,
        child: Text('Hostname'),
      ),
    ];
    // MAC can be the active column from a previous session; fall back to IP when
    // it's hidden so the dropdown always has a valid selection.
    final value = (column == ScanSortColumn.mac && !showMac)
        ? ScanSortColumn.ip
        : column;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.sort, size: 18),
        const SizedBox(width: 4),
        DropdownButton<ScanSortColumn>(
          value: value,
          isDense: true,
          underline: const SizedBox.shrink(),
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          items: items,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

// ── Card (portrait) ───────────────────────────────────────────────────────────

class _ScanCard extends StatelessWidget {
  final HostResult host;
  final bool showMac;
  final VoidCallback onTap;

  const _ScanCard({
    required this.host,
    required this.showMac,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);
    final hostname = host.hostname.isEmpty ? host.manufacturer : host.hostname;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field(context, 'IP', host.ip, mono: true),
                    if (showMac) ...[
                      const SizedBox(height: 3),
                      _field(context, 'MAC', host.mac, mono: true),
                    ],
                    const SizedBox(height: 3),
                    _field(
                      context,
                      'Hostname',
                      hostname.isEmpty ? '—' : hostname,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: subtle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    String label,
    String value, {
    bool mono = false,
  }) {
    final subtle = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 78,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontFamily: mono ? 'monospace' : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

    Widget headerCell(String label, ScanSortColumn col, double flex) {
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
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                if (active)
                  Icon(
                    scan.sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
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
          final newLeft = (leftFlex + delta).clamp(0.5, 10.0);
          final newRight = (rightFlex - delta).clamp(0.5, 10.0);
          onDrag(newLeft, newRight);
        },
        child: Container(
          width: 48,
          color: Colors.transparent, // Ensures the entire 48px area captures touch gestures
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Keep icons and line closely grouped together
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Chevron
                Icon(
                  Icons.chevron_left,
                  size: 18,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
                ),
                // Central Vertical Divider Line
                Container(
                  width: 3.0,
                  height: 26, // Give it a more prominent vertical presence
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                // Right Chevron
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
                ),
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
            divider(wIp, wMac, (l, r) => onResize(l, r, wHost)),
            headerCell('MAC', ScanSortColumn.mac, wMac),
            divider(wMac, wHost, (l, r) => onResize(wIp, l, r)),
          ] else
            divider(wIp, wHost, (l, r) => onResize(l, wMac, r)),
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
                child: Text(
                  host.ip,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ),
            if (settings.showMac)
              Expanded(
                flex: wMac.round().clamp(1, 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Text(
                    host.mac,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: wHost.round().clamp(1, 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  host.hostname.isEmpty ? host.manufacturer : host.hostname,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
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
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            isValid ? 'No saved results' : 'No network target set',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            isValid
                ? 'Tap the refresh button to scan'
                : 'Set a target on the Home screen',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
