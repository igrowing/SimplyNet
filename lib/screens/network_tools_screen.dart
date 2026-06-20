import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simply_net/models/host_result.dart';
// import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/ip_camera_detector.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:simply_net/services/ookla_speed_test.dart';
import 'package:simply_net/screens/markdown_info_screen.dart';
import 'package:simply_net/providers/camera_scan_provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/widgets/diag_widgets.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/screens/iot_scan_screen.dart';
import 'package:simply_net/screens/wifi_channels_screen.dart';
import 'package:simply_net/screens/cellular_screen.dart';
import 'package:simply_net/services/foreground_service.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/providers/settings_provider.dart';

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
        icon: Icons.memory,
        title: 'IoT Devices',
        subtitle: 'Find Tasmota, Matter, ESPHome, Shelly & more',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => IotScanScreen(
                    cidr: context.read<ScanProvider>().target))),
      ),
      _ToolCard(
        icon: Icons.radar,
        title: 'Port Scan',
        subtitle: 'Scan open TCP/UDP ports on any host',
        color: Colors.purple,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PortScanScreen())),
      ),
      _ToolCard(
        icon: Icons.network_ping,
        title: 'Ping',
        subtitle: 'Continuous ping with live graph',
        color: Colors.teal,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PingScreen())),
      ),
      _ToolCard(
        icon: Icons.route,
        title: 'Traceroute',
        subtitle: 'Trace the path to any host, hop by hop',
        color: Colors.deepOrange,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const TracerouteScreen())),
      ),
      _ToolCard(
        icon: Icons.manage_search,
        title: 'Who Is…',
        subtitle: 'WHOIS, DNS & nslookup for any domain or IP',
        color: Colors.indigo,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const WhoisScreen())),
      ),
      _ToolCard(
        icon: Icons.wifi_find,
        title: 'Wi-Fi Channels',
        subtitle: 'RSSI per channel, 2.4 & 5 GHz interference map',
        color: Colors.cyan,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(
                builder: (_) => const WifiChannelsScreen())),
      ),
      _ToolCard(
        icon: Icons.cell_tower,
        title: 'Cellular Info',
        subtitle: 'Signal levels, cell ID, provider & tower data',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
            context, MaterialPageRoute(
                builder: (_) => const CellularScreen())),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Tools',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:    2,
            mainAxisSpacing:   10,
            crossAxisSpacing:  10,
            childAspectRatio:  1.55,
          ),
          itemCount: tools.length,
          itemBuilder: (_, i) => tools[i],
        ),
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

  // Serialize to JSON for storage
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'downloadMbps': downloadMbps,
    'uploadMbps': uploadMbps,
    'pingMs': pingMs,
  };

  // Deserialize from JSON
  factory _SpeedRecord.fromJson(Map<String, dynamic> json) => _SpeedRecord(
    timestamp: DateTime.parse(json['timestamp'] as String),
    downloadMbps: json['downloadMbps'] as double,
    uploadMbps: json['uploadMbps'] as double,
    pingMs: json['pingMs'] as double,
  );
}

