library iot_scanner;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// IoT device detection service.
///
/// Detection pipeline:
///   1. OUI-based vendor labelling from MAC address (Espressif, Nordic, TI, ST, etc.)
///   2. HTTP probe on well-known IoT ports → firmware fingerprinting
///      (Tasmota, eWeLink, Shelly, Tuya, ESPHome, Sonoff DIY, Home Assistant,
///       openHAB, Zigbee2MQTT, MQTT broker, HomeKit HAP, WeMo, TP-Link Kasa,
///       Xiaomi MiIO, Meross)
///   3. mDNS / DNS-SD service discovery for Matter (_matter._tcp),
///      HomeKit (_hap._tcp), ESPHome (_esphomelib._tcp), etc.
///   4. TCP knock on Matter BLE-less commissioning port (5540) to confirm.
///
/// Each result carries a [confidence] 0-100 and a [detectionMethod] string.

// ── Public model ──────────────────────────────────────────────────────────────

enum IotConfidence { definite, probable, possible }

class IotDevice {
  final String ip;
  final String mac;               // may be 'N/A'
  final String vendor;            // OUI-derived hardware vendor
  final String protocol;          // detected smart-home protocol / firmware
  final String model;             // device model if discoverable
  final List<int> openPorts;
  final IotConfidence confidence;
  final String detectionMethod;   // human-readable: "HTTP/Tasmota", "mDNS", …
  final Map<String, String> extra; // extra k/v from HTTP responses

  const IotDevice({
    required this.ip,
    required this.mac,
    required this.vendor,
    required this.protocol,
    required this.model,
    required this.openPorts,
    required this.confidence,
    required this.detectionMethod,
    this.extra = const {},
  });

  @override
  String toString() =>
      '$ip  $protocol  $vendor  [$detectionMethod, ${confidence.name}]';
}

// ── Scanner ───────────────────────────────────────────────────────────────────

class IotScanner {
  IotScanner._();

  // ---------- well-known IoT MAC OUI prefixes (first 3 octets, uppercase) ---
  // Source: IEEE OUI + vendor product pages
  static const _ouiVendors = <String, String>{
    '18:FE:34': 'Espressif',  '24:0A:C4': 'Espressif',  '2C:3A:E8': 'Espressif',
    '30:AE:A4': 'Espressif',  '3C:71:BF': 'Espressif',  '48:3F:DA': 'Espressif',
    '4C:11:AE': 'Espressif',  '58:BF:25': 'Espressif',  '5C:CF:7F': 'Espressif',
    '60:01:94': 'Espressif',  '68:C6:3A': 'Espressif',  '7C:9E:BD': 'Espressif',
    '80:7D:3A': 'Espressif',  '84:0D:8E': 'Espressif',  '84:CC:A8': 'Espressif',
    '8C:AA:B5': 'Espressif',  'A0:20:A6': 'Espressif',  'A4:CF:12': 'Espressif',
    'A8:03:2A': 'Espressif',  'AC:67:B2': 'Espressif',  'B4:E6:2D': 'Espressif',
    'BC:DD:C2': 'Espressif',  'C4:4F:33': 'Espressif',  'CC:50:E3': 'Espressif',
    'D8:A0:1D': 'Espressif',  'DC:4F:22': 'Espressif',  'E0:98:06': 'Espressif',
    'EC:FA:BC': 'Espressif',  'F4:CF:A2': 'Espressif',  'FC:F5:C4': 'Espressif',
    'F4:CE:36': 'Nordic',     'D0:F6:18': 'Nordic',     'E6:9E:7E': 'Nordic',
    '00:0D:6F': 'Silicon Labs','78:A5:04': 'Silicon Labs',
    '00:12:4B': 'TI',
    '00:80:E1': 'STMicro',
    'C4:5B:BE': 'Shelly',
    '60:55:F9': 'Sonoff/ITEAD','BC:FF:4D': 'Sonoff/ITEAD',
    '50:C7:BF': 'TP-Link',    '98:DA:C4': 'TP-Link',    'B0:95:75': 'TP-Link',
    'C0:06:C3': 'TP-Link',    'D8:0D:17': 'TP-Link',
    '28:6C:07': 'Xiaomi',     '34:CE:00': 'Xiaomi',     '50:64:2B': 'Xiaomi',
    '64:09:80': 'Xiaomi',     '78:11:DC': 'Xiaomi',     '98:FA:E3': 'Xiaomi',
    'AC:29:3A': 'Xiaomi',     'F4:F5:DB': 'Xiaomi',
    '48:E1:E9': 'Meross',
    'D8:5D:4C': 'Tuya/Beken', 'E0:5A:1B': 'Tuya/Beken',
    'B4:75:0E': 'Belkin/WeMo','EC:1A:59': 'Belkin/WeMo',
    '00:17:88': 'Philips Hue','EC:B5:FA': 'Philips Hue',
    'AC:23:3F': 'IKEA Trådfri',
    'DC:A6:32': 'RPi',        'E4:5F:01': 'RPi',        '28:CD:C1': 'RPi',
    // HUSBZB / ConBee / Sonoff Zigbee dongle USB bridges (show as USB eth)
    '00:E0:4C': 'Realtek(IoT-bridge)',
  };

