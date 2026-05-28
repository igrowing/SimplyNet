import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:provider/provider.dart';

class NetworkToolsScreen extends StatelessWidget {
  const NetworkToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolCard(
        icon: Icons.speed,
        title: 'Speed Test',
        subtitle: 'Test download & upload speed',
        color: Colors.blue,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SpeedTestScreen())),
      ),
      _ToolCard(
        icon: Icons.public,
        title: 'My Public IP',
        subtitle: 'Discover your public IP, ISP & location',
        color: Colors.green,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PublicIpScreen())),
      ),
      _ToolCard(
        icon: Icons.videocam,
        title: 'IP Camera Scan',
        subtitle: 'Find cameras on your LAN',
        color: Colors.orange,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => IpCameraScanScreen(
                    cidr: context.read<ScanProvider>().target))),
      ),
      _ToolCard(
        icon: Icons.manage_search,
        title: 'Who Is…',
        subtitle: 'WHOIS lookup for any domain or IP',
        color: Colors.purple,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const WhoisScreen())),
      ),
      _ToolCard(
        icon: Icons.network_ping,
        title: 'Ping',
        subtitle: 'Continuous ping with live graph',
        color: Colors.teal,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PingScreen())),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Tools',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: tools.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) => tools[i],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon, required this.title, required this.subtitle,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  1. SPEED TEST  (with history section)
// ════════════════════════════════════════════════════════════════════

/// One historical speed measurement kept in memory for the session.
class _SpeedRecord {
  final DateTime timestamp;
  final double downloadMbps;
  final double uploadMbps;
  final double pingMs;
  const _SpeedRecord({
    required this.timestamp,
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
  });
}

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});
  @override
  State<SpeedTestScreen> createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTestScreen> {
  double? _download;
  double? _upload;
  double? _ping;
  bool _testing = false;
  String _status = 'Ready';
  double _progress = 0;

  // Speed history (session only — not persisted across app restart)
  final List<_SpeedRecord> _history = [];

  Future<void> _runTest() async {
    setState(() {
      _testing = true;
      _download = null;
      _upload = null;
      _ping = null;
      _progress = 0;
      _status = 'Measuring ping…';
    });

    try {
      // Ping
      final pingSw = Stopwatch()..start();
      await http.get(Uri.parse('https://speed.cloudflare.com/__down?bytes=1'));
      pingSw.stop();
      final pingMs = pingSw.elapsedMilliseconds.toDouble();
      setState(() { _ping = pingMs; _progress = 0.15; _status = 'Testing download…'; });

      // Download (25 MB)
      const dlBytes = 25 * 1024 * 1024;
      final dlSw = Stopwatch()..start();
      final dlReq = await http.get(
          Uri.parse('https://speed.cloudflare.com/__down?bytes=$dlBytes'));
      dlSw.stop();
      final dlMbps =
          (dlReq.bodyBytes.length * 8) / dlSw.elapsed.inMilliseconds / 1000;
      setState(() { _download = dlMbps; _progress = 0.6; _status = 'Testing upload…'; });

      // Upload (10 MB)
      const ulBytes = 10 * 1024 * 1024;
      final payload = List.generate(ulBytes, (i) => i & 0xFF);
      final ulSw = Stopwatch()..start();
      await http.post(
        Uri.parse('https://speed.cloudflare.com/__up'),
        body: payload,
        headers: {'Content-Type': 'application/octet-stream'},
      );
      ulSw.stop();
      final ulMbps = (ulBytes * 8) / ulSw.elapsed.inMilliseconds / 1000;

      final record = _SpeedRecord(
        timestamp: DateTime.now(),
        downloadMbps: dlMbps,
        uploadMbps: ulMbps,
        pingMs: pingMs,
      );

      setState(() {
        _upload = ulMbps;
        _progress = 1.0;
        _status = 'Done';
        _testing = false;
        _history.insert(0, record); // newest first
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _testing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Speed Test',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Current test section ────────────────────────────────────
          Text('Speed Test',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SpeedGauge(label: 'Download', value: _download,
                  unit: 'Mbps', icon: Icons.download, color: Colors.blue),
              _SpeedGauge(label: 'Upload', value: _upload,
                  unit: 'Mbps', icon: Icons.upload, color: Colors.orange),
              _SpeedGauge(label: 'Ping', value: _ping,
                  unit: 'ms', icon: Icons.timer, color: Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          if (_testing) ...[
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 10),
            Text(_status,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
          ],
          Center(
            child: FilledButton.icon(
              onPressed: _testing ? null : _runTest,
              icon: _testing
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.play_arrow),
              label: Text(_testing ? 'Testing…' : 'Start Test'),
            ),
          ),
          if (!_testing && _status == 'Done')
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Center(
                child: Text('Via Cloudflare',
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.45))),
              ),
            ),

          const SizedBox(height: 32),
          const Divider(),

          // ── History section ─────────────────────────────────────────
          Text('Previous Measurements',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 8),
          if (_history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No measurements yet.',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.45))),
              ),
            )
          else
            // Table header
            Column(
              children: [
                Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: Row(children: const [
                    _HistHeader('Date / Time', flex: 4),
                    _HistHeader('↓ Mbps',  flex: 2),
                    _HistHeader('↑ Mbps',  flex: 2),
                    _HistHeader('Ping ms', flex: 2),
                  ]),
                ),
                ..._history.map((r) => _HistoryRow(record: r)),
              ],
            ),
        ],
      ),
    );
  }
}

