import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// ════════════════════════════════════════════════════════════════════════════
// IP Camera Detection Model
//
// Detection uses four independent signals, applied in priority order:
//
//  1. SPECIFIC ports   — RTSP, RTMP, Dahua/Reolink, XMEye.
//     Any open port from these lists is definitive proof of a camera protocol.
//
//  2. GENERIC ports + MANUFACTURER name from ARP/OUI lookup.
//     Web-interface ports (80, 443, 8080, 8443, 81-85, 8000) are opened by
//     many devices. Only flagged when the OUI-resolved manufacturer matches a
//     known camera vendor list.
//
//  3. GENERIC ports + HTTP banner probe.
//     When a generic port is open but the manufacturer is unknown, fetch the
//     HTTP response and grep headers/body for ONVIF or camera fingerprints.
//
//  4. WS-Discovery (UDP multicast 239.255.255.250:3702).
//     Send a WS-Discovery Probe; listen for Hello / ProbeMatch responses.
//     Responses include <d:XAddrs> with service URLs that reveal the device.
// ════════════════════════════════════════════════════════════════════════════

/// Result of an IP camera detection attempt for a single host.
class CameraCandidate {
  final String ip;
  final int port;
  final CameraDetectionMethod method;
  final String evidence; // human-readable reason
  final String manufacturer;

  const CameraCandidate({
    required this.ip,
    required this.port,
    required this.method,
    required this.evidence,
    this.manufacturer = '',
  });

  @override
  String toString() =>
      'CAMERA [$method] $ip:$port — $evidence'
      '${manufacturer.isNotEmpty ? " ($manufacturer)" : ""}';
}

enum CameraDetectionMethod {
  specificPort,      // definitive camera protocol port
  genericPortMfr,   // generic port + camera manufacturer match
  genericPortHttp,  // generic port + HTTP ONVIF/camera header fingerprint
  wsDiscovery,      // WS-Discovery multicast response
}

class IpCameraDetector {
  // ── Port groups ────────────────────────────────────────────────────────────

  /// Ports that are unambiguously camera protocols — any open port = camera.
  static const specificPorts = [
    554,   // RTSP (standard)
    5554,  // RTSP (alt)
    8554,  // RTSP (alt)
    10554, // RTSP (alt)
    37777, // Dahua / Reolink proprietary
    37778, // Dahua / Reolink proprietary
    1935,  // RTMP streaming
    34567, // XMEye / Generic DVR
    34599, // XMEye / Generic DVR
  ];

  /// Ports that host web interfaces on many device types.
  /// Require extra evidence (manufacturer name or HTTP banner).
  static const genericPorts = [80, 443, 8080, 8443, 8000, 9000, 9001, 81, 82, 83, 84, 85];

  /// All ports to probe per host during a scan.
  static const allPorts = [...specificPorts, ...genericPorts];

  // ── Known camera manufacturer substrings (case-insensitive OUI match) ─────
  static const _cameraManufacturers = [
    'hikvision',
    'dahua',
    'axis',
    'reolink',
    'ubiquiti',
    'unifi',
    'amcrest',
    'foscam',
    'lorex',
    'swann',
    'ezviz',
    'hanwha',
    'samsung techwin',
    'bosch',
    'panasonic',
    'vivotek',
    'uniview',
    'geovision',
    'acti',
  ];

  /// Returns true when [manufacturer] (from OUI lookup) matches a known camera vendor.
  static bool isKnownCameraManufacturer(String manufacturer) {
    if (manufacturer.isEmpty) return false;
    final lower = manufacturer.toLowerCase();
    return _cameraManufacturers.any((m) => lower.contains(m));
  }

  // ── HTTP banner fingerprinting ─────────────────────────────────────────────

  /// Fingerprint keywords found in HTTP response headers or body.
  static const _httpCameraFingerprints = [
    'onvif',
    'device_service',
    'rtsp://',
    'ipcamera',
    'ip camera',
    'ip-camera',
    'dvr',
    'nvr',
    'hikvision',
    'dahua',
    'foscam',
    'reolink',
    'amcrest',
    'vivotek',
    'axis',
    'uniview',
    'ezviz',
    'hanwha',
    '/doc/page/login',    // Hikvision login page path
    'webs',               // Many DVR web servers identify as "webs"
    'cross_domain',       // Common in IP camera AJAX responses
  ];

  /// Probe a single HTTP/HTTPS port on [ip].
  /// Returns a fingerprint string if a camera signature is found, else null.
  /// Pure function — no I/O side effects beyond the socket.
  static Future<String?> probeHttpBanner(String ip, int port) async {
    final isHttps = port == 443 || port == 8443;
    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 3)
        ..badCertificateCallback = (_, __, ___) => true; // accept self-signed
      final uri  = Uri.parse('${isHttps ? "https" : "http"}://$ip:$port/');
      final req  = await client.getUrl(uri);
      req.headers.set('User-Agent', 'SimplyNet/1.0');
      final resp = await req.close().timeout(const Duration(seconds: 4));
      final body = await resp
          .transform(const Utf8Decoder(allowMalformed: true))
          .join()
          .timeout(const Duration(seconds: 3));
      client.close(force: true);