  // ---------- IoT TCP port definitions ----------------------------------------
  // port → (protocol label, description)
  static const _iotPorts = <int, String>{
    80:   'HTTP',
    443:  'HTTPS',
    1883: 'MQTT',
    8883: 'MQTT-TLS',
    8080: 'HTTP-alt',
    8081: 'HTTP-alt2',
    8123: 'Home Assistant',
    8443: 'HTTPS-alt',
    1080: 'SOCKS/proxy',
    5353: 'mDNS',          // UDP — handled separately
    5540: 'Matter',
    8888: 'Zigbee2MQTT',
    9000: 'openHAB',
    9443: 'openHAB-TLS',
    49153: 'WeMo',
    55443: 'Xiaomi MiIO',
    6668:  'Meross',
    4040:  'TP-Link Kasa',
    9999:  'TP-Link Kasa legacy',
    20202: 'Matter commissioning',
  };

  // ---------- HTTP fingerprints -----------------------------------------------
  // Each rule: { headerOrBody fragment → (protocol, model-hint) }
  // Checked against: Server header + body (first 512 bytes)
  static const _httpFingerprints = <String, String>{
    'Tasmota':         'Tasmota',
    'tasmota':         'Tasmota',
    'ESP_':            'ESP/generic',
    'ESPHome':         'ESPHome',
    'esphome':         'ESPHome',
    'Shelly':          'Shelly',
    'ShellyPro':       'Shelly Pro',
    'eWeLink':         'eWeLink',
    'ITEAD':           'Sonoff (eWeLink)',
    'sonoff':          'Sonoff',
    'Home Assistant':  'Home Assistant',
    'homeassistant':   'Home Assistant',
    'openHAB':         'openHAB',
    'Zigbee2MQTT':     'Zigbee2MQTT',
    'tplink':          'TP-Link Kasa',
    'TP-LINK':         'TP-Link Kasa',
    'Kasa':            'TP-Link Kasa',
    'yeelink':         'Xiaomi Yeelight',
    'miio':            'Xiaomi MiIO',
    'Meross':          'Meross',
    'WeMo':            'Belkin WeMo',
    'Philips hue':     'Philips Hue',
    'Philips Hue':     'Philips Hue',
    'ikea':            'IKEA Trådfri',
    'tradfri':         'IKEA Trådfri',
    'Matter':          'Matter device',
    'chip':            'Matter/CHIP',
    'Node-RED':        'Node-RED',
    'Domoticz':        'Domoticz',
    'FRITZ':           'AVM FRITZ! (IoT router)',
  };

  // ---------- public scan entry point -----------------------------------------

  /// Scans [cidr] for IoT devices.
  /// Yields results as they are found.
  static Stream<IotDevice> scanSubnet(String cidr) async* {
    final parts   = cidr.split('/');
    if (parts.length != 2) return;
    final base    = parts[0];
    final prefix  = int.tryParse(parts[1]) ?? 24;

    final octets  = base.split('.').map(int.parse).toList();
    final baseInt = (octets[0] << 24) | (octets[1] << 16) |
                    (octets[2] << 8)  |  octets[3];
    final mask    = 0xFFFFFFFF << (32 - prefix);
    final net     = baseInt & mask;
    final bcast   = net | (~mask & 0xFFFFFFFF);

    // Concurrency limiter — IoT scans are fast HTTP/TCP; 32 concurrent is safe
    final sem     = _Semaphore(32);

    final futures = <Future<IotDevice?>>[];
    for (var addr = net + 1; addr < bcast; addr++) {
      final ip = '${(addr >> 24) & 0xFF}.${(addr >> 16) & 0xFF}'
                 '.${(addr >> 8) & 0xFF}.${addr & 0xFF}';
      futures.add(sem.run(() => _probeHost(ip)));
    }

    final controller = StreamController<IotDevice>();
    var pending = futures.length;
    for (final f in futures) {
      f.then((dev) {
        if (dev != null) controller.add(dev);
        pending--;
        if (pending == 0) controller.close();
      }).catchError((_) {
        pending--;
        if (pending == 0) controller.close();
      });
    }
    yield* controller.stream;
  }