class _HistHeader extends StatelessWidget {
  final String label;
  final int flex;
  const _HistHeader(this.label, {required this.flex});
  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
    ),
  );
}

class _HistoryRow extends StatelessWidget {
  final _SpeedRecord record;
  const _HistoryRow({required this.record});

  @override
  Widget build(BuildContext context) {
    final ts = record.timestamp;
    final date =
        '${ts.year}-${ts.month.toString().padLeft(2,'0')}-${ts.day.toString().padLeft(2,'0')}'
        ' ${ts.hour.toString().padLeft(2,'0')}:${ts.minute.toString().padLeft(2,'0')}';
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).dividerColor, width: 0.5))),
      child: Row(children: [
        _Cell(date, flex: 4, mono: true),
        _Cell(record.downloadMbps.toStringAsFixed(1), flex: 2),
        _Cell(record.uploadMbps.toStringAsFixed(1),   flex: 2),
        _Cell(record.pingMs.toStringAsFixed(0),       flex: 2),
      ]),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;
  final bool mono;
  const _Cell(this.text, {required this.flex, this.mono = false});
  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontFamily: mono ? 'monospace' : null)),
    ),
  );
}

class _SpeedGauge extends StatelessWidget {
  final String label;
  final double? value;
  final String unit;
  final IconData icon;
  final Color color;

  const _SpeedGauge({
    required this.label, required this.value, required this.unit,
    required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                value != null ? value!.toStringAsFixed(1) : '–',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color),
              ),
              Text(unit,
                  style: TextStyle(
                      fontSize: 10,
                      color: color.withValues(alpha: 0.7))),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  2. PUBLIC IP
// ════════════════════════════════════════════════════════════════════

class PublicIpScreen extends StatefulWidget {
  const PublicIpScreen({super.key});
  @override
  State<PublicIpScreen> createState() => _PublicIpState();
}

class _PublicIpState extends State<PublicIpScreen> {
  Map<String, String>? _info;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http
          .get(Uri.parse('https://ipinfo.io/json'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        setState(() {
          _info = data.map((k, v) => MapEntry(k, v.toString()));
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'HTTP ${res.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Public IP',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loading ? null : _load),
          ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: (_info ?? {})
                      .entries
                      .map((e) => ListTile(
                            dense: true,
                            title: Text(e.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            trailing: SelectableText(e.value,
                                style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 13)),
                          ))
                      .toList(),
                ),
    );
  }
}

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
  final List<HostResult> _results = [];
  bool _scanning = false;
  int _done = 0;
  int _total = 0;
  StreamSubscription? _sub;

