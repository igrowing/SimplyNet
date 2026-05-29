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
      final octetValue = int.tryParse(o);
      if (octetValue == null || octetValue < 0 || octetValue > 255) return null;
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
      if (!file.existsSync()) 
      {
        // TODO: Add logging to LogService (_logBuffer?) instead of silently failing
        // _logBuffer.writeln('ARP table file not found: ${file.path}');
        return map;
      }
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
    } catch (_) {
      // TODO: Add logging to LogService (_logBuffer?) instead of silently failing
      //_logBuffer.writeln('Failed to read ARP table: $e');
    }
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
        final avahiResult = await Process.run(
          'avahi-resolve', ['-a', ip],
          runInShell: true,
        ).timeout(const Duration(seconds: 2));
        if (avahiResult.exitCode == 0) {
          final parts = (avahiResult.stdout as String).trim().split(RegExp(r'\s+'));
          if (parts.length >= 2 && parts[1].isNotEmpty) return parts[1];
        }
      } catch (_) {}
    }

    // 3. nslookup fallback
    if (!kIsWeb) {
      try {
        final nslookupResult = await Process.run(
          'nslookup', [ip],
          runInShell: true,
        ).timeout(const Duration(seconds: 2));
        if (nslookupResult.exitCode == 0) {
          for (final line in (nslookupResult.stdout as String).split('\n')) {
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

  // ── MAC resolution ───────────────────────────────────────────────────────
  // Tries multiple methods to resolve IP → MAC address:
  // 1. ARP table (/proc/net/arp)
  // 2. arping command (active ARP query)
  // 3. arp command fallback

  static Future<String> _resolveMac(String ip, Map<String, String> arpTable) async {
    // 1. Try pre-populated ARP table
    if (arpTable.containsKey(ip)) {
      return arpTable[ip]!;
    }

    // 2. Re-read ARP table (kernel may have populated after ping)
    var mac = _readArpTable()[ip];
    if (mac != null && mac.isNotEmpty) return mac;

    // 3. Try arping command (active ARP query)
    if (!kIsWeb) {
      try {
        final result = await Process.run(
          'arping', ['-c', '1', ip],
          runInShell: true,
        ).timeout(const Duration(seconds: 1));
        if (result.exitCode == 0) {
          // arping output contains MAC address, extract it
          final macMatch = RegExp(r'([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})')
              .firstMatch(result.stdout as String);
          if (macMatch != null) {
            return macMatch.group(1)!.toUpperCase();
          }
        }
      } catch (_) {}
    }

    // 4. Final ARP table check
    mac = _readArpTable()[ip];
    return mac ?? 'N/A';
  }

  // ── Main scan ─────────────────────────────────────────────────────────────

  static Stream<HostResult> scan(String cidr, {bool resolveNames = true}) async* {
    final parsed = parseCidr(cidr);
    if (parsed == null) return;
    final (baseIp, prefix) = parsed;
    final hosts    = _expandCidr(baseIp, prefix);

    // Peek all IPs in the LAN to collect MACs in ARP table, then resolve hostnames in parallel.
    final chunks = <Future<HostResult?>>[];
    final allResults = <HostResult>[];
    for (var i = 0; i < hosts.length; i++) {
      chunks.add(_probeHost(hosts[i], resolveNames));

      if (chunks.length >= _parallelism || i == hosts.length - 1) {
        final results = await Future.wait(chunks);
        for (final result in results) {
          if (result != null) allResults.add(result);
        }
        chunks.clear();
      }
    }

    // Read freash arp table
    final arpTable = _readArpTable();
    // Fill results with MAC addresses from ARP table and with manufacturer names from OUI lookup
    for (final host in allResults) {
      final mac = arpTable[host.ip];
      if (mac != null && mac.isNotEmpty) {
        host.mac = mac;
        host.manufacturer = OuiService.lookup(mac);
      } else {
        host.mac = host.mac != '' ? host.mac : 'N/A';
        host.manufacturer = host.manufacturer != '' ? host.manufacturer : '';
      }
      yield host;
    }
  }

  static Future<HostResult?> _probeHost(
    String ip,
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

    String hostname = '';
    if (resolveNames) {
      hostname = await resolveHostname(ip);
    }

    return HostResult(
      ip: ip,
      mac: "",  // to be filled later from ARP table
      hostname: hostname,
      manufacturer: "", // tobe filled later from OUI lookup when MAC is known
      isUp: true,
    );
  }
}
