import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted snapshot of a scan screen's last results.
class ScanSnapshot {
  /// CIDR the results were collected for.
  final String cidr;

  /// Raw per-item JSON maps — each screen decodes these into its own model.
  final List<Map<String, dynamic>> items;

  const ScanSnapshot({required this.cidr, required this.items});
}

/// Stores the last results of the Scan, IP Camera and IoT screens in local
/// storage so a screen can reload its previous results instead of triggering
/// a fresh scan on every open.
class ScanStorage {
  ScanStorage._();

  static const kScanHosts = 'cache_scan_hosts';
  static const kIotDevices = 'cache_iot_devices';
  static const kCameras = 'cache_cameras';

  /// Persist [items] (each already a JSON-encodable map) under [key] together
  /// with the [cidr] they belong to and a timestamp.
  static Future<void> save(
    String key,
    String cidr,
    List<Map<String, dynamic>> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode({
        'cidr': cidr,
        'ts': DateTime.now().toIso8601String(),
        'items': items,
      }),
    );
  }

  /// Load a previously [save]d snapshot, or null when nothing is stored.
  ///
  /// Throws [FormatException] when the stored payload is not the expected
  /// shape — a corrupt cache must fail loudly rather than load blank data.
  static Future<ScanSnapshot?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('ScanStorage: corrupt payload for "$key"');
    }
    final items = decoded['items'];
    if (items is! List) {
      throw FormatException('ScanStorage: missing "items" for "$key"');
    }
    return ScanSnapshot(
      cidr: decoded['cidr'] as String? ?? '',
      items: items
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(growable: false),
    );
  }

  /// Remove any stored snapshot for [key].
  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