  static const _cameraPorts = [554, 8554, 8080, 80, 443, 37777];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _toggle() {
    if (_scanning) {
      _sub?.cancel();
      setState(() => _scanning = false);
    } else {
      _startScan();
    }
  }

  void _startScan() {
    _sub?.cancel();
    setState(() {
      _results.clear();
      _scanning = true;
      _done = 0;
      _total = 0;
    });

    final parsed = NetworkScanner.parseCidr(widget.cidr);
    if (parsed == null) {
      setState(() => _scanning = false);
      return;
    }
    final (baseIp, prefix) = parsed;

    // Expand CIDR to host list
    final octets = baseIp.split('.').map(int.parse).toList();
    final base = (octets[0] << 24) | (octets[1] << 16) |
        (octets[2] << 8) | octets[3];
    final mask = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net       = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);
    final hosts = <String>[];
    for (var i = net + 1; i < broadcast; i++) {
      hosts.add('${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}');
    }
    setState(() => _total = hosts.length);

    // Use NetworkTools.ipCameraScan which is properly bounded
    _sub = NetworkTools.ipCameraScan(
      widget.cidr,
      onProgress: (done, total) =>
          setState(() { _done = done; _total = total; }),
    ).listen(
      (line) {
        if (line.startsWith('CAMERA')) {
          final entry = line.trim().split(RegExp(r'\s+')).last;
          final parts = entry.split(':');
          if (parts.length >= 2) {
            setState(() => _results.add(HostResult(
              ip:           parts[0],
              manufacturer: 'Port ${parts[1]} open',
              deviceType:   'Possible Camera',
            )));
          }
        }
      },
      onDone: () => setState(() => _scanning = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Camera Scan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Single toggle button: refresh ↔ stop
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _scanning
                  ? const Icon(Icons.stop_rounded,
                      key: ValueKey('stop'), size: 26)
                  : const Icon(Icons.refresh_rounded,
                      key: ValueKey('refresh'), size: 24),
            ),
            tooltip: _scanning ? 'Stop scan' : 'Re-scan',
            onPressed: _toggle,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_scanning && _total > 0)
            LinearProgressIndicator(
                value: _total > 0 ? _done / _total : null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _scanning
                    ? 'Scanning… $_done/$_total hosts — ${_results.length} camera(s) found'
                    : '${_results.length} possible camera(s) found — ${widget.cidr}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty && !_scanning
                ? const Center(child: Text('No cameras found.'))
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, thickness: 0.5),
                    itemBuilder: (ctx, i) {
                      final h = _results[i];
                      return ListTile(
                        leading: const Icon(Icons.videocam,
                            color: Colors.orange),
                        title: Text(h.ip,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          [h.manufacturer, h.hostname]
                              .where((s) => s.isNotEmpty)
                              .join(' · '),
                          style: const TextStyle(fontSize: 12),
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

// ════════════════════════════════════════════════════════════════════
//  4. WHOIS
// ════════════════════════════════════════════════════════════════════

class WhoisScreen extends StatefulWidget {
  const WhoisScreen({super.key});
  @override
  State<WhoisScreen> createState() => _WhoisState();
}

class _WhoisState extends State<WhoisScreen> {
  final _ctrl = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _lookup() async {
    final query = _ctrl.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() { _loading = true; _result = ''; });
    try {
      final isDomain = !query.contains(RegExp(r'^\d')) &&
          query.contains('.') &&
          !query.startsWith('http');

      if (isDomain) {
        final rdap = await http
            .get(Uri.parse('https://rdap.org/domain/$query'))
            .timeout(const Duration(seconds: 10));
        if (rdap.statusCode == 200) {
          final data = json.decode(rdap.body) as Map<String, dynamic>;
          final buf = StringBuffer();
          buf.writeln('Domain   : ${data['ldhName'] ?? query}');
          buf.writeln('Status   : ${(data['status'] as List?)?.join(', ') ?? '–'}');
          final events = (data['events'] as List?) ?? [];
          for (final e in events) {
            buf.writeln('${e['eventAction']}: ${e['eventDate']}');
          }
          final ns = (data['nameservers'] as List?) ?? [];
          if (ns.isNotEmpty) {
            buf.writeln('\nNameservers:');
            for (final n in ns) buf.writeln('  ${n['ldhName']}');
          }
          final entities = (data['entities'] as List?) ?? [];
          for (final entity in entities) {
            final roles = (entity['roles'] as List?) ?? [];
            final vcard = (entity['vcardArray'] as List?);
            if (vcard != null && vcard.length > 1) {
              final fields = vcard[1] as List;
              for (final field in fields) {
                if (field is List && field.length >= 4 && field[0] == 'fn') {
                  buf.writeln('${roles.join('/')}: ${field[3]}');
                }
              }
            }
          }
          setState(() { _result = buf.toString(); _loading = false; });
          return;
        }
      }

      final ipRdap = await http
          .get(Uri.parse('https://rdap.org/ip/$query'))
          .timeout(const Duration(seconds: 10));
      if (ipRdap.statusCode == 200) {
        final data = json.decode(ipRdap.body) as Map<String, dynamic>;
        final buf = StringBuffer();
        buf.writeln('IP Range : ${data['startAddress']} – ${data['endAddress']}');
        buf.writeln('Name     : ${data['name'] ?? '–'}');
        buf.writeln('Type     : ${data['type'] ?? '–'}');
        buf.writeln('Country  : ${data['country'] ?? '–'}');
        final entities = (data['entities'] as List?) ?? [];
        for (final entity in entities) {
          final roles = (entity['roles'] as List?) ?? [];
          final vcard = (entity['vcardArray'] as List?);
          if (vcard != null && vcard.length > 1) {
            final fields = vcard[1] as List;
            for (final field in fields) {
              if (field is List && field.length >= 4 && field[0] == 'fn') {
                buf.writeln('${roles.join('/')}: ${field[3]}');
              }
            }
          }
        }
        setState(() { _result = buf.toString(); _loading = false; });
        return;
      }
      setState(() { _result = 'No results found.'; _loading = false; });
    } catch (e) {
      setState(() { _result = 'Error: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Who Is…',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _lookup(),
                    decoration: InputDecoration(
                      hintText: 'Domain or IP address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _loading ? null : _lookup,
                  child: _loading
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Lookup'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _result.isEmpty
                ? Center(
                    child: Text(
                      'Enter a domain or IP address',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4)),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      _result,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 13),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  5. PING GRAPH
// ════════════════════════════════════════════════════════════════════

class PingScreen extends StatefulWidget {
  const PingScreen({super.key});
  @override
  State<PingScreen> createState() => _PingState();
}

class _PingState extends State<PingScreen> {
  final _ctrl = TextEditingController();
  final List<double?> _samples = [];
  bool _running = false;
  Timer? _timer;
  double? _min, _max, _avg;
  int _sent = 0, _received = 0;
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      final host = _ctrl.text.trim();
      if (host.isEmpty) return;
      FocusScope.of(context).unfocus();
      setState(() {
        _running = true;
        _samples.clear();
        _sent = 0; _received = 0;
        _min = null; _max = null; _avg = null;
      });
      _scheduleNext(host);
    }
  }

  void _scheduleNext(String host) {
    _timer = Timer(const Duration(milliseconds: 800), () => _doPing(host));
  }

  Future<void> _doPing(String host) async {
    if (!_running || !mounted) return;
    _sent++;
    double? ms;
    final sw = Stopwatch()..start();
    try {
      final result = await Process.run(
        'ping', ['-c', '1', '-W', '2', host],
        runInShell: true,
      ).timeout(const Duration(seconds: 3));
      sw.stop();
      if (result.exitCode == 0) {
        ms = sw.elapsedMilliseconds.toDouble();
        _received++;
        _min = _min == null ? ms : math.min(_min!, ms);
        _max = _max == null ? ms : math.max(_max!, ms);
        _avg = (_samples.whereType<double>().fold(0.0, (a, b) => a + b) + ms) /
            _received;
      }
    } catch (_) { sw.stop(); }
    if (!mounted) return;
    setState(() => _samples.add(ms));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
    if (_running) _scheduleNext(host);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final loss = _sent > 0
        ? ((_sent - _received) / _sent * 100).toStringAsFixed(0)
        : '0';

    return Scaffold(
      appBar: AppBar(
          title: const Text('Ping',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _toggle(),
                    enabled: !_running,
                    decoration: InputDecoration(
                      hintText: 'IP address or hostname',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _toggle,
                  icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                  label: Text(_running ? 'Stop' : 'Go'),
                  style: FilledButton.styleFrom(
                      backgroundColor: _running ? Colors.red : primary),
                ),
              ],
            ),
          ),
          if (_samples.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip('Min',  _min != null ? '${_min!.toStringAsFixed(0)}ms' : '–'),
                  _StatChip('Avg',  _avg != null ? '${_avg!.toStringAsFixed(0)}ms' : '–'),
                  _StatChip('Max',  _max != null ? '${_max!.toStringAsFixed(0)}ms' : '–'),
                  _StatChip('Loss', '$loss%'),
                  _StatChip('Sent', '$_sent'),
                ],
              ),
            ),
          Expanded(
            child: _samples.isEmpty
                ? Center(
                    child: Text(
                      _running ? 'Pinging…' : 'Enter a host and press Go',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4)),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomPaint(
                      painter: _PingGraphPainter(
                          samples: _samples,
                          color: primary,
                          textColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6)),
                      child: const SizedBox.expand(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.55))),
      ],
    );
  }
}

class _PingGraphPainter extends CustomPainter {
  final List<double?> samples;
  final Color color;
  final Color textColor;

