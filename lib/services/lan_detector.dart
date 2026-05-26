import 'dart:io';
import 'package:flutter/foundation.dart';

/// LAN detection utilities used by HomeScreen.
/// Extracted as top-level functions so they are unit-testable
/// while keeping the same logic as the original private methods.
///
/// Functions are annotated @visibleForTesting where they are pure helpers;
/// [detectLanCidr] is the primary entry point used by the UI.

/// Detect the device's LAN CIDR (e.g. "192.168.1.0/24").
///
/// Returns null on web (NetworkInterface unavailable) or on failure.
Future<String?> detectLanCidr() async {
  if (kIsWeb) {
    debugPrint('Network detection skipped: not available on web browsers');
    return null;
  }
  try {
    final ifaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    for (final iface in ifaces) {
      for (final addr in iface.addresses) {
        if (!addr.isLoopback && addr.address.isNotEmpty) {
          final prefix = inferPrefixFromAddress(addr.address);
          final network = networkAddress(addr.address, prefix);
          debugPrint('Detected interface "${iface.name}": ${addr.address}/$prefix');
          return '$network/$prefix';
        }
      }
    }
  } catch (e) {
    debugPrint('Network detection failed: $e');
  }
  return null;
}

/// Infer subnet prefix from IP address pattern when system info unavailable.
///
/// Heuristic: all RFC-1918 ranges are treated as /24 (most common home/office
/// deployment). Falls back to /24 for unknown or invalid addresses.
@visibleForTesting
int inferPrefixFromAddress(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) return 24;
  try {
    final first = int.parse(parts[0]);
    if (first == 10) return 24;   // 10.0.0.0/8  → assume /24 subnets
    if (first == 172) return 24;  // 172.16.0.0/12 → assume /24 subnets
    if (first == 192) return 24;  // 192.168.0.0/16 → assume /24 subnets
  } catch (_) {}
  return 24;
}

/// Returns the network address (zeroed host bits) for the given IP and prefix.
///
/// Example: networkAddress('192.168.1.100', 24) → '192.168.1.0'
/// Returns [ip] unchanged on invalid input.
@visibleForTesting
String networkAddress(String ip, int prefix) {
  try {
    final octets = ip.split('.').map(int.parse).toList();
    if (octets.length != 4) return ip;
    if (prefix < 0 || prefix > 32) return ip;

    final ipInt =
        (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask =
        prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net = ipInt & mask;

    return '${(net >> 24) & 0xFF}.'
        '${(net >> 16) & 0xFF}.'
        '${(net >> 8) & 0xFF}.'
        '${net & 0xFF}';
  } catch (e) {
    debugPrint('Error in networkAddress($ip, $prefix): $e');
    return ip;
  }
}
