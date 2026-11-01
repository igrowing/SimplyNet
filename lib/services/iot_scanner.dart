import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:simply_net/constants/iot_signatures.dart';
import 'package:simply_net/constants/network_ports.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/iot_classifier.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/oui_service.dart';

export 'package:simply_net/constants/iot_signatures.dart' show IotConfidence;

/// IoT device detection service.
///
/// Detection pipeline, per live host:
///   1. Hostname, MAC and OUI vendor come from `HostResult` (ARP table, or a
///      MAC published as the hostname) — the same sources as the LAN scan.
///   2. TCP probe of the ports in `NetworkPorts.iotPortNames`.
///   3. HTTP probe of every open web port → firmware fingerprint (Tasmota,
///      Shelly, ESPHome, WLED, Home Assistant, ...).
///   4. TP-Link Kasa binary probe on port 9999.
///   5. `IotClassifier` scores hostname signatures, MAC, vendor, ports and
///      the HTTP fingerprint into a label and a confidence.
///
/// No single signal is required: a plug with no open port is still found by
/// its hostname or MAC vendor.

// ── Public model ──────────────────────────────────────────────────────────────

class IotDevice {
  final String ip;
  final String mac; // may be 'N/A'
  final String hostname; // resolved name, '' when unknown
  final String vendor; // OUI-derived hardware vendor
  final String protocol; // detected device category / firmware
  final String model; // device model if discoverable
  final List<int> openPorts;
  final IotConfidence confidence;
  final String detectionMethod; // human-readable evidence list
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
    this.hostname = '',
    this.extra = const {},
  });

  @override
  String toString() =>
      '$ip  $protocol  $vendor  [$detectionMethod, ${confidence.name}]';

  Map<String, dynamic> toJson() => {
    'ip': ip,
    'mac': mac,
    'hostname': hostname,
    'vendor': vendor,
    'protocol': protocol,
    'model': model,
    'openPorts': openPorts,
    'confidence': confidence.name,
    'detectionMethod': detectionMethod,
    'extra': extra,
  };

  /// Rebuilds an [IotDevice] from its [toJson] map.
  ///
  /// Throws [FormatException] when the mandatory `ip` field is missing —
  /// a corrupt cache entry must fail loudly rather than load a blank device.
  /// `hostname` is absent in caches written by older versions and loads as ''.
  factory IotDevice.fromJson(Map<String, dynamic> json) {
    final ip = json['ip'];
    if (ip is! String || ip.isEmpty) {
      throw const FormatException('IotDevice.fromJson: missing "ip"');
    }
    final confName =
        json['confidence'] as String? ?? IotConfidence.possible.name;
    return IotDevice(
      ip: ip,
      mac: json['mac'] as String? ?? 'N/A',
      hostname: json['hostname'] as String? ?? '',
      vendor: json['vendor'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      model: json['model'] as String? ?? '',
      openPorts: (json['openPorts'] as List<dynamic>? ?? const [])
          .map((e) => e as int)
          .toList(),
      confidence: IotConfidence.values.firstWhere(
        (c) => c.name == confName,
        orElse: () => IotConfidence.possible,
      ),
      detectionMethod: json['detectionMethod'] as String? ?? '',
      extra: (json['extra'] as Map<String, dynamic>? ?? const {}).map(
        (k, v) => MapEntry(k, v.toString()),
      ),
    );
  }
}

// ── Scanner ───────────────────────────────────────────────────────────────────

class IotScanner {
  IotScanner._();

  // ---------- IoT TCP port definitions ----------------------------------------
  // port → protocol label. Defined centrally in [NetworkPorts].
  static const _iotPorts = NetworkPorts.iotPortNames;

  static const _httpPorts = [80, 1880, 8008, 8080, 8081, 8123];

