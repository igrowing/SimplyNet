import 'dart:convert';
import 'package:flutter/services.dart';

class OuiService {
  static Map<String, String>? _db;

  /// IoT OUI prefixes that the IEEE registry in `assets/oui.json` does not
  /// list, kept from the former IoT scanner table. Consulted only when the
  /// registry has no entry, so an IEEE assignment always wins.
  static const _supplement = <String, String>{
    'D0:F6:18': 'Nordic Semiconductor ASA',
    'CC:02:D1': 'Tuya Smart Inc.',
  };

  static Future<void> init() async {
    if (_db != null) return;
    final raw = await rootBundle.loadString('assets/oui.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    _db = map.map((k, v) => MapEntry(k.toUpperCase(), v as String));
  }

  static String lookup(String mac) {
    if (_db == null || mac.length < 8) return '';
    final prefix = mac.substring(0, 8).toUpperCase();
    return _db![prefix] ?? _supplement[prefix] ?? '';
  }
}