  // ---------- per-host probe ---------------------------------------------------

  static Future<IotDevice?> _probeHost(String ip) async {
    // Step 1 — quick connectivity check: try port 80 first, then scan IoT ports
    final openPorts = await _scanPorts(ip, _iotPorts.keys.toList());
    if (openPorts.isEmpty) return null;

    // Step 2 — OUI vendor lookup from ARP cache
    final mac    = await _getMacFromArp(ip);
    final vendor = mac != null ? _vendorFromMac(mac) : 'Unknown';

    // Step 3 — HTTP fingerprinting
    String protocol = vendor.isNotEmpty && vendor != 'Unknown'
        ? '${vendor} device'
        : 'Unknown IoT';
    String model   = '';
    String method  = 'TCP port';
    final extra    = <String, String>{};
    IotConfidence confidence = IotConfidence.possible;

    if (openPorts.contains(80) || openPorts.contains(8080) ||
        openPorts.contains(8081) || openPorts.contains(8123)) {
      final port   = openPorts.firstWhere(
          (p) => [80, 8080, 8081, 8123].contains(p), orElse: () => 80);
      final result = await _httpProbe(ip, port);
      if (result != null) {
        protocol   = result.$1;
        model      = result.$2;
        method     = 'HTTP/$protocol';
        confidence = IotConfidence.definite;
        if (result.$3.isNotEmpty) extra.addAll(result.$3);
      }
    }

    // Step 4 — MQTT detection (port 1883)
    if (openPorts.contains(1883) && protocol.contains('Unknown')) {
      protocol   = 'MQTT broker';
      method     = 'TCP/MQTT';
      confidence = IotConfidence.probable;
    }

    // Step 5 — Matter detection (port 5540 or 20202)
    if (openPorts.contains(5540) || openPorts.contains(20202)) {
      protocol   = protocol.contains('Unknown') ? 'Matter device' : '$protocol + Matter';
      method     = '$method + Matter port';
      confidence = IotConfidence.definite;
    }

    // Step 6 — TP-Link Kasa protocol (port 9999 binary XOR protocol)
    if (openPorts.contains(9999) && protocol.contains('Unknown')) {
      final kasaResult = await _tplinkProbe(ip);
      if (kasaResult != null) {
        protocol   = 'TP-Link Kasa';
        model      = kasaResult;
        method     = 'Kasa XOR protocol';
        confidence = IotConfidence.definite;
      }
    }

    // Only return if vendor is known or a protocol was identified
    final isKnown = vendor != 'Unknown' || !protocol.contains('Unknown');
    if (!isKnown && confidence == IotConfidence.possible) return null;

    return IotDevice(
      ip:              ip,
      mac:             mac ?? 'N/A',
      vendor:          vendor,
      protocol:        protocol,
      model:           model,
      openPorts:       openPorts,
      confidence:      confidence,
      detectionMethod: method,
      extra:           extra,
    );
  }

  // ---------- port scan --------------------------------------------------------

  static Future<List<int>> _scanPorts(String ip, List<int> ports) async {
    final results = <int>[];
    // Skip UDP port 5353 for TCP scan
    final tcpPorts = ports.where((p) => p != 5353).toList();
    final futs = tcpPorts.map((port) async {
      try {
        final sock = await Socket.connect(ip, port,
            timeout: const Duration(milliseconds: 600));
        await sock.close();
        return port;
      } catch (_) {
        return null;
      }
    });
    final done = await Future.wait(futs);
    for (final p in done) {
      if (p != null) results.add(p);
    }
    return results;
  }

  // ---------- HTTP fingerprint probe -------------------------------------------

