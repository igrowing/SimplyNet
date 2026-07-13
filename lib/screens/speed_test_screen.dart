import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/screens/markdown_info_screen.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/ookla_speed_test.dart';

// ════════════════════════════════════════════════════════════════════
//  1. SPEED TEST  (with history section)
// ════════════════════════════════════════════════════════════════════

/// One historical speed measurement kept in memory for the session.
class _SpeedRecord {
  final DateTime timestamp;
  final double downloadMbps;
  final double uploadMbps;
  final double pingMs;
  final SpeedProvider provider;
  const _SpeedRecord({
    required this.timestamp,
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    this.provider = SpeedProvider.cloudflare,
  });

  // Serialize to JSON for storage
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'downloadMbps': downloadMbps,
    'uploadMbps': uploadMbps,
    'pingMs': pingMs,
    'provider': provider.name,
  };

  // Deserialize from JSON
  factory _SpeedRecord.fromJson(Map<String, dynamic> json) => _SpeedRecord(
    timestamp: DateTime.parse(json['timestamp'] as String),
    downloadMbps: json['downloadMbps'] as double,
    uploadMbps: json['uploadMbps'] as double,
    pingMs: json['pingMs'] as double,
    provider: json['provider'] == 'ookla'
        ? SpeedProvider.ookla
        : SpeedProvider.cloudflare,
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
  String _status = 'ready';
  String _errorMsg = '';
  double _progress = 0;

  bool _aborted = false;
  http.Client? _dlClient;
  final List<HttpClient> _ulClients = [];
 
  // Selected provider + remembered Ookla consent (persisted).
  SpeedProvider _provider = SpeedProvider.cloudflare;
  bool _ooklaConsent = false;
  static const String _providerKey = 'speed_test_provider';
  static const String _ooklaConsentKey = 'speed_test_ookla_consent';
  static const Duration testDuration = Duration(seconds: 12);
  static const Duration tickDuration = Duration(milliseconds: 500);
  static const int threadCount = 4;

  // Speed history (persisted to SharedPreferences)
  final List<_SpeedRecord> _history = [];
  static const String _storageKey = 'speed_test_history';

  // History sorting: column 0=date, 1=download, 2=upload, 3=ping.
  // Default is date, descending (newest first).
  int _sortColumn = 0;
  bool _sortAsc = false;

  List<_SpeedRecord> get _sortedHistory {
    int cmp(_SpeedRecord a, _SpeedRecord b) {
      switch (_sortColumn) {
        case 1:
          return a.downloadMbps.compareTo(b.downloadMbps);
        case 2:
          return a.uploadMbps.compareTo(b.uploadMbps);
        case 3:
          return a.pingMs.compareTo(b.pingMs);
        default:
          return a.timestamp.compareTo(b.timestamp);
      }
    }

    final list = [..._history];
    list.sort((a, b) => _sortAsc ? cmp(a, b) : -cmp(a, b));
    return list;
  }

  void _onSort(int column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAsc = !_sortAsc;
      } else {
        _sortColumn = column;
        _sortAsc = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadPrefs();
  }

  @override
  void dispose() {
    // Abort any in-flight test so its sockets/timers don't outlive the screen.
    _aborted = true;
    try {
      _dlClient?.close();
    } catch (_) {}
    for (final c in _ulClients) {
      try {
        c.close(force: true);
      } catch (_) {}
    }
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final consent = prefs.getBool(_ooklaConsentKey) ?? false;
      // Only restore Ookla if consent was previously granted.
      final ookla = prefs.getString(_providerKey) == 'ookla' && consent;
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
      await prefs.setString(
        _providerKey,
        _provider == SpeedProvider.ookla ? 'ookla' : 'cloudflare',
      );
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

  Future<bool?> _showOoklaConsent() {
    final l = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.switchToOokla),
        content: Text(l.ooklaConsentBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.decline),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.accept),
          ),
        ],
      ),
    );
  }

  void _openInfo() {
    final l = AppLocalizations.of(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MarkdownInfoScreen(
          title: l.speedTestInfo,
          assetName: 'speedtest_info.md',
        ),
      ),
    );
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
        title: Text(AppLocalizations.of(context).clearHistoryTitle),
        content: Text(AppLocalizations.of(context).clearHistoryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).cancel),
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
            child: Text(AppLocalizations.of(context).clear),
          ),
        ],
      ),
    );
  }

  Future<void> _runTest() async {
    setState(() {
      _testing = true;
      _aborted = false;
      _download = null;
      _upload = null;
      _ping = null;
      _progress = 0;
      _status = _provider == SpeedProvider.ookla
          ? 'finding'
          : 'measuringPing';
    });

    try {
      final r = _provider == SpeedProvider.ookla
          ? await _measureOokla()
          : await _measureCloudflare();

      // Discard incomplete results if the user aborted the run.
      if (_aborted || !mounted) return;

      final record = _SpeedRecord(
        timestamp: DateTime.now(),
        downloadMbps: r.dl,
        uploadMbps: r.ul,
        pingMs: r.ping,
        provider: _provider,
      );

      setState(() {
        _upload = r.ul;
        _progress = 1.0;
        _status = 'done';
        _testing = false;
        _history.insert(0, record); // newest first
      });

      await _saveHistory();
    } catch (e, st) {
      // Discard incomplete results if the user aborted the run.
      if (_aborted || !mounted) return;
      setState(() {
        _status = 'error';
        _errorMsg = '$e';
        _testing = false;
      });
      await _logError(e, st);
    }
  }

  /// Abort an in-progress test and discard every partial measurement.
  void _abortTest() {
    _aborted = true;
    try {
      _dlClient?.close();
    } catch (_) {}
    for (final c in _ulClients) {
      try {
        c.close(force: true);
      } catch (_) {}
    }
    setState(() {
      _testing = false;
      _status = 'ready';
      _download = null;
      _upload = null;
      _ping = null;
      _progress = 0;
    });
  }

  /// Map the internal status token to a localized status string.
  String _statusText(AppLocalizations l) {
    switch (_status) {
      case 'finding':
        return l.findingServer;
      case 'measuringPing':
        return l.measuringPing;
      case 'download':
        return l.testingDownload;
      case 'upload':
        return l.testingUpload;
      case 'done':
        return l.statusDone;
      case 'error':
        return '${l.errorLabel}: $_errorMsg';
      default:
        return l.statusReady;
    }
  }

  /// Persist a diagnostic log only when a test fails (never on success).
  Future<void> _logError(Object e, StackTrace st) async {
    final provider = _provider == SpeedProvider.ookla ? 'Ookla' : 'Cloudflare';
    try {
      await LogService.createLog(
        function: 'speedtest',
        content: 'Provider: $provider\nError: $e\n\n$st',
        summary: 'Speed test ($provider) failed: $e',
      );
    } catch (logErr) {
      debugPrint('Failed to write speed test error log: $logErr');
    }
  }



  Future<({double dl, double ul, double ping})> _measureCloudflare() async {
    final pingSw = Stopwatch()..start();
    try {
      await http.get(
        Uri.parse('https://speed.cloudflare.com/__down?bytes=1'),
        headers: OoklaSpeedTest.headers, // Important to prevent Cloudflare 403
      );
    } catch (_) {}
    pingSw.stop();
    final pingMs = pingSw.elapsedMilliseconds.toDouble();

    setState(() {
      _ping = pingMs;
      _progress = 0.15;
      _status = 'download';
    });

    // Request 500MB to ensure high-speed networks don't finish before 10 seconds
    final dlMbps = await _runDownloadTest(
      Uri.parse('https://speed.cloudflare.com/__down?bytes=50000000'),
    );

    setState(() {
      _progress = 0.6;
      _status = 'upload';
    });

    final ulMbps = await _runUploadTest(
      Uri.parse('https://speed.cloudflare.com/__up'),
    );

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
      _status = 'download';
    });

    final dlMbps = await _runDownloadTest(
      server.downloadUri(100 * 1024 * 1024),
    );
    
    setState(() {
      _progress = 0.6;
      _status = 'upload';
    });
    
    final ulMbps = await _runUploadTest(server.uploadUri());
    
    return (dl: dlMbps, ul: ulMbps, ping: best.pingMs);
  }

  Future<double> _runDownloadTest(Uri url) async {
    final client = http.Client();
    _dlClient = client;
    final stopwatch = Stopwatch()..start();


    int bytesSinceLastTick = 0;
    double maxMbps = 0.0;
    double currentMbps = 0.0;
    
    // Store the exact speed of every 500ms window
    final List<double> tickSpeeds = [];

    final Timer trackingTimer = Timer.periodic(tickDuration, (timer) {
      if (_aborted || !mounted) {
        timer.cancel();
        return;
      }
      currentMbps =
          (bytesSinceLastTick * 8) / tickDuration.inMilliseconds / 1000;
      
      tickSpeeds.add(currentMbps);
      
      if (currentMbps > maxMbps) maxMbps = currentMbps;
      setState(() {
        _download = currentMbps;
        _progress = 0.15 + (0.45 * stopwatch.elapsedMilliseconds / testDuration.inMilliseconds);
      });
      bytesSinceLastTick = 0;
    });

    final Timer masterTimeout = Timer(testDuration, () {
      client.close(); // Forcibly severs the connection
    });

    Future<void> startDownloadThread() async {
      try {
        // The while loop guarantees the thread keeps pulling data
        // even if the file finishes downloading before 12s is up.
        while (stopwatch.elapsed < testDuration && !_aborted) {
          final request = http.Request('GET', url);
          request.headers.addAll(OoklaSpeedTest.headers);

          final response = await client.send(request);
          if (response.statusCode != 200) {
            // If server rejects the request (e.g., file too large),
            // wait briefly to prevent a tight crash-loop.
            await Future.delayed(const Duration(milliseconds: 250));
            continue;
          }

          await for (final chunk in response.stream) {

            bytesSinceLastTick += chunk.length;
            if (stopwatch.elapsed >= testDuration || _aborted) break;
          }
        }
      } catch (_) {
        // Expected when client is forcibly closed via masterTimeout
      }
    }

    final threads = List.generate(threadCount, (_) => startDownloadThread());
    await Future.wait(threads);

    stopwatch.stop();
    trackingTimer.cancel();
    masterTimeout.cancel();
    client.close();
    _dlClient = null;
 
    if (_aborted) return 0.0; // discarded — caller will not use the result

    // ── Steady-State Calculation ──
    double finalMbps = 0.0;
    // 3 seconds warmup = 6 ticks. Drop last chunk = 1 tick.
    if (tickSpeeds.length > 7) {
      final steadyState = tickSpeeds.sublist(6, tickSpeeds.length - 1);
      finalMbps = steadyState.reduce((a, b) => a + b) / steadyState.length;
    } else if (tickSpeeds.isNotEmpty) {
      // Fallback just in case the connection died early
      finalMbps = tickSpeeds.reduce((a, b) => a + b) / tickSpeeds.length;
    }

    if (mounted && !_aborted) {
      setState(() {
        _download = finalMbps; // Snap UI to the steady-state average
      });
    }
    return finalMbps;
  }

  Future<double> _runUploadTest(Uri url) async {
    const int chunkSize = 128 * 1024; // 128 KB chunks
    final List<int> chunkData = List.filled(chunkSize, 0);

    final stopwatch = Stopwatch()..start();


    int bytesSinceLastTick = 0;
    double maxMbps = 0.0;
    double currentMbps = 0.0;
    
    // Store the exact speed of every 500ms window
    final List<double> tickSpeeds = [];

    final Timer trackingTimer = Timer.periodic(tickDuration, (timer) {
      if (_aborted || !mounted) {
        timer.cancel();
        return;
      }
      currentMbps =
          (bytesSinceLastTick * 8) / tickDuration.inMilliseconds / 1000;
          
      tickSpeeds.add(currentMbps);
      
      if (currentMbps > maxMbps) maxMbps = currentMbps;
      setState(() {
        _upload = currentMbps;
        _progress = 0.6 + (0.4 * stopwatch.elapsedMilliseconds / testDuration.inMilliseconds);
      });
      bytesSinceLastTick = 0;
    });

    final clients = _ulClients;
    final Timer masterTimeout = Timer(testDuration, () {
      for (var c in clients) {
        c.close(force: true); // Sever sockets immediately
      }
    });

    Future<void> startUploadThread() async {
      final client = HttpClient();
      clients.add(client);
      try {
        final request = await client.postUrl(url);
        // Pretend to be a browser to prevent Cloudflare drops
        OoklaSpeedTest.headers.forEach((k, v) => request.headers.set(k, v));
        request.headers.set('Content-Type', 'application/octet-stream');

        Stream<List<int>> chunkStream() async* {
          while (stopwatch.elapsed < testDuration && !_aborted) {
            yield chunkData;
            // This is now accurate because yielding halts until TCP buffer clears

            bytesSinceLastTick += chunkSize;
          }
        }

        // Native socket handles backpressure accurately
        await request.addStream(chunkStream());
        await request.close();
      } catch (_) {
        // Expected when clients are force closed via masterTimeout
      }
    }

    final threads = List.generate(threadCount, (_) => startUploadThread());
    await Future.wait(threads);

    stopwatch.stop();
    trackingTimer.cancel();
    masterTimeout.cancel();
    for (var c in clients) {
      c.close(force: true);
    }

    _ulClients.clear();
 
    if (_aborted) return 0.0; // discarded — caller will not use the result

    // ── Steady-State Calculation ──
    double finalMbps = 0.0;
    // 3 seconds warmup = 6 ticks. Drop last chunk = 1 tick.
    if (tickSpeeds.length > 7) {
      final steadyState = tickSpeeds.sublist(6, tickSpeeds.length - 1);
      finalMbps = steadyState.reduce((a, b) => a + b) / steadyState.length;
    } else if (tickSpeeds.isNotEmpty) {
      // Fallback just in case the connection died early
      finalMbps = tickSpeeds.reduce((a, b) => a + b) / tickSpeeds.length;
    }

    if (mounted && !_aborted) {
      setState(() {
        _upload = finalMbps; // Snap UI to the steady-state average
      });
    }
    return finalMbps;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.toolSpeedTest,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Current test section ────────────────────────────────────
          Text(
            l.toolSpeedTest,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SpeedGauge(
                label: l.download,
                value: _download,
                unit: 'Mbps',
                icon: Icons.download,
                color: Colors.blue,
              ),
              _SpeedGauge(
                label: l.upload,
                value: _upload,
                unit: 'Mbps',
                icon: Icons.upload,
                color: Colors.orange,
              ),
              _SpeedGauge(
                label: l.toolPing,
                value: _ping,
                unit: 'ms',
                icon: Icons.timer,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_testing) ...[
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 10),
            Text(
              _statusText(l),
              textAlign: TextAlign.center,
              style: TextStyle(color: primary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
          ],
          Center(
            child: _testing
            // While testing the button becomes a red Stop that aborts the
            // run and discards any partial ping/download/upload result.
            ? FilledButton.icon(
                onPressed: _abortTest,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.stop),
                label: Text(l.stop),
              )
            : FilledButton.icon(
                onPressed: _runTest,
                style: FilledButton.styleFrom(
                  backgroundColor: _provider == SpeedProvider.ookla
                      ? Colors.amber
                      : Colors.blue,
                  foregroundColor: _provider == SpeedProvider.ookla
                      ? Colors.black
                      : Colors.white,
                ),
                icon: const Icon(Icons.play_arrow),
                label: Text(l.startTest),
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
                items: [
                  DropdownMenuItem(
                    value: SpeedProvider.cloudflare,
                    child: Text(l.viaCloudflare),
                  ),
                  DropdownMenuItem(
                    value: SpeedProvider.ookla,
                    child: Text(l.viaOokla),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: l.aboutSpeedTestTip,
                onPressed: _openInfo,
              ),
            ],
          ),
          if (!_testing && _status == 'error')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${l.errorLabel}: $_errorMsg',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),
          const Divider(),

          // ── History section ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.previousMeasurements,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              if (_history.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearHistory,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(l.clear),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  l.noMeasurements,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            )
          else
            // Table header
            Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      _HistHeader(
                        l.dateTime,
                        flex: 4,
                        active: _sortColumn == 0,
                        ascending: _sortAsc,
                        onTap: () => _onSort(0),
                      ),
                      _HistHeader(
                        '↓ Mbps',
                        flex: 2,
                        active: _sortColumn == 1,
                        ascending: _sortAsc,
                        onTap: () => _onSort(1),
                      ),
                      _HistHeader(
                        '↑ Mbps',
                        flex: 2,
                        active: _sortColumn == 2,
                        ascending: _sortAsc,
                        onTap: () => _onSort(2),
                      ),
                      _HistHeader(
                        'Ping ms',
                        flex: 2,
                        active: _sortColumn == 3,
                        ascending: _sortAsc,
                        onTap: () => _onSort(3),
                      ),
                    ],
                  ),
                ),
                ..._sortedHistory.map((r) => _HistoryRow(record: r)),
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
  final bool active;
  final bool ascending;
  final VoidCallback? onTap;
  const _HistHeader(
    this.label, {
    required this.flex,
    this.active = false,
    this.ascending = false,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            if (active)
              Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
              ),
          ],
        ),
      ),
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
        '${ts.year}-${ts.month.toString().padLeft(2, '0')}-${ts.day.toString().padLeft(2, '0')}'
        ' ${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';
    // Cloudflare → blue, Ookla → amber, matching the Start Test button.
    final color = record.provider == SpeedProvider.ookla
        ? Colors.amber.shade800
        : Colors.blue;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _Cell(date, flex: 4, mono: true, color: color),
          _Cell(record.downloadMbps.toStringAsFixed(1), flex: 2, color: color),
          _Cell(record.uploadMbps.toStringAsFixed(1), flex: 2, color: color),
          _Cell(record.pingMs.toStringAsFixed(0), flex: 2, color: color),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;
  final bool mono;
  final Color? color;
  const _Cell(this.text, {required this.flex, this.mono = false, this.color});
  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontFamily: mono ? 'monospace' : null,
          color: color,
        ),
      ),
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
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
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
                  color: color,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