/// Speed-test backend the user has selected.
enum SpeedProvider { cloudflare, ookla }

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

  // Selected provider + remembered Ookla consent (persisted).
  SpeedProvider _provider = SpeedProvider.cloudflare;
  bool _ooklaConsent = false;
  static const String _providerKey     = 'speed_test_provider';
  static const String _ooklaConsentKey = 'speed_test_ookla_consent';

  // Speed history (persisted to SharedPreferences)
  final List<_SpeedRecord> _history = [];
  static const String _storageKey = 'speed_test_history';

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs   = await SharedPreferences.getInstance();
      final consent = prefs.getBool(_ooklaConsentKey) ?? false;
      // Only restore Ookla if consent was previously granted.
      final ookla   = prefs.getString(_providerKey) == 'ookla' && consent;
      if (mounted) {
        setState(() {
          _ooklaConsent = consent;
          _provider = ookla ? SpeedProvider.ookla : SpeedProvider.cloudflare;
        });
      }
    } catch (e) {
      debugPrint('Failed to load speed test prefs: $e');
    }
  }

  Future<void> _persistProvider() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_providerKey,
          _provider == SpeedProvider.ookla ? 'ookla' : 'cloudflare');
    } catch (e) {
      debugPrint('Failed to persist speed test provider: $e');
    }
  }

  Future<void> _onProviderSelected(SpeedProvider p) async {
    if (p == _provider) return;
    if (p == SpeedProvider.cloudflare) {
      setState(() => _provider = SpeedProvider.cloudflare);
      await _persistProvider();
      return;
    }
    // Switching to Ookla — ask for consent once, then remember it.
    if (!_ooklaConsent) {
      final accepted = await _showOoklaConsent();
      if (accepted != true) return; // declined → keep Cloudflare
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_ooklaConsentKey, true);
      } catch (e) {
        debugPrint('Failed to persist Ookla consent: $e');
      }
      _ooklaConsent = true;
    }
    setState(() => _provider = SpeedProvider.ookla);
    await _persistProvider();
  }

  Future<bool?> _showOoklaConsent() => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Switch to Ookla?'),
          content: const Text(
              'Switching to Ookla requires connecting to third-party '
              'servers. Ookla collects and shares your IP address, device '
              'identifiers, and location data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Decline'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Accept'),
            ),
          ],
        ),
      );

  void _openInfo() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => const MarkdownInfoScreen(
        title: 'Speed Test Info',
        assetPath: 'assets/speedtest_info.md',
      ),
    ));
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        final list = (jsonDecode(json) as List)
            .map((e) => _SpeedRecord.fromJson(e as Map<String, dynamic>))
            .toList();
        setState(() => _history.addAll(list));
      }
    } catch (e) {
      debugPrint('Failed to load speed test history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_history.map((r) => r.toJson()).toList());
      await prefs.setString(_storageKey, json);
    } catch (e) {
      debugPrint('Failed to save speed test history: $e');
    }
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('This will permanently delete all measurement records.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() => _history.clear());
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove(_storageKey);
              } catch (e) {
                debugPrint('Failed to clear history: $e');
              }
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _runTest() async {
    setState(() {
      _testing = true;
      _download = null;
      _upload = null;
      _ping = null;
      _progress = 0;
      _status = _provider == SpeedProvider.ookla
          ? 'Finding server…'
          : 'Measuring ping…';
    });

    try {
      final r = _provider == SpeedProvider.ookla
          ? await _measureOokla()
          : await _measureCloudflare();

      final record = _SpeedRecord(
        timestamp: DateTime.now(),
        downloadMbps: r.dl,
        uploadMbps: r.ul,
        pingMs: r.ping,
      );

      setState(() {
        _upload = r.ul;
        _progress = 1.0;
        _status = 'Done';
        _testing = false;
        _history.insert(0, record); // newest first
      });

      await _saveHistory();
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _testing = false;
      });
    }
  }

  Future<({double dl, double ul, double ping})> _measureCloudflare() async {
    // Ping
    final pingSw = Stopwatch()..start();
    await http.get(Uri.parse('https://speed.cloudflare.com/__down?bytes=1'));
    pingSw.stop();
    final pingMs = pingSw.elapsedMilliseconds.toDouble();
    setState(() {
      _ping = pingMs;
      _progress = 0.15;
      _status = 'Testing download…';
    });

    // Download (25 MB)
    const dlBytes = 25 * 1024 * 1024;
    final dlSw = Stopwatch()..start();
    final dlReq = await http.get(
        Uri.parse('https://speed.cloudflare.com/__down?bytes=$dlBytes'));
    dlSw.stop();
    final dlMbps =
        (dlReq.bodyBytes.length * 8) / dlSw.elapsed.inMilliseconds / 1000;
    setState(() {
      _download = dlMbps;
      _progress = 0.6;
      _status = 'Testing upload…';
    });

    // Upload (10 MB)
    const ulBytes = 10 * 1024 * 1024;
    final payload = List.generate(ulBytes, (byteIndex) => byteIndex & 0xFF);
    final ulSw = Stopwatch()..start();
    await http.post(
      Uri.parse('https://speed.cloudflare.com/__up'),
      body: payload,
      headers: {'Content-Type': 'application/octet-stream'},
    );
    ulSw.stop();
    final ulMbps = (ulBytes * 8) / ulSw.elapsed.inMilliseconds / 1000;
    return (dl: dlMbps, ul: ulMbps, ping: pingMs);
  }

  Future<({double dl, double ul, double ping})> _measureOokla() async {
    final servers = await OoklaSpeedTest.fetchServers();
    if (servers.isEmpty) throw Exception('No Ookla servers available');
    final best = await OoklaSpeedTest.bestServer(servers);
    final server = best.server;
    setState(() {
      _ping = best.pingMs;
      _progress = 0.15;
      _status = 'Testing download…';
    });

    // Download (25 MB)
    const dlBytes = 25 * 1024 * 1024;
    final dlSw = Stopwatch()..start();
    final dlReq = await http
        .get(server.downloadUri(dlBytes))
        .timeout(const Duration(seconds: 40));
    dlSw.stop();
    final dlMbps =
        (dlReq.bodyBytes.length * 8) / dlSw.elapsed.inMilliseconds / 1000;
    setState(() {
      _download = dlMbps;
      _progress = 0.6;
      _status = 'Testing upload…';
    });

    // Upload (10 MB)
    const ulBytes = 10 * 1024 * 1024;
    final payload = List.generate(ulBytes, (byteIndex) => byteIndex & 0xFF);
    final ulSw = Stopwatch()..start();
    await http.post(
      server.uploadUri(),
      body: payload,
      headers: {'Content-Type': 'application/octet-stream'},
    ).timeout(const Duration(seconds: 40));
    ulSw.stop();
    final ulMbps = (ulBytes * 8) / ulSw.elapsed.inMilliseconds / 1000;
    return (dl: dlMbps, ul: ulMbps, ping: best.pingMs);
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
              style: FilledButton.styleFrom(
                backgroundColor: _provider == SpeedProvider.ookla
                    ? Colors.amber
                    : Colors.blue,
                foregroundColor: _provider == SpeedProvider.ookla
                    ? Colors.black
                    : Colors.white,
              ),
              icon: _testing
                  ? SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _provider == SpeedProvider.ookla
                              ? Colors.black
                              : Colors.white))
                  : const Icon(Icons.play_arrow),
              label: Text(_testing ? 'Testing…' : 'Start Test'),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<SpeedProvider>(
                value: _provider,
                onChanged: _testing
                    ? null
                    : (p) {
                        if (p != null) _onProviderSelected(p);
                      },
                items: const [
                  DropdownMenuItem(
                    value: SpeedProvider.cloudflare,
                    child: Text('Via Cloudflare'),
                  ),
                  DropdownMenuItem(
                    value: SpeedProvider.ookla,
                    child: Text('Via Ookla'),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'About the speed test',
                onPressed: _openInfo,
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Divider(),

          // ── History section ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Previous Measurements',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: primary)),
              if (_history.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearHistory,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Clear'),
                ),
            ],
          ),
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
                      .expand((e) => [
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 4),
                              child: Text(e.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SelectableText(e.value,
                                  style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13)),
                            ),
                          ])
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
    CameraDetectionMethod.specificPort   => 'Protocol port',
    CameraDetectionMethod.genericPortMfr => 'Known vendor',
    CameraDetectionMethod.genericPortHttp => 'HTTP fingerprint',
    CameraDetectionMethod.wsDiscovery    => 'WS-Discovery',
  };

  Color _methodColor(CameraDetectionMethod m) => switch (m) {
    CameraDetectionMethod.specificPort    => Colors.green,
    CameraDetectionMethod.genericPortMfr  => Colors.blue,
    CameraDetectionMethod.genericPortHttp => Colors.orange,
    CameraDetectionMethod.wsDiscovery     => Colors.purple,
  };

  IconData _methodIcon(CameraDetectionMethod m) => switch (m) {
    CameraDetectionMethod.specificPort    => Icons.videocam,
    CameraDetectionMethod.genericPortMfr  => Icons.business,
    CameraDetectionMethod.genericPortHttp => Icons.language,
    CameraDetectionMethod.wsDiscovery     => Icons.wifi_tethering,
  };

  @override
  Widget build(BuildContext context) {
    final cams     = context.watch<CameraScanProvider>();
    final results  = cams.results;
    final scanning = cams.scanning;
    final done     = cams.done;
    final total    = cams.total;
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Camera Scan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: scanning
                  ? const Icon(Icons.stop_rounded,
                      key: ValueKey('stop'), size: 26)
                  : const Icon(Icons.refresh_rounded,
                      key: ValueKey('refresh'), size: 24),
            ),
            tooltip: scanning ? 'Stop scan' : 'Re-scan',
            onPressed: _toggle,
          ),
        ],
      ),
      body: Column(
        children: [
          if (scanning && total > 0)
            LinearProgressIndicator(
                value: total > 0 ? done / total : null),
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
                children: CameraDetectionMethod.values.map((m) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_methodIcon(m), size: 14, color: _methodColor(m)),
                    const SizedBox(width: 4),
                    Text(_methodLabel(m),
                        style: TextStyle(fontSize: 11, color: _methodColor(m))),
                  ]),
                )).toList(),
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
                        leading: Icon(_methodIcon(c.method),
                            color: _methodColor(c.method)),
                        title: Row(children: [
                          Text(c.ip,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _methodColor(c.method)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(':${c.port}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _methodColor(c.method),
                                    fontFamily: 'monospace')),
                          ),
                        ]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.evidence,
                                style: const TextStyle(fontSize: 12)),
                            if (c.manufacturer.isNotEmpty)
                              Text(c.manufacturer,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic)),
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
// ════════════════════════════════════════════════════════════════════
//  4. WHOIS
// ════════════════════════════════════════════════════════════════════

