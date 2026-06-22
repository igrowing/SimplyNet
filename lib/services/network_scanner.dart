import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/oui_service.dart';
import 'package:mac_address_plus/mac_address_plus.dart';

class NetworkScanner {
  static const _pingTimeout = Duration(milliseconds: 2200);
  // Kept modest so the phone stays responsive during a sweep; liveness is
  // ICMP-only (a TCP fallback made the UI feel stuck on slow networks).
  static const _parallelism = 32;

  // ── CIDR helpers ──────────────────────────────────────────────────────────

  static (String, int)? parseCidr(String cidr) {
    final parts = cidr.trim().split('/');
    if (parts.length != 2) return null;
    final ip = parts[0].trim();
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

  /// Expands [cidr] into its probe-able host IPs (network and broadcast
  /// addresses excluded). Returns an empty list for an invalid CIDR.
  static List<String> hostsInCidr(String cidr) {
    final parsed = parseCidr(cidr);
    if (parsed == null) return const [];
    final (baseIp, prefix) = parsed;
    return expandCidr(baseIp, prefix);
  }

  // ── ARP table ─────────────────────────────────────────────────────────────
  @visibleForTesting
  static Future<Map<String, String>> readArpTable() async {
    final map = <String, String>{};
    try {
      ProcessResult result;

      if (Platform.isIOS) {
        // iOS: use BSD-style arp command
        // Format: "hostname (192.168.1.1) at aa:bb:cc:dd:ee:ff on en0"
        result = await Process.run('arp', ['-a']);
        if (result.exitCode == 0) {
          final re = RegExp(
            r'\((\d+\.\d+\.\d+\.\d+)\)\s+at\s+([0-9a-f:]{17})',
            caseSensitive: false,
          );
          final out = (result.stdout ?? '').toString().split('\n');
          for (final line in out) {
            final m = re.firstMatch(line.trim());
            if (m != null) {
              final ip = m.group(1)!;
              final mac = m.group(2)!.toUpperCase();
              if (mac != '00:00:00:00:00:00') map[ip] = mac;
            }
          }
          return map;
        } else {
          await LogService.createLog(
            function: 'network_scanner._readArpTable',
            content:
                'Failed to run arp -a on iOS: exit code ${result.exitCode}',
            summary: 'ARP table read failed on iOS',
          );
        }
      } else {
        // Android and other platforms: merge two sources because different
        // Android versions expose the neighbour table through only one of them.
        //   1. `ip neigh show` (netlink RTM_GETNEIGH)
        //   2. /proc/net/arp   (legacy kernel file)
        await _mergeIpNeigh(map);
        await _mergeProcNetArp(map);
        if (map.isEmpty) {
          await LogService.createLog(
            function: 'network_scanner._readArpTable',
            content:
                'Neighbour table empty from both `ip neigh show` and '
                '/proc/net/arp. Android 10+ restricts apps from reading the '
                'ARP/neighbour table, so remote MAC resolution is unavailable.',
            summary: 'ARP table read returned no entries',
          );
        }
        return map;
      }
    } catch (error) {
      await LogService.createLog(
        function: 'network_scanner._readArpTable',
        content: 'Exception while reading ARP table: $error',
        summary: 'ARP table read error',
      );
    }
    return map;
  }

  static final _macRe = RegExp(
    r'^([0-9a-f]{2}:){5}[0-9a-f]{2}$',
    caseSensitive: false,
  );

  /// Run [exe] with [args], trying a few absolute fallbacks because an app's
  /// `PATH` on Android often omits /system/bin, so a bare `ip`/`cat` fails to
  /// spawn. Returns stdout, or '' when every candidate fails.
  static Future<String> _run(String exe, List<String> args) async {
    for (final path in [exe, '/system/bin/$exe', '/system/xbin/$exe']) {
      try {
        final r = await Process.run(path, args);
        if (r.exitCode == 0) return (r.stdout ?? '').toString();
      } catch (_) {}
    }
    return '';
  }

  /// Parse `ip neigh show` (netlink neighbour table) into [map].
  static Future<void> _mergeIpNeigh(Map<String, String> map) async {
    final out = await _run('ip', ['neigh', 'show']);
    final re = RegExp(
      r'^(\S+).*?lladdr\s+([0-9a-f:]{17})',
      caseSensitive: false,
    );
    for (final line in out.split('\n')) {
      final m = re.firstMatch(line.trim());
      if (m != null) {
        final mac = m.group(2)!.toUpperCase();
        if (mac != '00:00:00:00:00:00') map[m.group(1)!] = mac;
      }
    }
  }

  /// Parse /proc/net/arp into [map]. Reads it via `cat` first: Java network
  /// scanners that work on Android 14 read this file with a BufferedReader that
  /// loops to EOF, whereas /proc files report size 0 — so `cat` (which also
  /// reads to EOF) is the most faithful equivalent. Falls back to the Dart
  /// File API. Returns silently when the kernel exposes no entries (Android 10+
  /// restricts the neighbour table for unprivileged apps).
  static Future<void> _mergeProcNetArp(Map<String, String> map) async {
    var text = await _run('cat', ['/proc/net/arp']);
    if (text.isEmpty) {
      try {
        final file = File('/proc/net/arp');
        if (file.existsSync()) text = file.readAsStringSync();
      } catch (_) {}
    }
    for (final line in const LineSplitter().convert(text).skip(1)) {
      final parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length < 4) continue;
      final ip = parts[0];
      final mac = parts[3].toUpperCase();
      if (_macRe.hasMatch(mac) && mac != '00:00:00:00:00:00') map[ip] = mac;
    }
  }

