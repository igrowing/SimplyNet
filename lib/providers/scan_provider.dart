import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/foreground_service.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/scan_storage.dart';

enum ScanSortColumn { ip, mac, hostname }

class ScanProvider extends ChangeNotifier {
  // ── Network target ────────────────────────────────────────────────────────
  String _target = '';
  String get target => _target;
  bool get isValidTarget => NetworkScanner.isValidCidr(_target);

  void setTarget(String v) {
    _target = v;
    notifyListeners();
  }

  // ── Scan state ────────────────────────────────────────────────────────────
  List<HostResult> _results = [];

  /// While scanning, results are returned in arrival order so the table fills
  /// live without rows jumping around. Once the scan finishes (or when showing
  /// cached results) the active sort column/direction is applied.
  List<HostResult> get results =>
      _isScanning ? List.unmodifiable(_results) : _sortedResults();

  /// Unsorted raw results — used by IoT and camera screens to reuse
  /// the already-discovered host list without triggering a re-sort.
  List<HostResult> get rawResults => List.unmodifiable(_results);

  /// True when we have a completed (non-scanning) result set for [cidr].
  /// IoT/camera screens use this to skip a redundant full network scan.
  bool hasValidResults(String cidr) =>
      !_isScanning && _results.isNotEmpty && _target == cidr;

  /// Wipe the cached host list without starting a new scan.
  /// Call this when the user explicitly requests a Rescan on IoT / camera
  /// screens so the next hasValidResults() check returns false and forces
  /// a fresh full subnet discovery.
  void clearCache() {
    _results = [];
    notifyListeners();
  }

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  ScanSortColumn _sortColumn = ScanSortColumn.ip;
  bool _sortAsc = true;
  ScanSortColumn get sortColumn => _sortColumn;
  bool get sortAsc => _sortAsc;

  StreamSubscription? _sub;
  final StringBuffer _logBuffer = StringBuffer();

  /// Current scan log text. Exposed so the log accumulated by [startScan]
  /// can be asserted in tests.
  @visibleForTesting
  String get logText => _logBuffer.toString();

  // Notifier so LogProvider can refresh when a new log is written
  final ValueNotifier<int> logVersion = ValueNotifier(0);

  void toggleSort(ScanSortColumn col) {
    if (_sortColumn == col) {
      _sortAsc = !_sortAsc;
    } else {
      _sortColumn = col;
      _sortAsc = true;
    }
    notifyListeners();
  }

  List<HostResult> _sortedResults() => sortHosts(_results, _sortColumn, _sortAsc);

  /// Pure sort used by [results]. Returns a new list of [hosts] ordered by
  /// [column]; [ascending] reverses the order. Kept side-effect free so the
  /// ordering logic can be exercised directly.
  static List<HostResult> sortHosts(
    List<HostResult> hosts,
    ScanSortColumn column,
    bool ascending,
  ) {
    final list = List<HostResult>.from(hosts);
    list.sort((firstHost, secondHost) {
      int comparison;
      switch (column) {
        case ScanSortColumn.ip:
          comparison = ipCompare(firstHost.ip, secondHost.ip);
        case ScanSortColumn.mac:
          comparison = firstHost.mac.compareTo(secondHost.mac);
        case ScanSortColumn.hostname:
          comparison = firstHost.hostname.compareTo(secondHost.hostname);
      }
      return ascending ? comparison : -comparison;
    });
    return list;
  }

  /// Numeric comparison of two dotted-quad IPv4 strings.
  static int ipCompare(String a, String b) {
    int toInt(String ip) {
      final ipOctets = ip.split('.').map(int.parse).toList();
      return (ipOctets[0] << 24) | (ipOctets[1] << 16) | (ipOctets[2] << 8) | ipOctets[3];
    }
    return toInt(a).compareTo(toInt(b));
  }

