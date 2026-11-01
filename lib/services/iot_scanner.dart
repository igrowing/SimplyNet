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

// ── Port probe model ──────────────────────────────────────────────────────────

/// Result of one TCP connect attempt.
enum PortProbeOutcome {
  /// The connection was accepted.
  open,

  /// The host refused the connection: it is alive, the port is closed.
  closed,

  /// No answer within the timeout.
  timeout,

  /// The OS reported the host or network unreachable.
  unreachable,
}

/// Open ports and outcome counts of a host's port probe.
@immutable
class PortScanResult {
  /// Creates a result from explicit counts.
  const PortScanResult({
    required this.open,
    required this.closed,
    required this.timedOut,
    required this.unreachable,
  });

  /// Tallies per-port [outcomes].
  factory PortScanResult.from(Map<int, PortProbeOutcome> outcomes) {
    int count(PortProbeOutcome o) =>
        outcomes.values.where((v) => v == o).length;
    return PortScanResult(
      open: [
        for (final e in outcomes.entries)
          if (e.value == PortProbeOutcome.open) e.key,
      ]..sort(),
      closed: count(PortProbeOutcome.closed),
      timedOut: count(PortProbeOutcome.timeout),
      unreachable: count(PortProbeOutcome.unreachable),
    );
  }

  /// Open ports, ascending.
  final List<int> open;

  /// Ports that refused the connection.
  final int closed;

  /// Ports that did not answer in time (after the retry).
  final int timedOut;

  /// Ports for which the OS reported the host unreachable.
  final int unreachable;

  /// True when the host answered on at least one port (open or refused).
  bool get hostResponded => open.isNotEmpty || closed > 0;

  /// One-line diagnostic for the scan log.
  String get summary =>
      'ports=$open closed=$closed timeout=$timedOut unreachable=$unreachable';
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

  static final _chipWord = RegExp(r'\bchip\b');

  // ---------- port-probe tuning ------------------------------------------------

  /// Connect timeout for a host known to be alive. Wi-Fi IoT chips in
  /// power-save mode answer late, so this is well above a LAN round trip.
  static const _portTimeout = Duration(milliseconds: 1500);

  /// Shorter timeout for the liveness gate of addresses no ping answered.
  static const _gateTimeout = Duration(milliseconds: 1000);

  /// Ports probed first on an address no ping answered. If none of them gets
  /// any reply (open or refused) the address is treated as empty.
  static const _gatePorts = [80, 8123, 1883, 6668];

  /// Caps simultaneous TCP connects across all hosts, so a scan never fires
  /// hundreds of SYNs at once over Wi-Fi.
  static final _sockets = _Semaphore(96);

  /// OS error codes for a refused connection (Linux/Android, BSD/iOS,
  /// Windows WSA and Win32) — the host answered, the port is closed.
  static const _refusedCodes = {111, 61, 10061, 1225};

  /// OS error codes for a connect timeout (Linux/Android, BSD/iOS, Windows).
  static const _timeoutCodes = {110, 60, 10060};

  // ---------- public scan entry points ----------------------------------------

  /// Scans every address of [cidr] for IoT devices.
  ///
  /// Hostnames and MACs come from a `NetworkScanner.scan` ping sweep, but —
  /// as the original IoT scanner did — every address is TCP-probed, because
  /// many IoT devices ignore ping. Yields results as they are found.
  static Stream<IotDevice> scanSubnet(
    String cidr, {
    void Function(String line)? onSkipped,
  }) async* {
    if (!NetworkScanner.isValidCidr(cidr)) return;
    // The scan emits each host twice (before and after MAC enrichment); the
    // map keeps the latest, enriched emission.
    final discovered = <String, HostResult>{};
    await for (final host in NetworkScanner.scan(cidr)) {
      discovered[host.ip] = host;
    }
    yield* scanHosts(subnetTargets(cidr, discovered), onSkipped: onSkipped);
  }

  /// Every host address of [cidr]: the [discovered] (ping-answering) entry
  /// where there is one, otherwise a bare target marked `isUp: false`.
  @visibleForTesting
  static List<HostResult> subnetTargets(
    String cidr,
    Map<String, HostResult> discovered,
  ) => [
    for (final ip in NetworkScanner.hostsInCidr(cidr))
      discovered[ip] ?? HostResult(ip: ip, isUp: false),
  ];

  /// Probes [hosts] for IoT devices.
  ///
  /// Hosts with `isUp` (answered ping) get a full port probe with one retry
  /// of timed-out ports; other addresses must pass a short liveness gate
  /// first. [onSkipped] receives a one-line description — including the
  /// open/closed/timeout counts — of every reachable host that showed no IoT
  /// evidence, so the caller can log why a device was missed.
  static Stream<IotDevice> scanHosts(
    List<HostResult> hosts, {
    void Function(String line)? onSkipped,
  }) {
    final controller = StreamController<IotDevice>();
    if (hosts.isEmpty) {
      unawaited(controller.close());
      return controller.stream;
    }

    Future<void> run() async {
      // Restored from the original scanner: read the ARP table during the
      // IoT scan for hosts whose MAC the LAN scan did not resolve.
      final needsArp = hosts.any((h) => !_isMac(h.mac));
      final arp = needsArp
          ? await NetworkScanner.readArpTable(logEmpty: false)
          : const <String, String>{};

      final sem = _Semaphore(32);
      await Future.wait(
        hosts.map(
          (host) => sem.run(() async {
            try {
              final dev = await _probeHost(host, arp, onSkipped);
              if (dev != null) controller.add(dev);
            } on Exception catch (e) {
              onSkipped?.call('${host.ip}  probe error: $e');
            }
          }),
        ),
      );
      await controller.close();
    }

    unawaited(run());
    return controller.stream;
  }

