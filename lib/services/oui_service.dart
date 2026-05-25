import 'dart:convert';
import 'package:flutter/services.dart';

class OuiService {
  static Map<String, String>? _db;

  static Future<void> init() async {
    if (_db != null) return;
    final raw = await rootBundle.loadString('oui.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    _db = map.map((k, v) => MapEntry(k.toUpperCase(), v as String));
  }

  static String lookup(String mac) {
    if (_db == null || mac.length < 8) return '';
    final prefix = mac.substring(0, 8).toUpperCase();
    return _db![prefix] ?? '';
  }
}
