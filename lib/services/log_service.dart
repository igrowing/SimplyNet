import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/log_entry.dart';

class LogService {
  static const _indexKey = 'log_index';
  static final _fmt = DateFormat('yyyyMMdd_HHmmss');

  // ── Directory ─────────────────────────────────────────────────────────────

  static Future<Directory> _logsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/logs');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  // ── Index (stored in SharedPreferences as JSON list) ─────────────────────

  static Future<List<LogEntry>> loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_indexKey) ?? [];
    return raw
        .map((s) => LogEntry.fromJson(json.decode(s) as Map<String, dynamic>))
        .toList()
      ..sort((entryA, entryB) => entryB.timestamp.compareTo(entryA.timestamp));
  }

  static Future<void> _saveIndex(List<LogEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _indexKey,
      entries.map((entry) => json.encode(entry.toJson())).toList(),
    );
  }

  // ── Write ──────────────────────────────────────────────────────────────────

  static Future<LogEntry> createLog({
    required String function,
    required String content,
    String summary = '',
  }) async {
    final dir = await _logsDir();
    final ts = _fmt.format(DateTime.now());
    final file = File('${dir.path}/${function}_$ts.log');
    await file.writeAsString(content);

    final entry = LogEntry(
      id: '${function}_$ts',
      function: function,
      timestamp: DateTime.now(),
      filePath: file.path,
      summary: summary.isNotEmpty ? summary : content.split('\n').first,
    );

    final index = await loadIndex();
    index.insert(0, entry);
    await _saveIndex(index);
    return entry;
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  static Future<String> readLog(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return '(log file not found)';
    return file.readAsString();
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  static Future<void> deleteLog(LogEntry entry) async {
    final file = File(entry.filePath);
    if (file.existsSync()) file.deleteSync();
    final index = await loadIndex();
    index.removeWhere((e) => e.id == entry.id);
    await _saveIndex(index);
  }
}