  const _PingGraphPainter({
    required this.samples, required this.color, required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;
    final validSamples = samples.whereType<double>().toList();
    if (validSamples.isEmpty) return;

    final maxVal    = validSamples.reduce(math.max) * 1.2;
    const minVal    = 0.0;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dotPaint     = Paint()..color = color;
    final timeoutPaint = Paint()..color = Colors.red;
    final gridPaint    = Paint()
      ..color = textColor.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const padding = 40.0;
    final chartW  = size.width - padding;
    final chartH  = size.height - padding;

    for (var i = 0; i <= 4; i++) {
      final y = padding / 2 + chartH * (1 - i / 4);
      canvas.drawLine(Offset(padding, y), Offset(size.width - 4, y), gridPaint);
      final label = ((maxVal - minVal) * i / 4).toStringAsFixed(0);
      textPainter
        ..text = TextSpan(
            text: '${label}ms',
            style: TextStyle(color: textColor, fontSize: 9))
        ..layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    final step = chartW / math.max(samples.length - 1, 1);
    final path = Path();
    bool moved = false;

    for (var i = 0; i < samples.length; i++) {
      final x = padding + i * step;
      final s = samples[i];
      if (s == null) {
        canvas.drawCircle(Offset(x, padding / 2 + chartH * 0.5), 4, timeoutPaint);
        moved = false;
        continue;
      }
      final y = padding / 2 + chartH * (1 - (s - minVal) / (maxVal - minVal));
      if (!moved) { path.moveTo(x, y); moved = true; }
      else          { path.lineTo(x, y); }
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_PingGraphPainter old) =>
      old.samples.length != samples.length ||
      old.samples.lastOrNull != samples.lastOrNull;
}
