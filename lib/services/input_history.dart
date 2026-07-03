import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the most recently used values for a text input so it can be
/// offered as a dropdown of previous choices.
class InputHistory {
  static const _prefix = 'input_history_';
  static const maxEntries = 10;

  static String _key(String field) => '$_prefix$field';

  /// Returns the stored values for [field], most-recent first.
  static Future<List<String>> load(String field) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(field));
    if (raw == null || raw.isEmpty) return [];
    final decoded = json.decode(raw);
    if (decoded is! List) return [];
    return decoded.whereType<String>().toList();
  }

  /// Adds [value] to [field]'s history (deduplicated, most-recent first,
  /// capped at [maxEntries]). Blank values are ignored.
  static Future<List<String>> add(String field, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return load(field);
    final prefs = await SharedPreferences.getInstance();
    final current = await load(field);
    current
      ..removeWhere((e) => e == trimmed)
      ..insert(0, trimmed);
    final capped = current.take(maxEntries).toList();
    await prefs.setString(_key(field), json.encode(capped));
    return capped;
  }

  /// Overwrites [field]'s history with [values] (used to remove entries).
  static Future<void> replace(String field, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(field),
      json.encode(values.take(maxEntries).toList()),
    );
  }
}