  // ---------- HTTP fingerprints -----------------------------------------------
  // Each rule: { headerOrBody fragment → protocol }.
  // Checked against Server header + X-Firmware header + body (first 1 KiB).
  // The first matching rule wins, so specific entries precede generic ones.
  static const _httpFingerprints = <String, String>{
    'OpenBeken': 'OpenBeken',
    'Tasmota': 'Tasmota',
    'ESP_': 'ESP/generic',
    'ESPHome': 'ESPHome',
    'WLED': 'WLED',
    'ShellyPro': 'Shelly Pro',
    'Shelly': 'Shelly',
    'eWeLink': 'eWeLink',
    'ITEAD': 'Sonoff (eWeLink)',
    'sonoff': 'Sonoff',
    'Home Assistant': 'Home Assistant',
    'homeassistant': 'Home Assistant',
    'openHAB': 'openHAB',
    'Zigbee2MQTT': 'Zigbee2MQTT',
    'SLZB': 'Zigbee hub',
    'ZigStar': 'Zigbee hub',
    'OctoPrint': 'OctoPrint',
    'motionEye': 'motionEye',
    'Homebridge': 'Homebridge',
    'Pi-hole': 'Pi-hole',
    'Homey': 'Homey',
    'Hubitat': 'Hubitat',
    'Aqara': 'Aqara',
    'tplink': 'TP-Link Kasa',
    'TP-LINK': 'TP-Link Kasa',
    'Kasa': 'TP-Link Kasa',
    'yeelink': 'Xiaomi Yeelight',
    'miio': 'Xiaomi MiIO',
    'Meross': 'Meross',
    'WeMo': 'Belkin WeMo',
    'Philips hue': 'Philips Hue',
    'ikea': 'IKEA Trådfri',
    'tradfri': 'IKEA Trådfri',
    'Matter': 'Matter device',
    'Node-RED': 'Node-RED',
    'Domoticz': 'Domoticz',
    'FRITZ': 'AVM FRITZ! (IoT router)',
  };

  // ---------- public scan entry points ----------------------------------------

  /// Scans [cidr] for IoT devices.
  ///
  /// Discovers live hosts with `NetworkScanner.scan` (ping, hostname, ARP,
  /// OUI) and then runs the same per-host pipeline as [scanHosts]. Yields
  /// results as they are found.
  static Stream<IotDevice> scanSubnet(
    String cidr, {
    void Function(String line)? onSkipped,
  }) async* {
    if (!NetworkScanner.isValidCidr(cidr)) return;
    // The scan emits each host twice (before and after MAC enrichment); the
    // map keeps the latest, enriched emission.
    final hosts = <String, HostResult>{};
    await for (final host in NetworkScanner.scan(cidr)) {
      hosts[host.ip] = host;
    }
    yield* scanHosts(hosts.values.toList(), onSkipped: onSkipped);
  }

  /// Probes [hosts] for IoT devices without a subnet sweep.
  ///
  /// Used when `ScanProvider` already holds a fresh host list, so ARP/ping
  /// discovery and hostname resolution are not repeated. [onSkipped] receives
  /// a one-line description of every host that showed no IoT evidence, so the
  /// caller can log why a device was missed.
  static Stream<IotDevice> scanHosts(
    List<HostResult> hosts, {
    void Function(String line)? onSkipped,
  }) {
    final sem = _Semaphore(32);
    final controller = StreamController<IotDevice>();
    var pending = hosts.length;

    if (pending == 0) {
      unawaited(controller.close());
      return controller.stream;
    }

    void finishOne() {
      pending--;
      if (pending == 0) unawaited(controller.close());
    }

    for (final host in hosts) {
      sem
          .run(() => _probeHost(host, onSkipped))
          .then((dev) {
            if (dev != null) controller.add(dev);
            finishOne();
          })
          .catchError((_) {
            finishOne();
          });
    }
    return controller.stream;
  }

  // ---------- per-host probe ---------------------------------------------------

  static Future<IotDevice?> _probeHost(
    HostResult host,
    void Function(String line)? onSkipped,
  ) async {
    final ip = host.ip;
    final mac = host.mac;
    final hasMac = mac.isNotEmpty && mac != 'N/A';
    final vendor = host.manufacturer.isNotEmpty || !hasMac
        ? host.manufacturer
        : OuiService.lookup(mac);

    final openPorts = await _scanPorts(ip, _iotPorts.keys.toList());

    // HTTP fingerprint: try every open web port until one is recognised.
    String? httpProtocol;
    var model = '';
    final extra = <String, String>{};
    for (final port in _httpPorts.where(openPorts.contains)) {
      final result = await _httpProbe(ip, port);
      if (result != null) {
        httpProtocol = result.$1;
        model = result.$2;
        extra.addAll(result.$3);
        break;
      }
    }

    // TP-Link Kasa binary protocol.
    if (httpProtocol == null && openPorts.contains(9999)) {
      final kasaModel = await _tplinkProbe(ip);
      if (kasaModel != null) {
        return IotDevice(
          ip: ip,
          mac: hasMac ? mac : 'N/A',
          hostname: host.hostname,
          vendor: vendor,
          protocol: 'TP-Link Kasa',
          model: kasaModel,
          openPorts: openPorts,
          confidence: IotConfidence.definite,
          detectionMethod: 'Kasa XOR protocol',
        );
      }
    }

    final classification = IotClassifier.classify(
      hostname: host.hostname,
      mac: mac,
      vendor: vendor,
      openPorts: openPorts,
      httpProtocol: httpProtocol,
    );
    if (classification == null) {
      onSkipped?.call(
        '$ip  hostname="${host.hostname}"  mac=$mac  vendor="$vendor"  '
        'ports=$openPorts',
      );
      return null;
    }

    return IotDevice(
      ip: ip,
      mac: hasMac ? mac : 'N/A',
      hostname: host.hostname,
      vendor: vendor,
      protocol: classification.label,
      model: model,
      openPorts: openPorts,
      confidence: classification.confidence,
      detectionMethod: classification.method,
      extra: extra,
    );
  }

