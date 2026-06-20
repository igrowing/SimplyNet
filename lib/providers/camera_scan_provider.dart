import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/services/ip_camera_detector.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/scan_storage.dart';

/// Owns the IP-camera scan lifecycle so a running scan survives navigation away
/// from the camera screen, and the last results can be reloaded from storage.
class CameraScanProvider extends ChangeNotifier {
  final List<CameraCandidate> _results = [];
  List<CameraCandidate> get results => List.unmodifiable(_results);

  bool _scanning = false;
  bool get scanning => _scanning;

  int _done = 0;
  int _total = 0;
  int get done => _done;
  int get total => _total;

  String _cidr = '';
  String get cidr => _cidr;

  bool _loggingEnabled = true;

  StreamSubscription<CameraCandidate>? _sub;

  /// Load the last persisted camera results (if any) from local storage.
  Future<void> loadCache() async {
    try {
      final snap = await ScanStorage.load(ScanStorage.kCameras);
      if (snap == null) return;
      _results
        ..clear()
        ..addAll(snap.items.map(CameraCandidate.fromJson));
      _cidr = snap.cidr;
      notifyListeners();
    } on FormatException {
      await ScanStorage.clear(ScanStorage.kCameras);
    }
  }

  /// Start a camera scan of [cidr].
  ///
  /// When [knownIps] is supplied (a fresh host list from a previous full scan)
  /// only those hosts are probed; otherwise a full subnet sweep runs.
  void startScan(String cidr, {List<String>? knownIps, bool logging = true}) {
    if (_scanning) return;
    _sub?.cancel();
    _cidr = cidr;
    _loggingEnabled = logging;
    _results.clear();
    _scanning = true;
    _done = 0;
    _total = 0;
    notifyListeners();

    void onProgress(int done, int total) {
      _done = done;
      _total = total;
      notifyListeners();
    }

    final Stream<CameraCandidate> stream;
    if (knownIps != null && knownIps.isNotEmpty) {
      _total = knownIps.length;
      stream = IpCameraDetector.scanHosts(knownIps, onProgress: onProgress);
    } else {
      stream = IpCameraDetector.scanSubnet(cidr, onProgress: onProgress);
    }

    _sub = stream.listen(
      (candidate) {
        _results.add(candidate);
        notifyListeners();
      },
      onDone: _onDone,
      onError: (_) => _onError(),
    );
  }

  void stopScan() {
    _sub?.cancel();
    _scanning = false;
    _sortByIp();
    notifyListeners();
    _saveCache();
    if (_loggingEnabled) _writeLog(partial: true);
  }

  Future<void> _onDone() async {
    _scanning = false;
    _sortByIp();
    notifyListeners();
    await _saveCache();
    if (_loggingEnabled) await _writeLog();
  }

  void _onError() {
    _scanning = false;
    notifyListeners();
  }

  void _sortByIp() =>
      _results.sort((a, b) => ScanProvider.ipCompare(a.ip, b.ip));

  Future<void> _saveCache() async {
    if (_results.isEmpty) return;
    await ScanStorage.save(
      ScanStorage.kCameras,
      _cidr,
      _results.map((c) => c.toJson()).toList(),
    );
  }

  Future<void> _writeLog({bool partial = false}) async {
    if (_results.isEmpty) return;
    final label = partial ? 'stopped' : 'complete';
    final buf = StringBuffer();
    for (final cam in _results) {
      buf.writeln(
        '${cam.ip}  :${cam.port}  ${cam.method.name}  '
        '${cam.manufacturer}  ${cam.evidence}',
      );
    }
    await LogService.createLog(
      function: 'ip_cameras',
      content: buf.toString(),
      summary: 'IP camera scan $_cidr: ${_results.length} found ($label)',
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
