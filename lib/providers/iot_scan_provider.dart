import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/services/foreground_service.dart';
import 'package:simply_net/services/iot_scanner.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/scan_storage.dart';

/// Owns the IoT scan lifecycle so a running scan survives navigation away from
/// the IoT screen, and the last results can be reloaded from local storage.
class IotScanProvider extends ChangeNotifier {
  List<IotDevice> _devices = [];
  List<IotDevice> get devices => List.unmodifiable(_devices);

  bool _scanning = false;
  bool get scanning => _scanning;

  int _done = 0;
  int _total = 0;
  int get done => _done;
  int get total => _total;

  String _cidr = '';
  String get cidr => _cidr;

  bool _loggingEnabled = true;

  StreamSubscription<IotDevice>? _sub;
  Timer? _progressTimer;

  /// Load the last persisted IoT results (if any) from local storage.
  Future<void> loadCache() async {
    try {
      final snap = await ScanStorage.load(ScanStorage.kIotDevices);
      if (snap == null) return;
      _devices = snap.items.map(IotDevice.fromJson).toList();
      _cidr = snap.cidr;
      notifyListeners();
    } on FormatException {
      await ScanStorage.clear(ScanStorage.kIotDevices);
    }
  }

  /// Start an IoT scan of [cidr].
  ///
  /// When [knownIps] is supplied (a fresh host list from a previous full scan)
  /// only those hosts are probed; otherwise a full subnet sweep runs.
  void startScan(String cidr, {List<String>? knownIps, bool logging = true}) {
    if (_scanning) return;
    _sub?.cancel();
    _progressTimer?.cancel();
    _cidr = cidr;
    _loggingEnabled = logging;
    _devices = [];
    _scanning = true;
    _done = 0;
    _total = 0;
    notifyListeners();

    if (knownIps != null && knownIps.isNotEmpty) {
      // Fast path: probe only already-discovered live hosts.
      _total = knownIps.length;
      FgService.start(
        title: 'IoT Scan',
        body: 'Probing ${knownIps.length} known hosts…',
      );
      _sub = IotScanner.scanHosts(knownIps).listen(
        (dev) {
          _devices.add(dev);
          _done++;
          notifyListeners();
        },
        onDone: _onDone,
        onError: (_) => _onError(),
      );
    } else {
      // Full subnet sweep.
      final parts = cidr.split('/');
      final prefix = int.tryParse(parts.length > 1 ? parts[1] : '24') ?? 24;
      _total = (1 << (32 - prefix)) - 2;
      FgService.start(
        title: 'IoT Scan',
        body: 'Scanning $cidr for IoT devices…',
      );
      _sub = IotScanner.scanSubnet(cidr).listen(
        (dev) {
          _devices.add(dev);
          notifyListeners();
        },
        onDone: _onDone,
        onError: (_) => _onError(),
      );
      // Full scan gives no per-host progress — animate an approximate bar.
      _progressTimer = Timer.periodic(const Duration(milliseconds: 400), (t) {
        if (!_scanning) {
          t.cancel();
          return;
        }
        _done = (_done + 8).clamp(0, _total);
        notifyListeners();
      });
    }
  }

  void stopScan() {
    _sub?.cancel();
    _progressTimer?.cancel();
    _scanning = false;
    FgService.stop();
    _sortByIp();
    notifyListeners();
    _saveCache();
  }

  Future<void> _onDone() async {
    _scanning = false;
    _progressTimer?.cancel();
    _sortByIp();
    FgService.stop(
      doneBody: 'IoT scan complete — ${_devices.length} device(s) found.',
    );
    notifyListeners();
    await _saveCache();
    if (_loggingEnabled) await _writeLog();
  }

  void _onError() {
    _scanning = false;
    _progressTimer?.cancel();
    FgService.stop();
    notifyListeners();
  }

  void _sortByIp() =>
      _devices.sort((a, b) => ScanProvider.ipCompare(a.ip, b.ip));

  Future<void> _saveCache() async {
    if (_devices.isEmpty) return;
    await ScanStorage.save(
      ScanStorage.kIotDevices,
      _cidr,
      _devices.map((d) => d.toJson()).toList(),
    );
  }

  Future<void> _writeLog() async {
    final buf = StringBuffer();
    for (final dev in _devices) {
      buf.writeln(
        '${dev.ip}  ${dev.protocol}  ${dev.vendor}  '
        '[${dev.detectionMethod}, ${dev.confidence.name}]',
      );
    }
    await LogService.createLog(
      function: 'iot_scan',
      content: buf.toString(),
      summary: 'IoT scan $_cidr: ${_devices.length} device(s) found',
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }
}
