import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/network_scanner.dart';
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
                width: 48,
                height: 48,
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
//  1. SPEED TEST
// ════════════════════════════════════════════════════════════════════

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});
  @override
  State<SpeedTestScreen> createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTestScreen> {
  double? _download; // Mbps
  double? _upload;
  double? _ping;
  bool _testing = false;
  String _status = 'Ready';
  double _progress = 0;

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
      // ── Ping ──────────────────────────────────────────────────────
      final pingSw = Stopwatch()..start();
      await http.get(Uri.parse('https://speed.cloudflare.com/__down?bytes=1'));
      pingSw.stop();
      final pingMs = pingSw.elapsedMilliseconds.toDouble();
      setState(() { _ping = pingMs; _progress = 0.15; _status = 'Testing download…'; });

      // ── Download ──────────────────────────────────────────────────
      // Cloudflare speed test endpoint
      const dlBytes = 25 * 1024 * 1024; // 25 MB
      final dlSw = Stopwatch()..start();
      final dlReq = await http.get(
        Uri.parse('https://speed.cloudflare.com/__down?bytes=$dlBytes'),
      );
      dlSw.stop();
      final dlMbps = (dlReq.bodyBytes.length * 8) /
          dlSw.elapsed.inMilliseconds /
          1000;
      setState(() { _download = dlMbps; _progress = 0.6; _status = 'Testing upload…'; });

      // ── Upload ────────────────────────────────────────────────────
      const ulBytes = 10 * 1024 * 1024; // 10 MB
      final payload = List.generate(ulBytes, (i) => i & 0xFF);
      final ulSw = Stopwatch()..start();
      await http.post(
        Uri.parse('https://speed.cloudflare.com/__up'),
        body: payload,
        headers: {'Content-Type': 'application/octet-stream'},
      );
      ulSw.stop();
      final ulMbps = (ulBytes * 8) / ulSw.elapsed.inMilliseconds / 1000;
      setState(() {
        _upload = ulMbps;
        _progress = 1.0;
        _status = 'Done';
        _testing = false;
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Results row
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
              const SizedBox(height: 32),
              if (_testing) ...[
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 12),
                Text(_status,
                    style: TextStyle(color: primary, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
              ],
              FilledButton.icon(
                onPressed: _testing ? null : _runTest,
                icon: _testing
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2,
                            color: Colors.white))
                    : const Icon(Icons.play_arrow),
                label: Text(_testing ? 'Testing…' : 'Start Test'),
              ),
              if (!_testing && _status == 'Done')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Via Cloudflare',
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.45))),
                ),
            ],
          ),
        ),
      ),
    );
  }
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
                    fontWeight: FontWeight.bold, fontSize: 16, color: color),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(unit,
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5))),
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
  Map<String, String> _info = {};
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
      final data = json.decode(res.body) as Map<String, dynamic>;
      setState(() {
        _info = {
          'IP Address': data['ip'] ?? '–',
          'Hostname': data['hostname'] ?? '–',
          'ISP / Org': data['org'] ?? '–',
          'City': data['city'] ?? '–',
          'Region': data['region'] ?? '–',
          'Country': data['country'] ?? '–',
          'Timezone': data['timezone'] ?? '–',
          'Location': data['loc'] ?? '–',
        };
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _copy(BuildContext ctx, String v) {
    Clipboard.setData(ClipboardData(text: v));
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text('Copied: $v'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Public IP',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: _load,
              tooltip: 'Refresh'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: _info.entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(e.key,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6))),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(e.value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  InkWell(
                                    onTap: () => _copy(context, e.value),
                                    child: const Icon(Icons.copy, size: 15),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  3. IP CAMERA SCAN
// ════════════════════════════════════════════════════════════════════

// Known camera streaming ports
const _cameraPorts = [
  554,   // RTSP
  8554,  // RTSP alt
  80,    // HTTP (many cameras)
  8080,  // HTTP alt
  443,   // HTTPS
  8443,  // HTTPS alt
  37777, // Dahua
  34567, // HiSilicon
  5543,  // SV3C
  9000,  // Foscam alt
  49152, // UPnP / Samsung
  2000,  // Axis
  8000,  // Hikvision
  8001,  // Hikvision alt
];

class IpCameraScanScreen extends StatefulWidget {
  final String cidr;
  const IpCameraScanScreen({super.key, required this.cidr});
  @override
  State<IpCameraScanScreen> createState() => _IpCameraScanState();
}

class _IpCameraScanState extends State<IpCameraScanScreen> {
  final List<HostResult> _results = [];
  bool _scanning = false;
  StreamSubscription? _sub;

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

  void _startScan() {
    _sub?.cancel();
    setState(() { _results.clear(); _scanning = true; });

    final parsed = NetworkScanner.parseCidr(widget.cidr);
    if (parsed == null) {
      setState(() => _scanning = false);
      return;
    }

    _sub = _cameraStream(widget.cidr).listen(
      (host) => setState(() => _results.add(host)),
      onDone: () => setState(() => _scanning = false),
    );
  }

  Stream<HostResult> _cameraStream(String cidr) async* {
    final parsed = NetworkScanner.parseCidr(cidr)!;
    final hosts = _expandCidr(parsed.$1, parsed.$2);
    const timeout = Duration(milliseconds: 600);
    const parallel = 32;

    final controller = StreamController<HostResult>();

    Future<void> probe(String ip) async {
      for (final port in _cameraPorts) {
        try {
          final sock = await Socket.connect(ip, port, timeout: timeout);
          sock.destroy();
          // Attempt HTTP grab for camera banner
          String banner = '';
          try {
            final res = await http
                .get(Uri.parse('http://$ip'))
                .timeout(const Duration(seconds: 2));
            banner = res.headers['server'] ?? '';
          } catch (_) {}
          controller.add(HostResult(
            ip: ip,
            hostname: banner.isNotEmpty ? banner : '',
            manufacturer: 'Port $port open',
            deviceType: 'Possible Camera',
          ));
          break; // one hit per IP is enough
        } catch (_) {}
      }
    }

    final futures = <Future>[];
    for (var i = 0; i < hosts.length; i++) {
      futures.add(probe(hosts[i]));
      if (futures.length >= parallel || i == hosts.length - 1) {
        await Future.wait(futures);
        futures.clear();
      }
    }
    await controller.close();
    yield* controller.stream;
  }

  List<String> _expandCidr(String baseIp, int prefix) {
    final octets = baseIp.split('.').map(int.parse).toList();
    final base = (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);
    final hosts = <String>[];
    for (var i = net + 1; i < broadcast; i++) {
      hosts.add(
          '${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}');
    }
    return hosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Camera Scan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _scanning ? null : _startScan,
            tooltip: 'Re-scan',
          ),
          if (_scanning)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: () {
                _sub?.cancel();
                setState(() => _scanning = false);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (_scanning) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_results.length} possible camera(s) found — ${widget.cidr}',
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
                        leading: const Icon(Icons.videocam, color: Colors.orange),
                        title: Text(h.ip,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            [h.manufacturer, h.hostname]
                                .where((s) => s.isNotEmpty)
                                .join(' · '),
                            style: const TextStyle(fontSize: 12)),
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
      // Use whois.iana.org via RDAP (JSON, works over HTTPS)
      // Try RDAP first (for domains)
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

          // Dates
          final events = (data['events'] as List?) ?? [];
          for (final e in events) {
            buf.writeln('${e['eventAction']}: ${e['eventDate']}');
          }

          // Nameservers
          final ns = (data['nameservers'] as List?) ?? [];
          if (ns.isNotEmpty) {
            buf.writeln('\nNameservers:');
            for (final n in ns) {
              buf.writeln('  ${n['ldhName']}');
            }
          }

          // Registrar
          final entities = (data['entities'] as List?) ?? [];
          for (final entity in entities) {
            final roles = (entity['roles'] as List?) ?? [];
            final vcard = (entity['vcardArray'] as List?);
            if (vcard != null && vcard.length > 1) {
              final fields = vcard[1] as List;
              for (final field in fields) {
                if (field is List && field.length >= 4) {
                  final type = field[0];
                  final val = field[3];
                  if (type == 'fn') {
                    buf.writeln(
                        '${roles.join('/')}: $val');
                  }
                }
              }
            }
          }
          setState(() { _result = buf.toString(); _loading = false; });
          return;
        }
      }

      // IP RDAP
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
                          child: CircularProgressIndicator(strokeWidth: 2,
                              color: Colors.white))
                      : const Text('Go'),
                ),
              ],
            ),
          ),
          if (_result.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      _result,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 13, height: 1.7),
                    ),
                  ),
                ),
              ),
            )
          else if (!_loading)
            Expanded(
              child: Center(
                child: Text('Enter a domain or IP above',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4))),
              ),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  5. PING with live graph
