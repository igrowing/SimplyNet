import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:simply_net/constants/network_ports.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/oui_service.dart';
import 'package:mac_address_plus/mac_address_plus.dart';

class NetworkScanner {
  static const _pingTimeout  = Duration(milliseconds: 2000);
  static const _tcpTimeout   = Duration(milliseconds: 900);
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
  static Future<Map<String, String>> _readArpTable() async {
    final map = <String, String>{};
    try {
      ProcessResult result;
      
      if (Platform.isIOS) {
        // iOS: use BSD-style arp command
        // Format: "hostname (192.168.1.1) at aa:bb:cc:dd:ee:ff on en0"
        result = await Process.run('arp', ['-a']);
        if (result.exitCode == 0) {
          final re = RegExp(r'\((\d+\.\d+\.\d+\.\d+)\)\s+at\s+([0-9a-f:]{17})', caseSensitive: false);
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
            content: 'Failed to run arp -a on iOS: exit code ${result.exitCode}',
            summary: 'ARP table read failed on iOS',
          );
        }
      } else {
        // Android and other platforms: use ip neigh show
        result = await Process.run('ip', ['neigh', 'show']);
        if (result.exitCode == 0) {
          final re = RegExp(r'^(\S+).*?lladdr\s+([0-9a-f:]{17})', caseSensitive: false);
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
            content: 'Failed to run ip neigh show: exit code ${result.exitCode}',
            summary: 'ARP table read failed',
          );
        }
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

  // ── Self MAC resolution ──────────────────────────────────────────────────
  // The device's own IP never appears in ARP/neighbour tables because those
  // only list *remote* neighbours.  However, dart:io NetworkInterface.list()
  // gives us the interface addresses AND the hardware (MAC) address directly,
  // with no shell command needed.
  //
  // We build a Map<ip, mac> from all interfaces so the scan loop can look up
  // "self" just like any other ARP entry.

  static Map<String, String>? _selfMacCache; // populated once per scan

  static Future<Map<String, String>> _getSelfMacs() async {
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
        content:  'Exception: $e',
        summary:  'Self MAC resolution failed',
      );
    }
    _selfMacCache = map;
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

  // ── Device type detection ──────────────────────────────────────────────────
  // Infers device type from manufacturer name (OUI lookup).
  // Can be extended with port-based detection (e.g., 554 = IP Camera).

  // ── IoT OUI prefixes (subset of IotScanner._ouiVendors) ────────────────────
  // Used to classify devices as 'IoT Device' when the general OUI lookup
  // returns a vendor name that belongs to a known IoT hardware maker.
  // Keep in sync with IotScanner._ouiVendors in lib/services/iot_scanner.dart.
  static const _iotVendorKeywords = <String>[
    // Chip vendors — virtually always IoT
    'espressif', 'nordic semiconductor', 'silicon labs', 'texas instruments',
    'stmicroelectronics', 'stmicro', 'nxp semiconductor', 'microchip technol',
    'beken', 'renesas',
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
    'google,',   // "Google, Inc." — trailing comma avoids matching "Google LLC" (Android phones)
    'raspberry pi',
    'arduino', 'particle industries',
    'tp-link',   // Kasa smart devices
    'realtek(iot',
  ];

  /// Returns 'IoT Device' when [mac] belongs to a known IoT OUI prefix.
  /// Falls back to empty string if the MAC is unknown or N/A.
  static String deviceTypeFromMac(String mac) {
    if (mac == 'N/A' || mac.length < 8) return '';
    final prefix = mac.toUpperCase().substring(0, 8);
    // Check against the IoT prefixes used by IotScanner
    // (inline check avoids importing iot_scanner to prevent circular deps)
    const iotPrefixes = <String>{
      '10:06:1C','18:FE:34','24:0A:C4','2C:3A:E8','30:AE:A4','3C:71:BF',
      '48:3F:DA','48:E7:29','4C:11:AE','58:BF:25','5C:CF:7F','60:01:94',
      '68:C6:3A','7C:9E:BD','80:64:6F','80:7D:3A','84:0D:8E','84:CC:A8',
      '8C:AA:B5','A0:20:A6','A4:CF:12','A8:03:2A','AC:67:B2','B4:E6:2D',
      'BC:DD:C2','C4:4F:33','CC:50:E3','D4:8A:FC','D8:A0:1D','DC:4F:22',
      'E0:98:06','E4:65:B8','EC:FA:BC','F4:CF:A2','FC:F5:C4', // Espressif
      'D0:F6:18','E6:9E:7E','F4:CE:36',                       // Nordic
      '00:0D:6F','78:A5:04',                                  // Silicon Labs
      '00:12:4B',                                             // TI
      '00:80:E1','10:E7:7A','18:E8:EC','40:82:7B','50:0F:59', // STMicro
      '1C:90:FF','CC:02:D1','CC:8C:BF','E4:AE:E4','FC:3C:D7','FC:67:1F', // Tuya
      'C8:47:8C','70:87:9E','80:6D:DE','D8:5D:4C','E0:5A:1B', // Beken/Tuya
      'C4:5B:BE',                                             // Shelly
      '60:55:F9','BC:FF:4D',                                  // Sonoff/ITEAD
      '50:C7:BF','98:DA:C4','B0:95:75','C0:06:C3','D8:0D:17', // TP-Link
      '28:6C:07','34:CE:00','50:64:2B','64:09:80','78:11:DC',
      '98:FA:E3','AC:29:3A','F4:F5:DB',                       // Xiaomi
      '48:E1:E9','C4:E7:AE',                                  // Meross
      'B4:75:0E','D8:EC:5E','E8:9F:80','EC:1A:59',            // Belkin/WeMo
      '00:17:88','C4:29:96','EC:B5:FA','FC:26:8C',            // Philips Hue/Signify
      '68:EC:8A','AC:23:3F',                                  // IKEA
      '28:CD:C1','88:A2:9E','98:FE:54','DC:A6:32','D8:3A:DD','E4:5F:01', // RPi
      '08:91:A3','28:73:F6','68:37:E9','84:28:59','E0:CB:1D','FC:D7:49', // Amazon
      '08:B4:B1','24:29:34','54:60:09','60:70:6C','60:B7:6E','C8:2A:DD', // Google
      '24:FD:5B',                                             // SmartThings
      '2C:AA:8E','7C:78:B2','80:48:2C','D0:3F:27','F0:C8:8B', // Wyze
      'A8:61:0A','94:94:4A',                                  // Arduino/Particle
      'AC:9A:22','B4:3D:6B',                                  // NXP
      '00:E0:4C',                                             // Realtek(IoT-bridge)
    };
    if (iotPrefixes.contains(prefix)) return 'IoT Device';
    return '';
  }