  void startScan({bool resolveNames = true, bool logging = true}) {
    if (!isValidTarget) return;
    _sub?.cancel();
    _results = [];
    _isScanning = true;
    _logBuffer.clear();
    _logBuffer.writeln('=== Scan started: $_target @ ${DateTime.now().toIso8601String()} ===');
    notifyListeners();

    // Start foreground service so Android doesn't freeze/kill the scan.
    FgService.start(title: 'Network scan', body: 'Scanning $_target…');

    _sub = NetworkScanner.scan(_target, resolveNames: resolveNames).listen((host) {
        // De-duplicate by IP: the scanner emits each host first when it is
        // discovered (MAC pending) and again once enriched with MAC/vendor.
        final idx = _results.indexWhere((h) => h.ip == host.ip);
        if (idx >= 0) {
          _results[idx] = host;
        } else {
          _results.add(host);
          _logBuffer.writeln('FOUND  ${host.ip}\t${host.mac}\t${host.hostname}\t${host.manufacturer}');
        }
        notifyListeners();
      },
      onDone: () async {
        _isScanning = false;
        // Sort by IP when the scan completes.
        _sortColumn = ScanSortColumn.ip;
        _sortAsc = true;
        _logBuffer.writeln('\nScan complete. ${_results.length} host(s) found.');
        _logBuffer.writeln('=== End: ${DateTime.now().toIso8601String()} ===');
        // Stop the foreground service; show "done" in the notification briefly.
        FgService.stop(doneBody: 'Scan complete — ${_results.length} host(s) found.');
        notifyListeners();
        await _saveCache();
        if (logging) {
          try {
            await LogService.createLog(
              function: 'scan',
              content: _logBuffer.toString(),
              summary: 'Scan $_target — ${_results.length} host(s) found',
            );
            logVersion.value++;
          } catch (e) {
            debugPrint('LogService.createLog failed: $e');
          }
        }
      },
      onError: (Object e, StackTrace st) async {
        _isScanning = false;
        _logBuffer.writeln('\nScan ERROR: $e');
        _logBuffer.writeln(st.toString());
        notifyListeners();
        if (logging) {
          try {
            await LogService.createLog(
              function: 'scan_error',
              content: _logBuffer.toString(),
              summary: 'Scan $_target — ERROR: $e',
            );
            logVersion.value++;
          } catch (le) {
            debugPrint('LogService.createLog (error path) failed: $le');
          }
        }
      },
    );
  }

  void stopScan() {
    _sub?.cancel();
    _isScanning = false;
    // Keep whatever was found so far and sort it by IP — the partial list is
    // still useful and gets persisted so the screen can reload it later.
    _sortColumn = ScanSortColumn.ip;
    _sortAsc = true;
    FgService.stop(doneBody: 'Scan stopped.');
    notifyListeners();
    _saveCache();
  }

  // ── Local-storage cache ─────────────────────────────────────────────────
  // Persist the last results so the Scan screen can reload them on open
  // instead of starting a fresh scan automatically.

  Future<void>? _cacheLoad;
  bool _autoScanned = false;

  /// Load the last persisted scan results (if any) from local storage.
  /// Memoised so [shouldAutoScan] can await the same load.
  Future<void> loadCache() => _cacheLoad ??= _loadCache();

  Future<void> _loadCache() async {
    try {
      final snap = await ScanStorage.load(ScanStorage.kScanHosts);
      if (snap == null) return;
      _results = snap.items.map(HostResult.fromJson).toList();
      _target = snap.cidr;
      notifyListeners();
    } on FormatException {
      // Corrupt cache — discard it and start empty.
      await ScanStorage.clear(ScanStorage.kScanHosts);
    }
  }

  /// Returns true (at most once) when, after the cached results have finished
  /// loading, there is still nothing to show — signalling the screen to start
  /// an automatic first scan. Subsequent calls return false so a network with
  /// no devices is not rescanned on every visit.
  Future<bool> shouldAutoScan() async {
    await loadCache();
    if (_autoScanned || _isScanning) return false;
    _autoScanned = true;
    return _results.isEmpty;
  }

  Future<void> _saveCache() async {
    if (_results.isEmpty) return;
    await ScanStorage.save(
      ScanStorage.kScanHosts,
      _target,
      _results.map((h) => h.toJson()).toList(),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    logVersion.dispose();
    super.dispose();
  }
}