// ── Who Is… Screen (WHOIS + DNS + nslookup combined) ─────────────────────────

class WhoisScreen extends StatefulWidget {
  final String? initialTarget;
  const WhoisScreen({super.key, this.initialTarget});
  @override
  State<WhoisScreen> createState() => _WhoisState();
}

class _WhoisState extends State<WhoisScreen> {
  final _ctrl      = TextEditingController();
  final _scroll    = ScrollController();
  final _buf       = StringBuffer();
  bool  _loading   = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialTarget?.isNotEmpty == true) {
      _ctrl.text = widget.initialTarget!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookup());
    }
  }

  @override
  void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  Future<void> _lookup() async {
    final q = _ctrl.text.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() { _loading = true; _buf.clear(); });

    final isIp = RegExp(r'^\\.?\\d{1,3}(\\.\\d{1,3}){3}$').hasMatch(q);

    // ── 1. DNS ─────────────────────────────────────────────────────────────
    _put('=== DNS Resolution ===');
    try {
      final addrs = await InternetAddress.lookup(q)
          .timeout(const Duration(seconds: 5));
      for (final a in addrs) {
        _put('${a.type == InternetAddressType.IPv6 ? "AAAA" : "A   "} : ${a.address}');
      }
    } catch (e) { _put('Forward lookup failed: $e'); }
    // Reverse PTR
    if (!isIp) {
      try {
        final addrs = await InternetAddress.lookup(q).timeout(const Duration(seconds: 3));
        if (addrs.isNotEmpty) {
          final rev = await addrs.first.reverse().timeout(const Duration(seconds: 3));
          if (rev.host != addrs.first.address) _put('PTR : ${rev.host}');
        }
      } catch (_) {}
    } else {
      try {
        final rev = await InternetAddress(q).reverse().timeout(const Duration(seconds: 3));
        if (rev.host != q) _put('PTR : ${rev.host}');
      } catch (_) {}
    }
    setState(() {});

    // ── 2. RDAP / WHOIS ────────────────────────────────────────────────────
    _put(''); _put('=== WHOIS / RDAP ===');
    try {
      final url = isIp
          ? 'https://rdap.org/ip/$q'
          : 'https://rdap.org/domain/$q';
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        if (isIp) {
          _put('Range   : ${data['startAddress']} – ${data['endAddress']}');
          _put('Name    : ${data['name'] ?? '–'}');
          _put('Type    : ${data['type'] ?? '–'}');
          _put('Country : ${data['country'] ?? '–'}');
        } else {
          _put('Domain  : ${data['ldhName'] ?? q}');
          _put('Status  : ${(data['status'] as List?)?.join(', ') ?? '–'}');
          for (final e in (data['events'] as List?) ?? []) {
            _put('${e['eventAction']}: ${e['eventDate']}');
          }
          final ns = (data['nameservers'] as List?) ?? [];
          if (ns.isNotEmpty) { _put(''); _put('Nameservers:'); for (final n in ns) _put('  ${n['ldhName']}'); }
        }
        for (final entity in (data['entities'] as List?) ?? []) {
          final roles = (entity['roles'] as List?) ?? [];
          final vcard = entity['vcardArray'] as List?;
          if (vcard != null && vcard.length > 1) {
            for (final f in vcard[1] as List) {
              if (f is List && f.length >= 4 && f[0] == 'fn') {
                _put('${roles.join('/')}: ${f[3]}');
              }
            }
          }
        }
      } else {
        _put('RDAP returned ${resp.statusCode}');
      }
    } catch (e) { _put('RDAP error: $e'); }
    setState(() {});

    // ── 3. DNS detail via NetworkTools.nslookup ─────────────────────────────────
    // Reuse the well-tested NetworkTools.nslookup stream instead of
    // shelling out to the nslookup binary (which is not accessible on
    // many Android builds via /system/bin/sh).
    _put(''); _put('=== DNS detail ===');
    try {
      await for (final line in NetworkTools.nslookup(q)
          .timeout(const Duration(seconds: 10))) {
        if (line.trim().isNotEmpty) _put(line.trim());
      }
    } catch (e) {
      _put('DNS detail unavailable: $e');
    }

        setState(() { _loading = false; });
    // Log the lookup result
    if (context.mounted) {
      final settings = context.read<SettingsProvider>().settings;
      if (settings.loggingEnabled) {
        await LogService.createLog(
          function: 'whois',
          content:  _buf.toString(),
          summary:  'Who Is → ${_ctrl.text.trim()}',
        );
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  void _put(String s) => _buf.writeln(s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Who Is…', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => _loading ? null : _lookup(),
                enabled: !_loading,
                decoration: InputDecoration(
                  hintText: 'Domain, IP address, or hostname',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _loading ? null : _lookup,
              icon: _loading
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.search),
              label: Text(_loading ? 'Looking up…' : 'Look up'),
            ),
          ]),
        ),
        Expanded(
          child: _buf.isEmpty && !_loading
              ? const Center(child: Text('Enter a domain, IP, or hostname',
                  style: TextStyle(color: Colors.grey)))
              : SingleChildScrollView(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: SelectableText(_buf.toString(),
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
        ),
      ]),
    );
  }
}