  // ---------- per-host probe ---------------------------------------------------

  static Future<IotDevice?> _probeHost(
    HostResult host,
    Map<String, String> arp,
    void Function(String line)? onSkipped,
  ) async {
    final ip = host.ip;
    final ports = await scanPorts(
      ip,
      _iotPorts.keys.toList(),
      knownAlive: host.isUp,
    );
    final reachable = host.isUp || ports.hostResponded;
    final openPorts = ports.open;

    final mac = effectiveMac(host, arp);
    final vendor = mac == null
        ? ''
        : mac == host.mac.toUpperCase() && host.manufacturer.isNotEmpty
        ? host.manufacturer
        : OuiService.lookup(mac);

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
          mac: mac ?? 'N/A',
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
      mac: mac ?? '',
      vendor: vendor,
      openPorts: openPorts,
      httpProtocol: httpProtocol,
    );
    if (classification == null) {
      // An empty address of a subnet sweep is not worth a log line.
      if (reachable) {
        onSkipped?.call(
          '$ip  hostname="${host.hostname}"  mac=${mac ?? 'N/A'}  '
          'vendor="$vendor"  ${ports.summary}',
        );
      }
      return null;
    }

    return IotDevice(
      ip: ip,
      mac: mac ?? 'N/A',
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

  static final _macRe = RegExp(r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$');

  static bool _isMac(String mac) => _macRe.hasMatch(mac);

  /// The best-known MAC of [host], upper-cased: its own (from the LAN scan),
  /// else the ARP table read during the IoT scan, else a MAC published as its
  /// hostname. Null when no source knows it.
  @visibleForTesting
  static String? effectiveMac(HostResult host, Map<String, String> arp) {
    if (_isMac(host.mac)) return host.mac.toUpperCase();
    final fromArp = arp[host.ip];
    if (fromArp != null && _isMac(fromArp)) return fromArp.toUpperCase();
    return NetworkScanner.macFromHostname(host.hostname);
  }

  // ---------- port scan --------------------------------------------------------

  /// Probes [ports] on [ip] and reports open ports plus outcome counts.
  ///
  /// When [knownAlive] is false the `_gatePorts` are probed first with a
  /// short timeout; if none of them gets any reply the address is treated
  /// as empty and the rest is skipped. Ports that time out are retried once
  /// on a host that is alive or has replied on another port.
  @visibleForTesting
  static Future<PortScanResult> scanPorts(
    String ip,
    List<int> ports, {
    required bool knownAlive,
  }) async {
    final outcomes = <int, PortProbeOutcome>{};

    Future<void> probeAll(Iterable<int> list, Duration timeout) async {
      final results = await Future.wait(
        list.map((p) async => (p, await _probePort(ip, p, timeout))),
      );
      for (final (port, outcome) in results) {
        outcomes[port] = outcome;
      }
    }

    bool responded() => outcomes.values.any(
      (o) => o == PortProbeOutcome.open || o == PortProbeOutcome.closed,
    );

    if (!knownAlive) {
      await probeAll(_gatePorts.where(ports.contains), _gateTimeout);
      if (!responded()) return PortScanResult.from(outcomes);
    }
    await probeAll(ports.where((p) => !outcomes.containsKey(p)), _portTimeout);

    final timedOut = [
      for (final e in outcomes.entries)
        if (e.value == PortProbeOutcome.timeout) e.key,
    ];
    if (timedOut.isNotEmpty && (knownAlive || responded())) {
      await probeAll(timedOut, _portTimeout);
    }
    return PortScanResult.from(outcomes);
  }

  static Future<PortProbeOutcome> _probePort(
    String ip,
    int port,
    Duration timeout,
  ) => _sockets.run(() async {
    try {
      final sock = await Socket.connect(ip, port, timeout: timeout);
      sock.destroy();
      return PortProbeOutcome.open;
    } on SocketException catch (e) {
      return probeOutcome(e);
    }
  });

  /// Maps a connect failure to a probe outcome: refused → closed (the host
  /// answered), a timeout (Dart reports its own timeout without an OS error)
  /// → timeout, anything else (no route, network down) → unreachable.
  @visibleForTesting
  static PortProbeOutcome probeOutcome(SocketException e) {
    final code = e.osError?.errorCode;
    if (code == null || _timeoutCodes.contains(code)) {
      return PortProbeOutcome.timeout;
    }
    if (_refusedCodes.contains(code)) return PortProbeOutcome.closed;
    return PortProbeOutcome.unreachable;
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
    // Restored from the original scanner as a whole word only, so that
    // `chipset` or `chipotle` do not match.
    if (protocol.isEmpty && _chipWord.hasMatch(haystack)) {
      protocol = 'Matter/CHIP';
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