  // ── Self MAC resolution ──────────────────────────────────────────────────
  // The device's own IP never appears in ARP/neighbour tables because those
  // only list *remote* neighbours.  However, dart:io NetworkInterface.list()
  // gives us the interface addresses AND the hardware (MAC) address directly,
  // with no shell command needed.
  //
  // We build a Map<ip, mac> from all interfaces so the scan loop can look up
  // "self" just like any other ARP entry.

  static Map<String, String>? _selfMacCache; // populated once per scan

  @visibleForTesting
  static Future<Map<String, String>> getSelfMacs() async {
    if (_selfMacCache != null) return _selfMacCache!;

    final map = <String, String>{};
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      final _macAddressPlusPlugin = MacAddressPlus();
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final ip = addr.address;
          String? macAddress;
          try {
            macAddress = await _macAddressPlusPlugin.getMacAddress();
          } catch (_) {}
          map[ip] = macAddress ?? 'N/A';
        }
      }
    } catch (e) {
      await LogService.createLog(
        function: 'network_scanner._getSelfMacs',
        content: 'Exception: $e',
        summary: 'Self MAC resolution failed',
      );
    }
    _selfMacCache = map;
    return map;
  }

  @visibleForTesting
  static List<String> expandCidr(String baseIp, int prefix) {
    final octets = baseIp.split('.').map(int.parse).toList();
    final base =
        (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);
    final hosts = <String>[];
    for (var i = net + 1; i < broadcast; i++) {
      hosts.add(
        '${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}',
      );
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
      final ia = InternetAddress(ip);
      final results = await ia.reverse().timeout(const Duration(seconds: 2));
      final name = results.host;
      if (name.isNotEmpty && name != ip) return name;
    } catch (_) {}

    // 2. avahi-resolve (available on many Android/Linux devices via Avahi daemon)
    if (!kIsWeb) {
      try {
        final avahiResult = await Process.run('avahi-resolve', [
          '-a',
          ip,
        ], runInShell: true).timeout(const Duration(seconds: 2));
        if (avahiResult.exitCode == 0) {
          final parts = (avahiResult.stdout as String).trim().split(
            RegExp(r'\s+'),
          );
          if (parts.length >= 2 && parts[1].isNotEmpty) return parts[1];
        }
      } catch (_) {}
    }

    // 3. nslookup fallback
    if (!kIsWeb) {
      try {
        final nslookupResult = await Process.run('nslookup', [
          ip,
        ], runInShell: true).timeout(const Duration(seconds: 2));
        if (nslookupResult.exitCode == 0) {
          for (final line in (nslookupResult.stdout as String).split('\n')) {
            // "name = somehost.local." line
            if (line.contains('name =')) {
              final name = line
                  .split('=')
                  .last
                  .trim()
                  .replaceAll(RegExp(r'\.$'), '');
              if (name.isNotEmpty && name != ip) return name;
            }
          }
        }
      } catch (_) {}
    }

    return '';
  }

  // ── Device type detection ──────────────────────────────────────────────────
  // Infers device type from manufacturer name (OUI lookup).
  // Can be extended with port-based detection (e.g., 554 = IP Camera).

  // ── IoT / embedded chip & brand vendors ───────────────────────────────────
  // Checked first because chip makers ("Espressif") or platforms ("Tuya") must
  // win over the broader rules below. Matched against the vendor name resolved
  // from the MAC via assets/oui.json (the single OUI source), so no MAC-prefix
  // list is duplicated here.
  static const _iotVendorKeywords = <String>[
    // Chip vendors — virtually always IoT
    'espressif', 'nordic semiconductor', 'silicon labs', 'texas instruments',
    'stmicroelectronics', 'stmicro', 'nxp semiconductor', 'microchip technol',
    'beken', 'renesas', 'ember', 'minew',
    // Platform/firmware
    'tuya', 'shelly', 'allterco', 'itead', 'sonoff',
    'meross', 'ewelink',
    // Consumer IoT brands
    'philips hue', 'philips lighting', 'signify',
    'ikea of sweden', 'ikea trådfri',
    'belkin', 'wemo',
    'xiaomi', 'wyze labs',
    'smartthings',
    'amazon technologies',
    'google,', // "Google, Inc." — trailing comma avoids matching "Google LLC" (Android phones)
    'raspberry pi',
    'arduino', 'particle industries',
    'tp-link', // Kasa smart devices
    'realtek(iot',
  ];

  // Ordered (keyword, type) table for non-IoT vendors. The first keyword found
  // in the lower-cased manufacturer name wins, so more specific entries are
  // placed before more generic ones (e.g. "sony interactive" before "sony",
  // and brand cameras before the generic "camera" / Smart-Home rules).
  static const _typeKeywords = <(String, String)>[
    // Specific IP-camera makers.
    ('hikvision', 'IP Camera'), ('dahua', 'IP Camera'),
    ('hui zhou', 'IP Camera'), ('reolink', 'IP Camera'),
    ('amcrest', 'IP Camera'), ('lorex', 'IP Camera'),
    ('foscam', 'IP Camera'), ('ezviz', 'IP Camera'),
    ('vivotek', 'IP Camera'), ('uniview', 'IP Camera'),
    ('axis communications', 'IP Camera'),
    // Network-attached storage / NAS.
    ('qnap', 'Storage'), ('synology', 'Storage'), ('asustor', 'Storage'),
    ('drobo', 'Storage'), ('terramaster', 'Storage'),
    ('western digital', 'Storage'),
    // Home routers / gateways / mesh (enterprise gear → "Network Device").
    ('avm', 'Router'), ('fritz', 'Router'), ('eero', 'Router'),
    ('mikrotik', 'Router'), ('mercku', 'Router'),
    // VoIP desk phones.
    ('yealink', 'VoIP Phone'), ('grandstream', 'VoIP Phone'),
    ('polycom', 'VoIP Phone'), ('snom', 'VoIP Phone'),
    ('fanvil', 'VoIP Phone'),
    // Game consoles (before "sony" → Smart TV so PlayStation is a console).
    ('nintendo', 'Game Console'), ('sony interactive', 'Game Console'),
    // Mobile phones.
    ('samsung', 'Mobile'), ('redmi', 'Mobile'), ('huawei', 'Mobile'),
    ('oneplus', 'Mobile'), ('oppo', 'Mobile'), ('vivo mobile', 'Mobile'),
    ('realme', 'Mobile'), ('motorola', 'Mobile'),
    // Smart TVs / media players.
    ('lg electron', 'Smart TV'), ('vizio', 'Smart TV'), ('sony', 'Smart TV'),
    ('roku', 'Smart TV'), ('apple tv', 'Smart TV'), ('tcl', 'Smart TV'),
    ('hisense', 'Smart TV'),
    // Smart-home hubs (before the generic "camera" keyword below).
    ('echo', 'Smart Home'), ('nest', 'Smart Home'), ('ring ', 'Smart Home'),
    ('arlo ', 'Smart Home'),
    // Printers.
    ('printer', 'Printer'), ('xerox', 'Printer'), ('canon', 'Printer'),
    ('hp inc', 'Printer'), ('epson', 'Printer'), ('ricoh', 'Printer'),
    ('brother', 'Printer'),
    // Generic camera keyword (after Smart Home so "Arlo Camera" stays a hub).
    ('camera', 'IP Camera'), ('axis', 'IP Camera'),
    // Enterprise / general networking equipment.
    ('cisco', 'Network Device'), ('router', 'Network Device'),
    ('netgear', 'Network Device'), ('d-link', 'Network Device'),
    ('asus', 'Network Device'), ('ubiquiti', 'Network Device'),
    ('arista', 'Network Device'), ('juniper', 'Network Device'),
    ('fortinet', 'Network Device'), ('aruba', 'Network Device'),
    ('zyxel', 'Network Device'),
    // Apple (after "apple tv" above).
    ('apple', 'Apple Device'),
    // NIC chip vendors → general-purpose computers.
    ('intel', 'Computer'), ('realtek', 'Computer'), ('broadcom', 'Computer'),
    ('atheros', 'Computer'), ('qualcomm', 'Computer'),
  ];

  /// Returns the device type for [mac] by resolving its vendor through
  /// assets/oui.json (the single OUI source) and classifying that name.
  static String deviceTypeFromMac(String mac) =>
      detectDeviceType(OuiService.lookup(mac));

  @visibleForTesting
  static String detectDeviceType(String manufacturer) {
    if (manufacturer.isEmpty) return '';

    final lower = manufacturer.toLowerCase();

    // IoT / embedded chip vendors are checked first.
    for (final kw in _iotVendorKeywords) {
      if (lower.contains(kw)) return 'IoT Device';
    }
    // Then the ordered, most-specific-first keyword table.
    for (final (kw, type) in _typeKeywords) {
      if (lower.contains(kw)) return type;
    }
    return '';
  }

  // ── Main scan ─────────────────────────────────────────────────────────────

  /// Scans [cidr] and emits hosts as they are discovered.
  ///
  /// Each live host is emitted immediately (MAC still pending) so the UI can
  /// fill its table during the sweep. Once every probe completes, the ARP
  /// table is read once and each host is emitted a second time — now enriched
  /// with MAC, manufacturer and device type. Listeners de-duplicate by IP, so
  /// the enriched emission updates the row in place.
  static Stream<HostResult> scan(String cidr, {bool resolveNames = true}) {
    final controller = StreamController<HostResult>();

    Future<void> run() async {
      final parsed = parseCidr(cidr);
      if (parsed == null) {
        await controller.close();
        return;
      }
      final (baseIp, prefix) = parsed;
      final hosts = expandCidr(baseIp, prefix);

      // Probe all hosts concurrently; emit each live host the moment it answers.
      final sem = _Semaphore(_parallelism);
      final allResults = <HostResult>[];
      await Future.wait(
        hosts.map(
          (ip) => sem.run(() async {
            final host = await _probeHost(ip, resolveNames);
            if (host != null) {
              allResults.add(host);
              controller.add(host);
            }
          }),
        ),
      );

      // Give the kernel a moment to finalise neighbour entries before reading
      // them. A fully concurrent sweep can finish faster than the neighbour
      // table settles, so reading immediately would miss some MACs.
      if (allResults.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // Read the merged ARP/neighbour table (self MACs overlaid) and re-emit
      // each host enriched with MAC, manufacturer and device type.
      var arpTable = await _resolveMacs();
      for (final host in allResults) {
        _applyMac(host, arpTable);
        controller.add(host);
      }

      // Retry once for hosts whose MAC has not resolved yet — their neighbour
      // entry may simply not have settled when the first read happened.
      final unresolved = allResults
          .where((h) => h.mac.isEmpty || h.mac == 'N/A')
          .toList();
      if (unresolved.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 400));
        arpTable = await _resolveMacs();
        for (final host in unresolved) {
          final before = host.mac;
          _applyMac(host, arpTable);
          if (host.mac != before) controller.add(host);
        }
      }
      await controller.close();
    }

    run().catchError((Object e, StackTrace st) {
      controller.addError(e, st);
      controller.close();
    });

    return controller.stream;
  }

  /// Reads the neighbour (ARP) table and overlays the device's own interface
  /// MACs, which never appear as remote neighbours. Resets [_selfMacCache] so a
  /// subsequent call re-reads the interfaces.
  static Future<Map<String, String>> _resolveMacs() async {
    final arpTable = await readArpTable();
    final selfMacs = await getSelfMacs();
    _selfMacCache = null;
    for (final entry in selfMacs.entries) {
      arpTable[entry.key] = entry.value;
    }
    return arpTable;
  }

  /// Fills [host]'s MAC, manufacturer and device type from [arpTable]. When the
  /// MAC is unknown the existing value is kept, falling back to 'N/A'.
  static void _applyMac(HostResult host, Map<String, String> arpTable) {
    final mac = arpTable[host.ip];
    if (mac != null && mac.isNotEmpty) {
      host.mac = mac;
      host.manufacturer = OuiService.lookup(mac);
    } else {
      host.mac = host.mac != '' ? host.mac : 'N/A';
      host.manufacturer = host.manufacturer != '' ? host.manufacturer : '';
    }
    // Manufacturer is resolved from the MAC via oui.json, so name-based
    // classification already covers the former MAC-prefix logic.
    host.deviceType = detectDeviceType(host.manufacturer);
  }

  static Future<HostResult?> _probeHost(String ip, bool resolveNames) async {
    final alive = await _isAlive(ip);
    if (!alive) return null;

    String hostname = '';
    if (resolveNames) {
      hostname = await resolveHostname(ip);
    }

    return HostResult(
      ip: ip,
      mac: "", // to be filled later from ARP table
      hostname: hostname,
      manufacturer: "", // tobe filled later from OUI lookup when MAC is known
      isUp: true,
    );
  }

  /// ICMP liveness check. A single `ping -c 1` per host, run with bounded
  /// concurrency. TCP port probing was dropped because the extra fan-out made
  /// the phone feel stuck without improving discovery on a normal LAN.
  static Future<bool> _isAlive(String ip) async {
    final done = Completer<bool>();
    final futures = <Future<void>>[];

    void win() {
      if (!done.isCompleted) done.complete(true);
    }

    if (!kIsWeb) {
      futures.add(() async {
        try {
          final result = await Process.run('ping', [
            '-c',
            '1',
            '-W',
            '2',
            ip,
          ], runInShell: true).timeout(_pingTimeout);
          if (result.exitCode == 0) win();
        } catch (_) {}
      }());
    }

    // Resolve false only once every probe has finished without a positive.
    unawaited(
      Future.wait(futures).then((_) {
        if (!done.isCompleted) done.complete(false);
      }),
    );

    return done.future;
  }
}

// ── Simple semaphore for concurrency limiting ─────────────────────────────────

class _Semaphore {
  int _count;
  final _queue = <Completer<void>>[];
  _Semaphore(this._count);

  Future<T> run<T>(Future<T> Function() fn) async {
    if (_count <= 0) {
      final c = Completer<void>();
      _queue.add(c);
      await c.future;
    }
    _count--;
    try {
      return await fn();
    } finally {
      _count++;
      if (_queue.isNotEmpty) _queue.removeAt(0).complete();
    }
  }
}