class PingScreen extends StatefulWidget {
  const PingScreen({super.key});
  @override
  State<PingScreen> createState() => _PingScreenState();
}

class _PingScreenState extends State<PingScreen> {
  final _ctrl        = TextEditingController();
  final _diagOutput  = StringBuffer();
  final _pingTimings = <double>[];
  StreamSubscription<String>? _sub;
  bool   _running    = false;
  int    _parsedUpTo = 0;
  final _scroll      = ScrollController();

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  //  TODO: refactor: use One subnet scan for IP cameras, General scan, and IOT devices search.
  void _toggle() {
    if (_running) {
      _sub?.cancel();
      FgService.stop(doneBody: 'Ping stopped.');
      setState(() => _running = false);
      // TODO: accomplish saving log after ping
      // _saveLog(partial: true);
    } else {
      final host = _ctrl.text.trim();
      if (host.isEmpty) return;
      FocusScope.of(context).unfocus();
      setState(() {
        _running    = true;
        _parsedUpTo = 0;
        _diagOutput.clear();
        _pingTimings.clear();
      });
      FgService.start(title: 'Ping', body: 'Pinging $host…');
      /// TODO: refactor: use rawResults ping scan cache if available. Scan if cache is empty.
      _sub = NetworkTools.ping(host, count: 50).listen(
        (chunk) {
          setState(() {
            _diagOutput.write(chunk);
            final (newMs, cursor) =
                parsePingTimings(_diagOutput.toString(), _parsedUpTo);
            _pingTimings.addAll(newMs);
            _parsedUpTo = cursor;
          });
        },
        onDone: () async {
          final (tail, _) =
              parsePingTimings(_diagOutput.toString(), _parsedUpTo);
          setState(() {
            _pingTimings.addAll(tail);
            _running = false;
          });
          FgService.stop(doneBody: 'Ping complete.');
          // TODO: accomplish saving log after ping
          // await _saveLog();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ping',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
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
                    backgroundColor: _running
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary),
              ),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _ctrl.text.isEmpty && !_running && _pingTimings.isEmpty
                  ? Center(
                      child: Text(
                        'Enter a host and press Go',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.4)),
                      ),
                    )
                  : DiagOutputPanel(
                      output:           _diagOutput.toString(),
                      isRunning:        _running,
                      isPing:           true,
                      pingTimings:      _pingTimings,
                      scrollController: _scroll,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  TRACEROUTE
// ════════════════════════════════════════════════════════════════════════════

class TracerouteScreen extends StatefulWidget {
  const TracerouteScreen({super.key});
  @override
  State<TracerouteScreen> createState() => _TracerouteScreenState();
}

class _TracerouteScreenState extends State<TracerouteScreen> {
  final _ctrl   = TextEditingController();
  final _logBuf = StringBuffer();
  StreamSubscription<TracertHop>? _sub;
  List<TracertHop> _hops = [];
  bool   _running = false;
  String _error   = '';

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _run() {
    final host = _ctrl.text.trim();
    if (host.isEmpty) return;
    FocusScope.of(context).unfocus();
    _sub?.cancel();
    setState(() {
      _running = true;
      _hops    = [];
      _error   = '';
      _logBuf.clear();
    });
    FgService.start(title: 'Traceroute', body: 'Tracing route to $host…');
    _sub = NetworkTools.tracerouteHops(host).listen(
      (hop) {
        _logBuf.writeln(_hopLogLine(hop));
        setState(() => _hops = [..._hops, hop]);
      },
      onError: (Object e) {
        setState(() { _error = '$e'; _running = false; });
        FgService.stop(doneBody: 'Traceroute failed.');
      },
      onDone: () async {
        setState(() => _running = false);
        FgService.stop(doneBody: 'Traceroute complete.');
        if (context.mounted) {
          final settings = context.read<SettingsProvider>().settings;
          if (settings.loggingEnabled) {
            await LogService.createLog(
              function: 'traceroute',
              content:  _logBuf.toString(),
              summary:  'Traceroute → ${_ctrl.text.trim()}',
            );
          }
        }
      },
    );
  }

  void _stop() {
    _sub?.cancel();
    FgService.stop(doneBody: 'Traceroute stopped.');
    setState(() => _running = false);
  }

  String _hopLogLine(TracertHop h) {
    final where = h.timedOut
        ? '* * * (no reply)'
        : (h.hostname != null ? '${h.hostname} (${h.ip})' : h.ip);
    final avg = h.avgMs == null
        ? '—'
        : '${h.avgMs!.toStringAsFixed(1)} ms avg';
    return '${h.hop.toString().padLeft(2)}  $where  $avg';
  }

  // ── Node classification ────────────────────────────────────────────────
  _TraceNode _nodeOf(TracertHop h) {
    if (h.timedOut) {
      return const _TraceNode('Hidden Node', Icons.shield_outlined,
          Colors.grey);
    }
    if (h.reached) {
      return const _TraceNode('Destination', Icons.cloud, Colors.blue);
    }
    if (h.hop == 1) {
      return const _TraceNode('Your Device', Icons.smartphone, Colors.teal);
    }
    return const _TraceNode('Network Hop', Icons.location_city,
        Colors.indigo);
  }

  static Color _latencyColor(double ms) {
    if (ms < 50)   return Colors.green;
    if (ms <= 150) return Colors.orange;
    return Colors.red;
  }

  void _showHiddenInfo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hidden Node'),
        content: const Text(
            'This router did not reply to our probes. Many ISPs, firewalls '
            'and security appliances deliberately drop or rate-limit ICMP '
            '(ping) traffic, so the hop stays anonymous even though your '
            'data still passes through it.\n\nThis is normal and does not '
            'mean the route is broken.'),
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
    return Scaffold(
      appBar: AppBar(
          title: const Text('Traceroute',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _running ? null : _run(),
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
                onPressed: _running ? _stop : _run,
                icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                label: Text(_running ? 'Stop' : 'Trace'),
                style: FilledButton.styleFrom(
                    backgroundColor: _running
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary),
              ),
            ]),
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(children: [
                Icon(Icons.error_outline,
                    size: 18, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 6),
                Expanded(child: Text(_error,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error))),
              ]),
            ),
          Expanded(
            child: _hops.isEmpty && !_running
                ? Center(
                    child: Text('Enter a host and press Trace',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.4))),
                  )
                : _buildTimeline(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final total = _hops.length + (_running ? 1 : 0);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: total,
      itemBuilder: (ctx, i) {
        final hasAbove = i > 0;
        final hasBelow = i < total - 1;
        if (i >= _hops.length) {
          return _railRow(
            context,
            icon: Icons.more_horiz,
            color: Colors.grey,
            hasAbove: hasAbove,
            hasBelow: hasBelow,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Row(children: [
                SizedBox(width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 10),
                Text('Probing next hop…',
                    style: TextStyle(color: Colors.grey)),
              ]),
            ),
          );
        }
        final h    = _hops[i];
        final node = _nodeOf(h);
        return _railRow(
          context,
          icon: node.icon,
          color: node.color,
          hasAbove: hasAbove,
          hasBelow: hasBelow,
          child: _hopCard(context, h, node),
        );
      },
    );
  }

  Widget _railRow(BuildContext context, {
    required IconData icon,
    required Color color,
    required bool hasAbove,
    required bool hasBelow,
    required Widget child,
  }) {
    final line = Theme.of(context).colorScheme.outlineVariant;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 44,
            child: Column(children: [
              Expanded(
                  child: Container(width: 2,
                      color: hasAbove ? line : Colors.transparent)),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              Expanded(
                  child: Container(width: 2,
                      color: hasBelow ? line : Colors.transparent)),
            ]),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _hopCard(BuildContext context, TracertHop h, _TraceNode node) {
    final dim    = h.timedOut;
    final addr   = h.hostname != null ? '${h.hostname} (${h.ip})' : h.ip;
    final subtle = Theme.of(context).colorScheme.onSurface
        .withValues(alpha: 0.6);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(
                    child: Text(node.label,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: dim ? Colors.grey : null)),
                  ),
                  if (dim) ...[
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: _showHiddenInfo,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(Icons.help_outline,
                            size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ]),
                const SizedBox(height: 3),
                Text(
                  dim ? 'Hop ${h.hop} · no reply' : 'Hop ${h.hop} · $addr',
                  style: TextStyle(fontSize: 12, color: subtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _latency(h),
        ]),
      ),
    );
  }

  Widget _latency(TracertHop h) {
    final avg = h.avgMs;
    if (avg == null) {
      return const Text('—',
          style: TextStyle(color: Colors.grey, fontFamily: 'monospace'));
    }
    final c = _latencyColor(avg);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 11, height: 11,
          decoration: BoxDecoration(shape: BoxShape.circle, color: c)),
      const SizedBox(width: 6),
      Text('${avg.round()} ms',
          style: TextStyle(
              color: c, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
    ]);
  }
}

