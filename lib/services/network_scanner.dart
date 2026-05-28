import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/oui_service.dart';

class NetworkScanner {
  static const _pingTimeout  = Duration(milliseconds: 800);
  static const _tcpTimeout   = Duration(milliseconds: 400);
  static const _parallelism  = 64;

  // ── CIDR helpers ──────────────────────────────────────────────────────────

  static (String, int)? parseCidr(String cidr) {
    final parts = cidr.trim().split('/');
    if (parts.length != 2) return null;
    final ip     = parts[0].trim();
    final prefix = int.tryParse(parts[1].trim());
    if (prefix == null || prefix < 0 || prefix > 32) return null;
    final octets = ip.split('.');
    if (octets.length != 4) return null;
    for (final o in octets) {
      final v = int.tryParse(o);
      if (v == null || v < 0 || v > 255) return null;
    }
    return (ip, prefix);
  }

  static bool isValidCidr(String cidr) => parseCidr(cidr) != null;

  // ── ARP table ─────────────────────────────────────────────────────────────
  // Reads /proc/net/arp for IP→MAC on Android.
  // After a successful ICMP probe the kernel populates this table automatically,
  // so we don't need to parse ICMP replies ourselves.

  static Map<String, String> _readArpTable() {
    final map = <String, String>{};
    try {
      final file = File('/proc/net/arp');
      if (!file.existsSync()) return map;
      for (final line in file.readAsLinesSync().skip(1)) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          final ip  = parts[0];
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
    final octets  = baseIp.split('.').map(int.parse).toList();
    final base    = (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask    = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net       = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);
    final hosts = <String>[];
    for (var i = net + 1; i < broadcast; i++) {
      hosts.add('${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}');
    }
    return hosts;
  }

  // ── Hostname resolution ───────────────────────────────────────────────────
  // Strategy (in order, first non-empty wins):
  //   1. Reverse DNS (PTR record) — proper way to turn an IP into a hostname.
  //      Uses InternetAddress.reverse() which issues a real PTR query.
  //   2. mDNS via Process.run('avahi-resolve') on Linux/Android — resolves
  //      .local names on the local network without a DNS server.
  //   3. Forward nslookup fallback (old system-level DNS).

  static Future<String> resolveHostname(String ip) async {
    // 1. Reverse DNS (PTR)
    try {
      final ia      = InternetAddress(ip);
      final results = await ia.reverse().timeout(const Duration(seconds: 2));
      final name    = results.host;
      if (name.isNotEmpty && name != ip) return name;
    } catch (_) {}

    // 2. avahi-resolve (available on many Android/Linux devices via Avahi daemon)
    if (!kIsWeb) {
      try {
        final r = await Process.run(
          'avahi-resolve', ['-a', ip],
          runInShell: true,
        ).timeout(const Duration(seconds: 2));
        if (r.exitCode == 0) {
          final parts = (r.stdout as String).trim().split(RegExp(r'\s+'));
          if (parts.length >= 2 && parts[1].isNotEmpty) return parts[1];
        }
      } catch (_) {}
    }

    // 3. nslookup fallback
    if (!kIsWeb) {
      try {
        final r = await Process.run(
          'nslookup', [ip],
          runInShell: true,
        ).timeout(const Duration(seconds: 2));
        if (r.exitCode == 0) {
          for (final line in (r.stdout as String).split('\n')) {
            // "name = somehost.local." line
            if (line.contains('name =')) {
              final name = line.split('=').last.trim().replaceAll(RegExp(r'\.$'), '');
              if (name.isNotEmpty && name != ip) return name;
            }
          }
        }
      } catch (_) {}
    }

    return '';
  }

  // ── Main scan ─────────────────────────────────────────────────────────────

  static Stream<HostResult> scan(String cidr, {bool resolveNames = true}) async* {
    final parsed = parseCidr(cidr);
    if (parsed == null) return;
    final (baseIp, prefix) = parsed;
    final hosts    = _expandCidr(baseIp, prefix);
    final arpTable = _readArpTable();

    final chunks = <Future<HostResult?>>[];
    for (var i = 0; i < hosts.length; i++) {
      chunks.add(_probeHost(hosts[i], arpTable, resolveNames));

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

    if (!kIsWeb) {
      try {
        final result = await Process.run(
          'ping', ['-c', '1', '-W', '1', ip],
          runInShell: true,
        ).timeout(_pingTimeout);
        alive = result.exitCode == 0;
      } catch (_) {}
    }

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

    // After ping, the kernel should have populated the ARP table.
    // Re-read it on miss so we capture fresh entries.
    String mac = arpTable[ip] ?? '';
    if (mac.isEmpty) {
      mac = _readArpTable()[ip] ?? 'N/A';
    }

    String hostname = '';
    if (resolveNames) {
      hostname = await resolveHostname(ip);
    }

    final manufacturer = OuiService.lookup(mac);

    return HostResult(
      ip: ip,
      mac: mac.isEmpty ? 'N/A' : mac,
      hostname: hostname,
      manufacturer: manufacturer,
      isUp: true,
    );
  }
}