  // ---------- port scan --------------------------------------------------------

  static Future<List<int>> _scanPorts(String ip, List<int> ports) async {
    final futs = ports.map((port) async {
      try {
        final sock = await Socket.connect(
          ip,
          port,
          timeout: const Duration(milliseconds: 600),
        );
        await sock.close();
        return port;
      } catch (_) {
        return null;
      }
    });
    final done = await Future.wait(futs);
    return done.whereType<int>().toList()..sort();
  }

  // ---------- HTTP fingerprint probe -------------------------------------------

  static Future<(String, String, Map<String, String>)?> _httpProbe(
    String ip,
    int port,
  ) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);
    try {
      final req = await client.get(ip, port, '/');
      req.headers.set('User-Agent', 'SimplyNet/1.0');
      final resp = await req.close().timeout(const Duration(seconds: 4));

      final server = resp.headers.value('server') ?? '';
      final xFirmware = resp.headers.value('x-firmware') ?? '';
      final bodyBytes = <int>[];
      await for (final chunk in resp.take(2)) {
        bodyBytes.addAll(chunk);
      }

      final body = String.fromCharCodes(
        bodyBytes.take(1024).toList(),
        0,
        bodyBytes.length > 1024 ? 1024 : bodyBytes.length,
      );
      final haVersion = resp.headers.value('x-ha-version') ?? '';
      return classifyHttp(
        server: server,
        xFirmware: xFirmware,
        body: body,
        haVersion: haVersion,
      );
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  /// Pure fingerprinting of an HTTP response. Given the `Server` header,
  /// `X-Firmware` header, response [body] and (optional) Home-Assistant
  /// version header, returns the detected `(protocol, model, extras)` or null
  /// when no IoT firmware signature matches. Separated from the socket I/O so
  /// the fingerprint matching and model extraction can be tested directly.
  @visibleForTesting
  static (String, String, Map<String, String>)? classifyHttp({
    required String server,
    required String xFirmware,
    required String body,
    String haVersion = '',
  }) {
    final haystack = '$server $xFirmware $body'.toLowerCase();

    String protocol = '';
    String model = '';

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
      if (haVersion.isNotEmpty) model = 'HA $haVersion';
    }

    final extras = <String, String>{};
    if (server.isNotEmpty) extras['server'] = server;
    if (xFirmware.isNotEmpty) extras['firmware'] = xFirmware;

    if (protocol.isEmpty) return null;
    return (protocol, model, extras);
  }

  // ---------- TP-Link Kasa XOR probe ------------------------------------------

  static Future<String?> _tplinkProbe(String ip) async {
    // Kasa protocol: send XOR-encoded {"system":{"get_sysinfo":{}}}
    // Response contains device model and alias in JSON
    try {
      final sock = await Socket.connect(
        ip,
        9999,
        timeout: const Duration(milliseconds: 800),
      );
      final payload = kasaXorEncode('{"system":{"get_sysinfo":{}}}');
      sock.add(payload);
      final data = <int>[];
      await sock.timeout(const Duration(seconds: 2)).forEach(data.addAll);
      await sock.close();
      if (data.length < 4) return null;
      final json = kasaXorDecode(Uint8List.fromList(data.sublist(4)));
      final m = RegExp(r'"model":"([^"]+)"').firstMatch(json);
      return m?.group(1);
    } catch (_) {
      return null;
    }
  }

  @visibleForTesting
  static Uint8List kasaXorEncode(String plain) {
    final bytes = plain.codeUnits;
    final out = Uint8List(4 + bytes.length);
    out[0] = 0;
    out[1] = 0;
    out[2] = (bytes.length >> 8) & 0xFF;
    out[3] = bytes.length & 0xFF;
    int key = 0xAB;
    for (var i = 0; i < bytes.length; i++) {
      key = out[4 + i] = bytes[i] ^ key;
    }
    return out;
  }

  @visibleForTesting
  static String kasaXorDecode(Uint8List data) {
    int key = 0xAB;
    final out = <int>[];
    for (final b in data) {
      out.add(b ^ key);
      key = b;
    }
    return String.fromCharCodes(out);
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