      // Build a combined searchable string from headers + body (lowercased)
      final headerBuf = StringBuffer();
      resp.headers.forEach((name, values) {
        headerBuf.write('$name: ${values.join(",")} ');
      });
      final combined = '${headerBuf.toString()} $body'.toLowerCase();

      for (final fp in _httpCameraFingerprints) {
        if (combined.contains(fp)) return fp;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── WS-Discovery ───────────────────────────────────────────────────────────

  static const _wsDiscoveryAddr = '239.255.255.250';
  static const _wsDiscoveryPort = 3702;

  /// WS-Discovery Probe message (SOAP envelope, device type any).
  /// Exposed for unit tests — do not use in production UI.
  static String get wsProbeXmlForTest => _wsProbeXml;

  static String get _wsProbeXml => '''<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope
  xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
  xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"
  xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery">
  <soap:Header>
    <wsa:Action>http://schemas.xmlsoap.org/ws/2005/04/discovery/Probe</wsa:Action>
    <wsa:MessageID>uuid:${DateTime.now().millisecondsSinceEpoch}</wsa:MessageID>
    <wsa:To>urn:schemas-xmlsoap-org:ws:2005:04:discovery</wsa:To>
  </soap:Header>
  <soap:Body><d:Probe><d:Types/></d:Probe></soap:Body>
</soap:Envelope>''';

  /// Send a WS-Discovery probe and collect responses for [listenDuration].
  /// Yields [CameraCandidate] for each responding device that includes
  /// a service URL (<d:XAddrs>) in its response.
  static Stream<CameraCandidate> wsDiscoveryScan({
    Duration listenDuration = const Duration(seconds: 4),
  }) async* {
    RawDatagramSocket? sock;
    try {
      sock = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4, 0,
        reuseAddress: true,
      );
      sock.multicastHops    = 4;
      sock.broadcastEnabled = true;

      // Send the probe
      final probe    = Uint8List.fromList(utf8.encode(_wsProbeXml));
      final multicast = InternetAddress(_wsDiscoveryAddr);
      sock.send(probe, multicast, _wsDiscoveryPort);

      final seen = <String>{};
      final deadline = DateTime.now().add(listenDuration);

      await for (final event in sock.timeout(listenDuration)) {
        if (DateTime.now().isAfter(deadline)) break;
        if (event != RawSocketEvent.read) continue;
        final dg = sock.receive();
        if (dg == null) continue;

        final body = utf8.decode(dg.data, allowMalformed: true);
        // Extract XAddrs (service URLs) — simple regex, no XML parser dep
        final xaddrsMatch =
            RegExp(r'<[^:>]*:?XAddrs[^>]*>(.*?)</[^:>]*:?XAddrs>',
                    dotAll: true)
                .firstMatch(body);
        if (xaddrsMatch == null) continue;

        final xaddrs    = xaddrsMatch.group(1)?.trim() ?? '';
        final senderIp  = dg.address.address;

        // Deduplicate by sender IP
        if (!seen.add(senderIp)) continue;

        // Parse a port from the first XAddr URL if present
        int port = 80;
        final portMatch = RegExp(r':(\d{2,5})').firstMatch(xaddrs);
        if (portMatch != null) port = int.tryParse(portMatch.group(1)!) ?? 80;

        yield CameraCandidate(
          ip:       senderIp,
          port:     port,
          method:   CameraDetectionMethod.wsDiscovery,
          evidence: 'WS-Discovery XAddrs: $xaddrs',
        );
      }
    } catch (_) {
      // Multicast not available on all platforms — fail silently.
    } finally {
      sock?.close();
    }
  }

  // ── Per-host detection ────────────────────────────────────────────────────

