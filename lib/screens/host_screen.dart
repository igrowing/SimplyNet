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
  // ── Diag state ───────────────────────────────────────────────────────────
  _DiagTool? _activeTool;
  bool _diagRunning = false;
  final StringBuffer _diagOutput = StringBuffer();
  StreamSubscription? _diagSub;
  final ScrollController _diagScroll = ScrollController();

  // Ping count
  int _pingCount = 10;
  final TextEditingController _pingCountCtrl = TextEditingController(text: '10');

  // ── Port scan state ───────────────────────────────────────────────────────
  bool _portScanning = true;
  int _portDone = 0;
  int _portTotal = NetworkTools.wellKnownPorts.length;
  final List<_OpenPort> _openPorts = [];
  StreamSubscription? _portSub;

  // Port scan settings
  bool _portSettingsVisible = false;
  bool _portUseWellKnown = true;  // true = well-known list, false = range
  int _portRangeStart = 1;
  int _portRangeEnd = 2048;
  bool _portTcp = true;
  bool _portUdp = false;
  final TextEditingController _portStartCtrl = TextEditingController(text: '1');
  final TextEditingController _portEndCtrl   = TextEditingController(text: '2048');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPortScan());
  }

  @override
  void dispose() {
    _diagSub?.cancel();
    _portSub?.cancel();
    _diagScroll.dispose();
    _pingCountCtrl.dispose();
    _portStartCtrl.dispose();
    _portEndCtrl.dispose();
    super.dispose();
  }

  // ── Port scan ─────────────────────────────────────────────────────────────

  void _runPortScan() {
    _portSub?.cancel();
    List<int>? ports;
    int rangeStart = 1, rangeEnd = 2048;
    if (_portUseWellKnown) {
      ports = NetworkTools.wellKnownPorts;
    } else {
      rangeStart = _portRangeStart;
      rangeEnd   = _portRangeEnd;
    }
    final total = ports != null ? ports.length : (rangeEnd - rangeStart + 1);
    setState(() {
      _portScanning = true;
      _portDone     = 0;
      _portTotal    = total;
      _openPorts.clear();
    });

    final buf = StringBuffer();
    _portSub = NetworkTools.portScan(
      widget.host.ip,
      ports:      ports,
      rangeStart: rangeStart,
      rangeEnd:   rangeEnd,
      useTcp:     _portTcp,
      useUdp:     _portUdp,
      onProgress: (done, _) => setState(() => _portDone = done),
    ).listen(
      (line) {
        buf.write(line);
        if (line.startsWith('OPEN')) {
          final parts = line.trim().split(RegExp(r'\s+'));
          if (parts.length >= 2) {
            final portProto = parts[1].split('/');
            final portNum = int.tryParse(portProto.first) ?? 0;
            setState(() => _openPorts.add(_OpenPort(
              port:  portNum,
              proto: parts[1],
              name:  parts.length > 2 ? parts[2] : '',
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
            content:  buf.toString(),
            summary:  'Port scan → ${widget.host.ip}: ${_openPorts.length} open',
          );
        }
      },
    );
  }

  void _stopPortScan() {
    _portSub?.cancel();
    setState(() => _portScanning = false);
  }

  // ── Diag tools ────────────────────────────────────────────────────────────

  void _runDiag(_DiagTool tool) {
    _diagSub?.cancel();
    setState(() {
      _activeTool  = tool;
      _diagRunning = true;
      _diagOutput.clear();
    });

    final count = int.tryParse(_pingCountCtrl.text) ?? 10;
    Stream<String> stream = switch (tool) {
      _DiagTool.ping    => NetworkTools.ping(widget.host.ip, count: count),
      _DiagTool.nslookup => NetworkTools.nslookup(widget.host.ip),
      _DiagTool.tracert  => NetworkTools.traceroute(widget.host.ip),
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
            content:  _diagOutput.toString(),
            summary:  '${tool.name.toUpperCase()} → ${widget.host.ip}',
          );
        }
      },
    );
  }

  void _stopDiag() {
    _diagSub?.cancel();
    setState(() => _diagRunning = false);
  }

  // ── Clipboard ─────────────────────────────────────────────────────────────

  void _copy(BuildContext ctx, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text('Copied: $value'),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ── URL launchers ─────────────────────────────────────────────────────────

  Future<void> _openHttp(BuildContext ctx) async {
    final uri = Uri.parse('http://${widget.host.ip}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Could not open browser')));
    }
  }

  Future<void> _openSsh(BuildContext ctx) async {
    final uri = Uri.parse('ssh://${widget.host.ip}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('No SSH app found. Install ConnectBot or Termius.')));
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final host       = widget.host;
    final isWide     = MediaQuery.of(context).size.width > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

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
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser (HTTP)',
            onPressed: () => _openHttp(context),
          ),
          IconButton(
            icon: const Icon(Icons.terminal),
            tooltip: 'Open SSH',
            onPressed: () => _openSsh(context),
          ),
        ],
      ),
      body: (isLandscape || isWide)
          ? Row(children: [
              Expanded(flex: 5, child: leftPane),
              const VerticalDivider(width: 1),
              Expanded(flex: 5, child: rightPane),
            ])
          : Column(children: [
              Expanded(flex: 6, child: leftPane),
              const Divider(height: 1),
              Expanded(flex: 5, child: rightPane),
            ]),
    );
  }

  // ── Info card ──────────────────────────────────────────────────────────────

  Widget _buildInfoCard(BuildContext context, HostResult host) {
    // Always show hostname row; display "—" when empty so it's always present.
    final rows = [
      ('IP Address',    host.ip),
      ('MAC Address',   host.mac),
      ('Hostname',      host.hostname.isEmpty ? '—' : host.hostname),
      if (host.manufacturer.isNotEmpty) ('Manufacturer', host.manufacturer),
      if (host.deviceType.isNotEmpty)   ('Device Type',  host.deviceType),
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

  // ── Ports card ────────────────────────────────────────────────────────────

  Widget _buildPortsCard(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(children: [
              Text('Open Ports',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: primary)),
              const Spacer(),
              if (_portScanning) ...[
                SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: primary),
                ),
                const SizedBox(width: 6),
                Text('$_portDone/$_portTotal',
                    style: TextStyle(fontSize: 11, color: primary)),
                const SizedBox(width: 8),
                // Stop port scan button
                IconButton(
                  icon: const Icon(Icons.stop_rounded, size: 20),
                  tooltip: 'Stop port scan',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _stopPortScan,
                ),
              ],
              const SizedBox(width: 8),
              // Settings button
              IconButton(
                icon: const Icon(Icons.tune, size: 20),
                tooltip: 'Port scan settings',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () =>
                    setState(() => _portSettingsVisible = !_portSettingsVisible),
              ),
              const SizedBox(width: 6),
              // Rescan button (only when not scanning)
              if (!_portScanning)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  tooltip: 'Re-scan ports',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _runPortScan,
                ),
            ]),

            // Port scan settings panel
            if (_portSettingsVisible) ...[
              const SizedBox(height: 10),
              _buildPortSettings(context),
              const Divider(height: 16),
            ],

            // Port list
            if (_openPorts.isEmpty && !_portScanning)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No open ports found.',
                    style: TextStyle(fontSize: 12)),
              )
            else
              ..._openPorts.map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(children: [
                      const Icon(Icons.circle, size: 8, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('${p.proto}',
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(p.name,
                          style: const TextStyle(fontSize: 12)),
                    ]),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildPortSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Port selection mode
        Row(children: [
          const Text('Ports:', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Well-known'),
            selected: _portUseWellKnown,
            onSelected: (v) => setState(() => _portUseWellKnown = true),
          ),
          const SizedBox(width: 6),
          ChoiceChip(
            label: const Text('Range'),
            selected: !_portUseWellKnown,
            onSelected: (v) => setState(() => _portUseWellKnown = false),
          ),
        ]),
        if (!_portUseWellKnown) ...[
          const SizedBox(height: 8),
          Row(children: [
            const Text('From:', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 6),
            SizedBox(
              width: 70,
              child: TextField(
                controller: _portStartCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    isDense: true, contentPadding: EdgeInsets.all(6)),
                onChanged: (v) =>
                    _portRangeStart = int.tryParse(v) ?? 1,
              ),
            ),
            const SizedBox(width: 10),
            const Text('To:', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 6),
            SizedBox(
              width: 70,
              child: TextField(
                controller: _portEndCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    isDense: true, contentPadding: EdgeInsets.all(6)),
                onChanged: (v) =>
                    _portRangeEnd = int.tryParse(v) ?? 2048,
              ),
            ),
          ]),
        ],
        const SizedBox(height: 8),
        // Protocol selection
        Row(children: [
          const Text('Protocol:', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Checkbox(
            value: _portTcp,
            onChanged: (v) => setState(() => _portTcp = v ?? true),
          ),
          const Text('TCP', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Checkbox(
            value: _portUdp,
            onChanged: (v) => setState(() => _portUdp = v ?? false),
          ),
          const Text('UDP', style: TextStyle(fontSize: 12)),
        ]),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.play_arrow, size: 16),
            label: const Text('Apply & Rescan'),
            onPressed: () {
              setState(() => _portSettingsVisible = false);
              _runPortScan();
            },
          ),
        ),
      ],
    );
  }

  // ── Diag panel ────────────────────────────────────────────────────────────

  Widget _buildDiagPanel(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Diagnostics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 8),

          // Ping row: button + count input
          Row(children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.wifi_tethering, size: 16),
              label: const Text('Ping'),
              onPressed: _diagRunning ? null : () => _runDiag(_DiagTool.ping),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _pingCountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  border: OutlineInputBorder(),
                  labelText: '×',
                ),
                onChanged: (v) => _pingCount = int.tryParse(v) ?? 10,
              ),
            ),
          ]),
          const SizedBox(height: 8),

          // NS-lookup & Traceroute on next row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.manage_search, size: 16),
                label: const Text('NS-lookup'),
                onPressed: _diagRunning
                    ? null
                    : () => _runDiag(_DiagTool.nslookup),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.route, size: 16),
                label: const Text('Traceroute'),
                onPressed: _diagRunning
                    ? null
                    : () => _runDiag(_DiagTool.tracert),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Output label + running indicator
          if (_activeTool != null)
            Row(children: [
              Expanded(
                child: Text(
                  '— ${_activeTool!.name.toUpperCase()} ${widget.host.ip} —',
                  style: const TextStyle(
                      fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
              if (_diagRunning) ...[
                const SizedBox(
                  width: 12, height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 4),
              ],
            ]),

          // Output terminal
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: SingleChildScrollView(
                controller: _diagScroll,
                child: Text(
                  _diagOutput.toString(),
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.lightGreenAccent),
                ),
              ),
            ),
          ),

          // Stop button — shown at the bottom while a diag is running
          if (_diagRunning)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.stop_rounded, size: 16),
                label: const Text('Stop'),
                style: OutlinedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.error),
                onPressed: _stopDiag,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _OpenPort {
  final int port;
  final String proto;
  final String name;
  const _OpenPort({required this.port, required this.proto, required this.name});
}

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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontFamily: 'monospace', fontSize: 12)),
          ),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.copy, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
