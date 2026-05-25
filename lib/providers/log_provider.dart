import 'package:flutter/material.dart';
import 'package:simply_net/models/log_entry.dart';
import 'package:simply_net/services/log_service.dart';

class LogProvider extends ChangeNotifier {
  List<LogEntry> _logs = [];
  List<LogEntry> get logs => _logs;

  Future<void> loadLogs() async {
    _logs = await LogService.loadIndex();
    notifyListeners();
  }

  Future<void> deleteLog(LogEntry entry) async {
    await LogService.deleteLog(entry);
    _logs.removeWhere((e) => e.id == entry.id);
    notifyListeners();
  }

  Future<String> readLog(String filePath) => LogService.readLog(filePath);
}
