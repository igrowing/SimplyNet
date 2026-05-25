import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/network_scanner.dart';

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

  Future<void> detectNetwork() async {
    final found = await NetworkScanner.detectNetwork();
    if (found != null) {
      _target = found;
      notifyListeners();
    }
  }

  // ── Scan state ────────────────────────────────────────────────────────────
  List<HostResult> _results = [];
  List<HostResult> get results => _sortedResults();

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  ScanSortColumn _sortColumn = ScanSortColumn.ip;
  bool _sortAsc = true;
  ScanSortColumn get sortColumn => _sortColumn;
  bool get sortAsc => _sortAsc;

  StreamSubscription? _sub;
  final StringBuffer _logBuffer = StringBuffer();

  void toggleSort(ScanSortColumn col) {
    if (_sortColumn == col) {
      _sortAsc = !_sortAsc;
    } else {
      _sortColumn = col;
      _sortAsc = true;
    }
    notifyListeners();
  }

  List<HostResult> _sortedResults() {
    final list = List<HostResult>.from(_results);
    list.sort((a, b) {
      int cmp;
      switch (_sortColumn) {
        case ScanSortColumn.ip:
          cmp = _ipCompare(a.ip, b.ip);
        case ScanSortColumn.mac:
          cmp = a.mac.compareTo(b.mac);
        case ScanSortColumn.hostname:
          cmp = a.hostname.compareTo(b.hostname);
      }
      return _sortAsc ? cmp : -cmp;
    });
    return list;
  }

  int _ipCompare(String a, String b) {
    int toInt(String ip) {
      final p = ip.split('.').map(int.parse).toList();
      return (p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3];
    }
    return toInt(a).compareTo(toInt(b));
  }

  void startScan({bool resolveNames = true, bool logging = true}) {
    if (!isValidTarget) return;
    _sub?.cancel();
    _results = [];
    _isScanning = true;
    _logBuffer.clear();
    _logBuffer.writeln('Scan started: $_target');
    notifyListeners();

    _sub = NetworkScanner.scan(_target, resolveNames: resolveNames).listen(
      (host) {
        _results.add(host);
        _logBuffer.writeln('${host.ip}\t${host.mac}\t${host.hostname}');
        notifyListeners();
      },
      onDone: () async {
        _isScanning = false;
        _logBuffer.writeln('\nScan complete. ${_results.length} hosts found.');
        notifyListeners();
        if (logging) {
          await LogService.createLog(
            function: 'scan',
            content: _logBuffer.toString(),
            summary: 'Scan $_target — ${_results.length} hosts',
          );
        }
      },
      onError: (_) {
        _isScanning = false;
        notifyListeners();
      },
    );
  }

  void stopScan() {
    _sub?.cancel();
    _isScanning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
