import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/oui_service.dart';

class NetworkScanner {
  static const _pingTimeout = Duration(milliseconds: 800);
  static const _tcpTimeout = Duration(milliseconds: 400);
  static const _parallelism = 64;

  /// Parse a CIDR string. Returns (baseIp, prefixLength) or null if invalid.
  static (String, int)? parseCidr(String cidr) {
    final parts = cidr.trim().split('/');
    if (parts.length != 2) return null;
    final ip = parts[0].trim();
    final prefix = int.tryParse(parts[1].trim());
    if (prefix == null || prefix < 0 || prefix > 32) return null;
    // Validate IP
    final octets = ip.split('.');
    if (octets.length != 4) return null;
    for (final o in octets) {
      final v = int.tryParse(o);
      if (v == null || v < 0 || v > 255) return null;
    }
    return (ip, prefix);
  }

  static bool isValidCidr(String cidr) => parseCidr(cidr) != null;

  /// Read /proc/net/arp for IP → MAC mappings (Android only).
  static Map<String, String> _readArpTable() {
    final map = <String, String>{};
    try {
      final file = File('/proc/net/arp');
      if (!file.existsSync()) return map;
      for (final line in file.readAsLinesSync().skip(1)) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          final ip = parts[0];
          final mac = parts[3].toUpperCase();
          if (mac != '00:00:00:00:00:00' && mac.length == 17) {
            map[ip] = mac;
          }
        }
      }
    } catch (_) {}
    return map;
  }

  static List<String> _expandCidr(String baseIp, int prefix) {
    final octets = baseIp.split('.').map(int.parse).toList();
    final base = (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);
    final hosts = <String>[];
    for (var i = net + 1; i < broadcast; i++) {
      hosts.add('${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}');
    }
    return hosts;
  }

  /// Scan a CIDR range, yielding HostResult for each live host.
  static Stream<HostResult> scan(String cidr, {bool resolveNames = true}) async* {
    final parsed = parseCidr(cidr);
    if (parsed == null) return;
    final (baseIp, prefix) = parsed;
    final hosts = _expandCidr(baseIp, prefix);
    final arpTable = _readArpTable();

    // Process in parallel batches
    final chunks = <Future<HostResult?>>[];
    for (var i = 0; i < hosts.length; i++) {
      chunks.add(_probeHost(hosts[i], arpTable, resolveNames));
      
      // Yield results when we have a full batch
      if (chunks.length >= _parallelism || i == hosts.length - 1) {
        final results = await Future.wait(chunks);
        for (final result in results) {
          if (result != null) yield result;
        }
        chunks.clear();
      }
    }
  }

  static Future<HostResult?> _probeHost(
    String ip,
    Map<String, String> arpTable,
    bool resolveNames,
  ) async {
    bool alive = false;

    // On web, Process API is unavailable. Skip ping and only try TCP.
    if (!kIsWeb) {
      // 1. ICMP via ping process (desktop/mobile only)
      try {
        final result = await Process.run(
          'ping',
          ['-c', '1', '-W', '1', ip],
          runInShell: true,
        ).timeout(_pingTimeout);
        alive = result.exitCode == 0;
      } catch (_) {}
    }

    // 2. TCP probe fallback (works on all platforms, though may fail due to CORS on web)
    if (!alive) {
      for (final port in [80, 443, 22, 445, 8080]) {
        try {
          final sock = await Socket.connect(ip, port, timeout: _tcpTimeout);
          sock.destroy();
          alive = true;
          break;
        } catch (_) {}
      }
    }

    if (!alive) return null;

    final mac = arpTable[ip] ?? 'N/A';
    String hostname = '';
    if (resolveNames) {
      try {
        final addrs = await InternetAddress.lookup(ip);
        hostname = addrs.isNotEmpty ? addrs.first.host : '';
        if (hostname == ip) hostname = '';
      } catch (_) {}
    }

    final manufacturer = OuiService.lookup(mac);

    return HostResult(
      ip: ip,
      mac: mac,
      hostname: hostname,
      manufacturer: manufacturer,
      isUp: true,
    );
  }
}
