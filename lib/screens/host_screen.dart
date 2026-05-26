import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:url_launcher/url_launcher.dart';

enum _DiagTool { ping, nslookup, tracert }

class HostScreen extends StatefulWidget {
  final HostResult host;
  const HostScreen({super.key, required this.host});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  // ── Diag tool state ─────────────────────────────────────────────────────
  _DiagTool? _activeTool;
  bool _diagRunning = false;
  final StringBuffer _diagOutput = StringBuffer();
  StreamSubscription? _diagSub;
  final ScrollController _diagScroll = ScrollController();

  // ── Port scan state ──────────────────────────────────────────────────────
  bool _portScanning = true;
  int _portDone = 0;
  final int _portTotal = NetworkTools.commonPorts.length;
  final List<_OpenPort> _openPorts = [];
  StreamSubscription? _portSub;

  @override
  void initState() {
    super.initState();
    // Auto-run port scan immediately
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPortScan());
  }

  @override
  void dispose() {
    _diagSub?.cancel();
    _portSub?.cancel();
    _diagScroll.dispose();
    super.dispose();
  }

  // ── Port scan ────────────────────────────────────────────────────────────

  void _runPortScan() {
    _portSub?.cancel();
    setState(() {
      _portScanning = true;
      _portDone = 0;
      _openPorts.clear();
    });

    final buf = StringBuffer();
    _portSub = NetworkTools.portScan(
      widget.host.ip,
      onProgress: (done, _) => setState(() => _portDone = done),
    ).listen(
      (line) {
        buf.write(line);
        // Parse "OPEN  80/tcp  http"
        if (line.startsWith('OPEN')) {
          final parts = line.trim().split(RegExp(r'\s+'));
          if (parts.length >= 3) {
            final portStr = parts[1].split('/').first;
            final portNum = int.tryParse(portStr) ?? 0;
            setState(() => _openPorts.add(_OpenPort(
              port: portNum,
              proto: parts[1],
              name: parts.length > 2 ? parts[2] : '',
            )));
          }
        }
      },
      onDone: () async {
        setState(() => _portScanning = false);
        final settings = context.read<SettingsProvider>().settings;
        if (settings.loggingEnabled) {
          await LogService.createLog(
            function: 'portscan',
            content: buf.toString(),
            summary: 'Port scan → ${widget.host.ip}: ${_openPorts.length} open',
          );
        }
      },
    );
  }

  // ── Diag tools ───────────────────────────────────────────────────────────

  void _runDiag(_DiagTool tool) {
    _diagSub?.cancel();
    setState(() {
      _activeTool = tool;
      _diagRunning = true;
      _diagOutput.clear();
    });

    Stream<String> stream = switch (tool) {
      _DiagTool.ping => NetworkTools.ping(widget.host.ip),
      _DiagTool.nslookup => NetworkTools.nslookup(widget.host.ip),
      _DiagTool.tracert => NetworkTools.traceroute(widget.host.ip),
    };

    _diagSub = stream.listen(
      (chunk) {
        setState(() => _diagOutput.write(chunk));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_diagScroll.hasClients) {
            _diagScroll.animateTo(
              _diagScroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });
      },
      onDone: () async {
        setState(() => _diagRunning = false);
        final settings = context.read<SettingsProvider>().settings;
        if (settings.loggingEnabled) {
          await LogService.createLog(
            function: tool.name,
            content: _diagOutput.toString(),
            summary: '${tool.name.toUpperCase()} → ${widget.host.ip}',
          );
        }
      },
    );
  }

  // ── Clipboard helper ─────────────────────────────────────────────────────

  void _copy(BuildContext ctx, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Copied: $value'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Launch helpers ───────────────────────────────────────────────────────

  Future<void> _openHttp(BuildContext ctx) async {
    final uri = Uri.parse('http://${widget.host.ip}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Could not open browser')),
        );
      }
    }
  }

  Future<void> _openSsh(BuildContext ctx) async {
    // SSH intent — works with ConnectBot / Termius etc.
    final uri = Uri.parse('ssh://${widget.host.ip}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('No SSH app found. Install ConnectBot or Termius.'),
          ),
        );
      }
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final host = widget.host;
    final isWide = MediaQuery.of(context).size.width > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final leftPane = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(context, host),
          const SizedBox(height: 12),
          _buildPortsCard(context),
        ],
      ),
    );

    final rightPane = _buildDiagPanel(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(host.ip,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (host.hostname.isNotEmpty)
              Text(host.hostname, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          // HTTP
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser (HTTP)',
            onPressed: () => _openHttp(context),
          ),
          // SSH
          IconButton(
            icon: const Icon(Icons.terminal),
            tooltip: 'Open SSH',
            onPressed: () => _openSsh(context),
          ),
        ],
      ),
      body: (isLandscape || isWide)
          ? Row(
              children: [
                Expanded(flex: 5, child: leftPane),
                const VerticalDivider(width: 1),
                Expanded(flex: 5, child: rightPane),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 6, child: leftPane),
                const Divider(height: 1),
                Expanded(flex: 5, child: rightPane),
              ],
            ),
    );
  }

  // ── Info card ─────────────────────────────────────────────────────────────

  Widget _buildInfoCard(BuildContext context, HostResult host) {
    final rows = [
      ('IP Address', host.ip),
      ('MAC Address', host.mac),
      if (host.hostname.isNotEmpty) ('Hostname', host.hostname),
      if (host.manufacturer.isNotEmpty) ('Manufacturer', host.manufacturer),
      if (host.deviceType.isNotEmpty) ('Device Type', host.deviceType),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Info',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )),
            const SizedBox(height: 8),
            ...rows.map((r) => _CopyableRow(
                  label: r.$1,
                  value: r.$2,
                  onCopy: () => _copy(context, r.$2),
                )),
          ],
        ),
      ),
    );
  }

  // ── Open ports card ───────────────────────────────────────────────────────

  Widget _buildPortsCard(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Open Ports',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        )),
                const Spacer(),
                if (_portScanning)
                  Row(children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2,
                          color: primary),
                    ),
                    const SizedBox(width: 6),
                    Text('$_portDone/$_portTotal',
                        style: Theme.of(context).textTheme.bodySmall),
                  ])
                else
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    tooltip: 'Re-scan ports',
                    onPressed: _runPortScan,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (_portScanning && _openPorts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(
                    value: _portTotal > 0 ? _portDone / _portTotal : null),
              )
            else if (_openPorts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No open ports found.',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5))),
              )
            else
              ..._openPorts.map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: primary),
                        const SizedBox(width: 8),
                        Text(p.proto,
                            style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(p.name,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.65))),
                        const Spacer(),
                        InkWell(
                          onTap: () => _copy(context, p.port.toString()),
                          child: const Icon(Icons.copy, size: 14),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  // ── Diag panel ────────────────────────────────────────────────────────────

  Widget _buildDiagPanel(BuildContext context) {
    return Column(
      children: [
        // Tool buttons
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DiagBtn(icon: Icons.speed, label: 'Ping',
                  tool: _DiagTool.ping, active: _activeTool,
                  running: _diagRunning, onRun: _runDiag),
              _DiagBtn(icon: Icons.search, label: 'NSLookup',
                  tool: _DiagTool.nslookup, active: _activeTool,
                  running: _diagRunning, onRun: _runDiag),
              _DiagBtn(icon: Icons.timeline, label: 'Traceroute',
                  tool: _DiagTool.tracert, active: _activeTool,
                  running: _diagRunning, onRun: _runDiag),
            ],
          ),
        ),

        if (_diagRunning)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: LinearProgressIndicator(),
          ),

        const SizedBox(height: 4),

        Expanded(
          child: _diagOutput.isEmpty && !_diagRunning
              ? Center(
                  child: Text('Select a diagnostic tool',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4))),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _diagScroll,
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 48),
                      child: SelectableText(
                        _diagOutput.toString(),
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.5),
                      ),
                    ),
                    if (_diagOutput.isNotEmpty)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton.filledTonal(
                          onPressed: () => setState(() => _diagOutput.clear()),
                          icon: const Icon(Icons.clear_all),
                          tooltip: 'Clear',
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ── Copyable info row ─────────────────────────────────────────────────────────

class _CopyableRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CopyableRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6))),
          ),
          Expanded(
            flex: 5,
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(Icons.copy,
                  size: 15,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Diag button ───────────────────────────────────────────────────────────────

class _DiagBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final _DiagTool tool;
  final _DiagTool? active;
  final bool running;
  final void Function(_DiagTool) onRun;

  const _DiagBtn({
    required this.icon, required this.label, required this.tool,
    required this.active, required this.running, required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = active == tool && running;
    return OutlinedButton.icon(
      onPressed: running ? null : () => onRun(tool),
      icon: isActive
          ? SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary))
          : Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────────

class _OpenPort {
  final int port;
  final String proto;
  final String name;
  const _OpenPort({required this.port, required this.proto, required this.name});
}