  /// Run all four detection methods for a single [ip].
  /// [manufacturer] should be the OUI-resolved name (may be empty).
  /// Returns a list of candidates (may be empty if no camera evidence found).
  static Future<List<CameraCandidate>> detectHost(
    String ip, {
    String manufacturer = '',
    Duration portTimeout = const Duration(milliseconds: 800),
  }) async {
    final results = <CameraCandidate>[];

    // Probe all ports concurrently
    final portFutures = allPorts.map((port) async {
      try {
        final sock = await Socket.connect(ip, port, timeout: portTimeout);
        sock.destroy();
        return port; // open
      } catch (_) {
        return null; // closed / filtered
      }
    });
    final probeResults  = await Future.wait(portFutures);
    final openPorts     = probeResults.whereType<int>().toSet();

    if (openPorts.isEmpty) return results;

    for (final port in openPorts) {
      // ── Method 1: Specific port ──────────────────────────────────────────
      if (specificPorts.contains(port)) {
        results.add(CameraCandidate(
          ip:           ip,
          port:         port,
          method:       CameraDetectionMethod.specificPort,
          evidence:     _specificPortEvidence(port),
          manufacturer: manufacturer,
        ));
        continue; // no further checks needed for this port
      }

      // ── Method 2: Generic port + manufacturer ────────────────────────────
      if (genericPorts.contains(port) && isKnownCameraManufacturer(manufacturer)) {
        results.add(CameraCandidate(
          ip:           ip,
          port:         port,
          method:       CameraDetectionMethod.genericPortMfr,
          evidence:     'Known camera manufacturer on web port $port',
          manufacturer: manufacturer,
        ));
        continue;
      }

      // ── Method 3: Generic port + HTTP banner ─────────────────────────────
      if (genericPorts.contains(port)) {
        final fingerprint = await probeHttpBanner(ip, port);
        if (fingerprint != null) {
          results.add(CameraCandidate(
            ip:           ip,
            port:         port,
            method:       CameraDetectionMethod.genericPortHttp,
            evidence:     'HTTP banner contains "$fingerprint"',
            manufacturer: manufacturer,
          ));
        }
      }
    }

    return results;
  }

  static String _specificPortEvidence(int port) => switch (port) {
        554   => 'RTSP (standard)',
        5554  => 'RTSP (alternate)',
        8554  => 'RTSP (alternate)',
        10554 => 'RTSP (alternate)',
        37777 => 'Dahua/Reolink proprietary',
        37778 => 'Dahua/Reolink proprietary',
        9000  => 'Dahua/Reolink alternate',
        9001  => 'Dahua/Reolink alternate',
        1935  => 'RTMP streaming',
        34567 => 'XMEye/DVR proprietary',
        34599 => 'XMEye/DVR proprietary',
        8000  => 'Hikvision SDK port',
        _     => 'Camera-specific port',
      };

  // ── Full subnet scan ──────────────────────────────────────────────────────

  /// Scan an entire CIDR subnet and yield [CameraCandidate] for each detection.
  /// Also runs WS-Discovery in parallel and merges results (deduplicating by IP).
  static Stream<CameraCandidate> scanSubnet(
    String cidr, {
    Map<String, String> arpTable = const {},  // ip → manufacturer (from OUI)
    Duration portTimeout = const Duration(milliseconds: 800),
    Duration wsDiscoveryDuration = const Duration(seconds: 4),
    int parallelism = 24,
    void Function(int done, int total)? onProgress,
  }) async* {
    // Expand CIDR
    final hosts = _expandCidr(cidr);
    if (hosts == null) {
      yield* const Stream.empty();
      return;
    }

    // Seen IPs — deduplicate WS-Discovery vs port-scan results
    final seenIps = <String>{};

    // Run WS-Discovery in parallel with port scanning
    // Temporarily disabled, required refinement of the method.
    // final wsFuture  = wsDiscoveryScan(listenDuration: wsDiscoveryDuration)
    //     .toList()
    //     .catchError((_) => <CameraCandidate>[]);

    int done = 0;
    for (var i = 0; i < hosts.length; i += parallelism) {
      final batch = hosts.sublist(i, (i + parallelism).clamp(0, hosts.length));
      final futures = batch.map((ip) => detectHost(
        ip,
        manufacturer: arpTable[ip] ?? '',
        portTimeout:  portTimeout,
      ));
      final batchResults = await Future.wait(futures);
      for (final candidates in batchResults) {
        for (final c in candidates) {
          if (seenIps.add(c.ip)) yield c;
        }
      }
      done += batch.length;
      onProgress?.call(done, hosts.length);
    }

    // // Emit any WS-Discovery results that weren't already found by port scan
    // Temporarily disabled, required refinement of the method.
    // final ws = await wsFuture;
    // for (final c in ws) {
    //   if (seenIps.add(c.ip)) yield c;
    // }
  }

  /// Expand a CIDR string to a list of host IP strings.
  /// Returns null if the CIDR is invalid.
  static List<String>? _expandCidr(String cidr) {
    final parts = cidr.trim().split('/');
    if (parts.length != 2) return null;
    final ipParts = parts[0].split('.').map(int.tryParse).toList();
    if (ipParts.length != 4 || ipParts.any((o) => o == null)) return null;
    final prefix = int.tryParse(parts[1]);
    if (prefix == null || prefix < 1 || prefix > 30) return null;
    final base      = (ipParts[0]! << 24) | (ipParts[1]! << 16) |
                      (ipParts[2]! << 8)  |  ipParts[3]!;
    final mask      = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net       = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);
    return [
      for (var i = net + 1; i < broadcast; i++)
        '${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}'
    ];
  }
}