/// Visual style for a traceroute node (label, icon, colour).
class _TraceNode {
  final String   label;
  final IconData icon;
  final Color    color;
  const _TraceNode(this.label, this.icon, this.color);
}

// ════════════════════════════════════════════════════════════════════════════
//  NSLOOKUP
// ════════════════════════════════════════════════════════════════════════════

// ── Port Scan Screen ──────────────────────────────────────────────────────────

class PortScanScreen extends StatefulWidget {
  const PortScanScreen({super.key});
  @override
  State<PortScanScreen> createState() => _PortScanScreenState();
}

class _PortScanScreenState extends State<PortScanScreen> {
  final _ctrl           = TextEditingController();
  final _scroll         = ScrollController();
  final _portStartCtrl  = TextEditingController(text: '1');
  final _portEndCtrl    = TextEditingController(text: '2048');

  bool _scanning         = false;
  bool _settingsVisible  = false;
  bool _useWellKnown     = true;
  bool _useTcp           = true;
  bool _useUdp           = false;
  int  _done             = 0;
  int  _total            = 0;
  final List<String> _openLines = [];
  StreamSubscription<String>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    _portStartCtrl.dispose();
    _portEndCtrl.dispose();
    super.dispose();
  }

  void _startScan() {
    final host = _ctrl.text.trim();
    if (host.isEmpty) return;
    FocusScope.of(context).unfocus();
    _sub?.cancel();

    List<int>? ports;
    int rangeStart = 1, rangeEnd = 2048;
    if (_useWellKnown) {
      ports = NetworkTools.wellKnownPorts;
    } else {
      rangeStart = int.tryParse(_portStartCtrl.text) ?? 1;
      rangeEnd   = int.tryParse(_portEndCtrl.text)   ?? 2048;
    }
    final total = ports != null ? ports.length : (rangeEnd - rangeStart + 1);

    setState(() {
      _scanning   = true;
      _done       = 0;
      _total      = total;
      _openLines.clear();
    });

    _sub = NetworkTools.portScan(
      host,
      ports:      ports,
      rangeStart: rangeStart,
      rangeEnd:   rangeEnd,
      useTcp:     _useTcp,
      useUdp:     _useUdp,
      onProgress: (d, _) => setState(() => _done = d),
    ).listen(
      (line) {
        if (line.startsWith('OPEN') || line.startsWith('===') ||
            line.startsWith('No open') || line.startsWith('\nDone')) {
          setState(() => _openLines.add(line.trim()));
        }
      },
      onDone: () async {
        setState(() => _scanning = false);
        if (context.mounted) {
          final settings = context.read<SettingsProvider>().settings;
          if (settings.loggingEnabled) {
            final openCount = _openLines.where((l) => l.startsWith('OPEN')).length;
            await LogService.createLog(
              function: 'portscan',
              content:  _openLines.join('\n'),
              summary:  'Port scan → ${_ctrl.text.trim()}: $openCount open',
            );
          }
        }
      },
    );
  }

  void _stopScan() {
    _sub?.cancel();
    setState(() => _scanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Port Scan', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(children: [
        // ── Input row ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => _scanning ? null : _startScan(),
                enabled: !_scanning,
                decoration: InputDecoration(
                  hintText: 'IP address or hostname',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _scanning
                  ? FilledButton.icon(
                      key: const ValueKey('stop'),
                      onPressed: _stopScan,
                      icon: const Icon(Icons.stop_rounded),
                      label: const Text('Stop'),
                      style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error),
                    )
                  : FilledButton.icon(
                      key: const ValueKey('scan'),
                      onPressed: _startScan,
                      icon: const Icon(Icons.search),
                      label: const Text('Scan'),
                    ),
            ),
          ]),
        ),
        // ── Settings toggle ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(children: [
            TextButton.icon(
              onPressed: () => setState(() => _settingsVisible = !_settingsVisible),
              icon: Icon(_settingsVisible ? Icons.expand_less : Icons.tune, size: 18),
              label: Text(_settingsVisible ? 'Hide settings' : 'Settings',
                  style: const TextStyle(fontSize: 12)),
            ),
            if (_scanning) ...[
              const Spacer(),
              Text('$_done / $_total', style: const TextStyle(fontSize: 12)),
            ],
          ]),
        ),
        if (_settingsVisible) _buildSettings(),
        if (_scanning)
          LinearProgressIndicator(value: _total > 0 ? _done / _total : null),
        // ── Results ──────────────────────────────────────────────────────────
        Expanded(
          child: _openLines.isEmpty && !_scanning
              ? const Center(child: Text('Enter a host and tap Scan',
                  style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  itemCount: _openLines.length,
                  itemBuilder: (_, i) {
                    final line = _openLines[i];
                    final isOpen = line.startsWith('OPEN');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(children: [
                        if (isOpen) ...[
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(line,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: isOpen ? Colors.green : null,
                                fontWeight: isOpen ? FontWeight.bold : null,
                              )),
                        ),
                        if (isOpen)
                          IconButton(
                            icon: const Icon(Icons.copy, size: 14),
                            tooltip: 'Copy',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                            onPressed: () => Clipboard.setData(ClipboardData(text: line)),
                          ),
                      ]),
                    );
                  },
                ),
        ),
      ]),
    );
  }

  Widget _buildSettings() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Port source
        Row(children: [
          const Text('Ports:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          ChoiceChip(
            label: const Text('Well-known'),
            selected: _useWellKnown,
            onSelected: (_) => setState(() => _useWellKnown = true),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Range'),
            selected: !_useWellKnown,
            onSelected: (_) => setState(() => _useWellKnown = false),
          ),
        ]),
        if (!_useWellKnown)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(children: [
              const Text('From:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              SizedBox(width: 70,
                child: TextField(
                  controller: _portStartCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(isDense: true,
                      border: OutlineInputBorder()),
                )),
              const SizedBox(width: 12),
              const Text('To:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              SizedBox(width: 70,
                child: TextField(
                  controller: _portEndCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(isDense: true,
                      border: OutlineInputBorder()),
                )),
            ]),
          ),
        const SizedBox(height: 8),
        // Protocol
        Row(children: [
          const Text('Protocol:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('TCP'),
            selected: _useTcp,
            onSelected: (v) => setState(() => _useTcp = v),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('UDP'),
            selected: _useUdp,
            onSelected: (v) => setState(() => _useUdp = v),
          ),
        ]),
      ]),
    );
  }
}

