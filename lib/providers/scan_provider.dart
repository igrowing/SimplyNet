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

  List<HostResult> _sortedResults() {
    final list = List<HostResult>.from(_results);
    list.sort((firstHost, secondHost) {
      int comparison;
      switch (_sortColumn) {
        case ScanSortColumn.ip:
          comparison = _ipCompare(firstHost.ip, secondHost.ip);
        case ScanSortColumn.mac:
          comparison = firstHost.mac.compareTo(secondHost.mac);
        case ScanSortColumn.hostname:
          comparison = firstHost.hostname.compareTo(secondHost.hostname);
      }
      return _sortAsc ? comparison : -comparison;
    });
    return list;
  }

  int _ipCompare(String a, String b) {
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

    _sub = NetworkScanner.scan(_target, resolveNames: resolveNames).listen(
      (host) {
        _results.add(host);
        _logBuffer.writeln('FOUND  ${host.ip}\t${host.mac}\t${host.hostname}\t${host.manufacturer}');
        notifyListeners();
      },
      onDone: () async {
        _isScanning = false;
        _logBuffer.writeln('\nScan complete. ${_results.length} host(s) found.');
        _logBuffer.writeln('=== End: ${DateTime.now().toIso8601String()} ===');
        notifyListeners();
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
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    logVersion.dispose();
    super.dispose();
  }
}