  static String _detectDeviceType(String manufacturer) {
    if (manufacturer.isEmpty) return '';
    
    final lower = manufacturer.toLowerCase();

    // IoT / embedded chip vendors — checked first because e.g. "Espressif" or
    // "Tuya Smart" would otherwise fall through to no match.
    for (final kw in _iotVendorKeywords) {
      if (lower.contains(kw)) return 'IoT Device';
    }
    
    // Smart TV / Media devices
    if (lower.contains('samsung') || lower.contains('lg') || lower.contains('vizio') || 
        lower.contains('sony') || lower.contains('roku') || lower.contains('apple tv')) {
      return 'Smart TV';
    }
    
    // Smart Home hubs / platforms
    if (lower.contains('echo') || lower.contains('nest') || lower.contains('ring ') ||
        lower.contains('arlo ')) {
      return 'Smart Home';
    }
    
    // Printers
    if (lower.contains('printer') || lower.contains('xerox') || lower.contains('canon') ||
        lower.contains('hp inc') || lower.contains('epson') || lower.contains('ricoh')) {
      return 'Printer';
    }
    
    // IP Cameras
    if (lower.contains('camera') || lower.contains('hikvision') || lower.contains('axis') ||
        lower.contains('dahua') || lower.contains('uniview')) {
      return 'IP Camera';
    }
    
    // Networking equipment
    if (lower.contains('cisco') || lower.contains('router') || lower.contains('netgear') ||
        lower.contains('d-link') || lower.contains('asus') || lower.contains('ubiquiti') ||
        lower.contains('arista') || lower.contains('juniper') || lower.contains('fortinet')) {
      return 'Network Device';
    }
    
    // Mobile / Apple
    if (lower.contains('apple')) return 'Apple Device';
    if (lower.contains('samsung') && lower.contains('mobile')) return 'Android Device';
    
    // Workstations / Computers
    if (lower.contains('intel') || lower.contains('realtek') || lower.contains('broadcom') ||
        lower.contains('atheros') || lower.contains('qualcomm')) {
      return 'Computer';
    }
    
    return '';
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

    // Read fresh ARP table after all IPs have been pinged.
    final arpTable  = await _readArpTable();
    // Overlay self MACs — the device's own IPs are never in the neighbour
    // table, so we fetch them from the network interfaces directly.
    final selfMacs  = await _getSelfMacs();
    _selfMacCache   = null; // reset cache for next scan
    for (final entry in selfMacs.entries) {
      arpTable[entry.key] = entry.value;
    }
    // Fill results with MAC addresses, manufacturer names, and device types
    for (final host in allResults) {
      final mac = arpTable[host.ip];
      if (mac != null && mac.isNotEmpty) {
        host.mac = mac;
        host.manufacturer = OuiService.lookup(mac);
      } else {
        host.mac = host.mac != '' ? host.mac : 'N/A';
        host.manufacturer = host.manufacturer != '' ? host.manufacturer : '';
      }
      // Detect device type from manufacturer
      // MAC-based IoT classification takes priority over manufacturer name matching
      final macType = deviceTypeFromMac(host.mac);
      host.deviceType = macType.isNotEmpty
          ? macType
          : _detectDeviceType(host.manufacturer);
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
          'ping', ['-c', '1', '-W', '2', ip],
          runInShell: true,
        ).timeout(_pingTimeout);
        alive = result.exitCode == 0;
      } catch (_) {}
    }

    if (!alive) {
      // Expanded port list covers web, SSH, SMB, Matter, MQTT, TP-Link, IoT HTTP
      for (final port in NetworkPorts.livenessProbePorts) {
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