// ════════════════════════════════════════════════════════════════════

class PingScreen extends StatefulWidget {
  const PingScreen({super.key});
  @override
  State<PingScreen> createState() => _PingState();
}

class _PingState extends State<PingScreen> {
  final _ctrl = TextEditingController();
  final List<double?> _samples = []; // null = timeout
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
        _sent = 0;
        _received = 0;
        _min = null;
        _max = null;
        _avg = null;
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
            (_received);
      }
    } catch (_) {
      sw.stop();
    }
    if (!mounted) return;
    setState(() => _samples.add(ms));
    // Auto-scroll chart
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
          // Input + go/stop
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
                    backgroundColor: _running ? Colors.red : primary,
                  ),
                ),
              ],
            ),
          ),

          // Stats bar
          if (_samples.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip('Min', _min != null ? '${_min!.toStringAsFixed(0)}ms' : '–'),
                  _StatChip('Avg', _avg != null ? '${_avg!.toStringAsFixed(0)}ms' : '–'),
                  _StatChip('Max', _max != null ? '${_max!.toStringAsFixed(0)}ms' : '–'),
                  _StatChip('Loss', '$loss%'),
                  _StatChip('Sent', '$_sent'),
                ],
              ),
            ),

          // Graph
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
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
    required this.samples,
    required this.color,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    final validSamples = samples.whereType<double>().toList();
    if (validSamples.isEmpty) return;

    final maxVal = validSamples.reduce(math.max) * 1.2;
    final minVal = 0.0;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = color;
    final timeoutPaint = Paint()..color = Colors.red;
    final gridPaint = Paint()
      ..color = textColor.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const padding = 40.0;
    final chartW = size.width - padding;
    final chartH = size.height - padding;

    // Grid lines
    for (var i = 0; i <= 4; i++) {
      final y = padding / 2 + chartH * (1 - i / 4);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - 4, y),
        gridPaint,
      );
      final label = ((maxVal - minVal) * i / 4).toStringAsFixed(0);
      textPainter
        ..text = TextSpan(
            text: '${label}ms',
            style: TextStyle(color: textColor, fontSize: 9))
        ..layout();
      textPainter.paint(
          canvas, Offset(0, y - textPainter.height / 2));
    }

    // Plot
    final step = chartW / math.max(samples.length - 1, 1);
    final path = Path();
    bool moved = false;

    for (var i = 0; i < samples.length; i++) {
      final x = padding + i * step;
      final s = samples[i];
      if (s == null) {
        // Timeout
        canvas.drawCircle(
          Offset(x, padding / 2 + chartH * 0.5),
          4,
          timeoutPaint,
        );
        moved = false;
        continue;
      }
      final y = padding / 2 + chartH * (1 - (s - minVal) / (maxVal - minVal));
      if (!moved) {
        path.moveTo(x, y);
        moved = true;
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_PingGraphPainter old) =>
      old.samples.length != samples.length ||
      old.samples.lastOrNull != samples.lastOrNull;
}