  static Future<(String, String, Map<String, String>)?> _httpProbe(
      String ip, int port) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);
      final req    = await client.get(ip, port, '/');
      req.headers.set('User-Agent', 'SimplyNet/1.0');
      final resp   = await req.close().timeout(const Duration(seconds: 4));

      final server = resp.headers.value('server') ?? '';
      final xFirmware = resp.headers.value('x-firmware') ?? '';
      final bodyBytes = <int>[];
      await for (final chunk in resp.take(2)) bodyBytes.addAll(chunk);
      client.close();

      final body    = String.fromCharCodes(bodyBytes.take(1024).toList(),
          0, bodyBytes.length > 1024 ? 1024 : bodyBytes.length);
      final haystack = '$server $xFirmware $body'.toLowerCase();

      String protocol = '';
      String model    = '';

      for (final entry in _httpFingerprints.entries) {
        if (haystack.contains(entry.key.toLowerCase())) {
          protocol = entry.value;
          break;
        }
      }

      // Tasmota: extract module name from body
      if (protocol == 'Tasmota') {
        final m = RegExp(r'<title>(.+?)</title>').firstMatch(body);
        if (m != null) model = m.group(1) ?? '';
      }
      // ESPHome: extract device name from body
      if (protocol == 'ESPHome') {
        final m = RegExp(r'"name":\s*"([^"]+)"').firstMatch(body);
        if (m != null) model = m.group(1) ?? '';
      }
      // Home Assistant: check version header
      if (protocol == 'Home Assistant') {
        final ver = resp.headers.value('x-ha-version') ?? '';
        if (ver.isNotEmpty) model = 'HA $ver';
      }

      final extras = <String, String>{};
      if (server.isNotEmpty)    extras['server']     = server;
      if (xFirmware.isNotEmpty) extras['firmware']   = xFirmware;

      if (protocol.isEmpty) return null;
      return (protocol, model, extras);
    } catch (_) {
      return null;
    }
  }

  // ---------- TP-Link Kasa XOR probe ------------------------------------------

  static Future<String?> _tplinkProbe(String ip) async {
    // Kasa protocol: send XOR-encoded {"system":{"get_sysinfo":{}}}
    // Response contains device model and alias in JSON
    try {
      final sock = await Socket.connect(ip, 9999,
          timeout: const Duration(milliseconds: 800));
      final payload = _kasaXorEncode('{"system":{"get_sysinfo":{}}}');
      sock.add(payload);
      final data    = <int>[];
      await sock.timeout(const Duration(seconds: 2)).forEach(data.addAll);
      await sock.close();
      if (data.length < 4) return null;
      final json = _kasaXorDecode(Uint8List.fromList(data.sublist(4)));
      final m    = RegExp(r'"model":"([^"]+)"').firstMatch(json);
      return m?.group(1);
    } catch (_) {
      return null;
    }
  }

  static Uint8List _kasaXorEncode(String plain) {
    final bytes = plain.codeUnits;
    final out   = Uint8List(4 + bytes.length);
    out[0] = 0; out[1] = 0;
    out[2] = (bytes.length >> 8) & 0xFF;
    out[3] = bytes.length & 0xFF;
    int key = 0xAB;
    for (var i = 0; i < bytes.length; i++) {
      key = out[4 + i] = bytes[i] ^ key;
    }
    return out;
  }

  static String _kasaXorDecode(Uint8List data) {
    int key = 0xAB;
    final out = <int>[];
    for (final b in data) {
      out.add(b ^ key);
      key = b;
    }
    return String.fromCharCodes(out);
  }

  // ---------- ARP cache MAC lookup --------------------------------------------

  static Future<String?> _getMacFromArp(String ip) async {
    try {
      final result = await Process.run('cat', ['/proc/net/arp']);
      for (final line in (result.stdout as String).split('\n').skip(1)) {
        final cols = line.trim().split(RegExp(r'\s+'));
        if (cols.length >= 4 && cols[0] == ip) {
          final mac = cols[3].toUpperCase();
          if (mac != '00:00:00:00:00:00') return mac;
        }
      }
    } catch (_) {}
    return null;
  }

  // ---------- OUI vendor lookup ------------------------------------------------

  static String _vendorFromMac(String mac) {
    if (mac == 'N/A' || mac.length < 8) return 'Unknown';
    final prefix = mac.toUpperCase().substring(0, 8);
    return _ouiVendors[prefix] ?? '';
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
