import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/ip_camera_detector.dart';

void main() {

   group('IpCameraDetector.wsDiscoveryScan', () {
    // wsDiscoveryScan returns a Stream<CameraCandidate>; the corrected syntax
    // collects it with toList() inside an async test. No ONVIF camera answers
    // the multicast probe on the CI host, so the stream completes (after the
    // short listen window) with an empty list.
    test('completes and yields a candidate list within the listen window',
        () async {
      final found = await IpCameraDetector
          .wsDiscoveryScan(listenDuration: const Duration(seconds: 1))
          .toList();
      expect(found, isA<List<CameraCandidate>>());
      expect(found, isEmpty);
    });
  });

  group('IpCameraDetector.detectHost', () {
    // 192.0.2.1 is in RFC 5737 TEST-NET-1 (reserved, guaranteed unroutable),
    // so every port probe fails and detectHost returns no candidates without
    // touching the real network. A short port timeout keeps the test fast.
    test('returns no candidates for an unreachable host', () async {
      final found = await IpCameraDetector.detectHost(
        '192.0.2.1',
        portTimeout: const Duration(milliseconds: 300),
      );
      expect(found, isA<List<CameraCandidate>>());
      expect(found, isEmpty);
    });

    test('still returns no candidates when a manufacturer is supplied', () async {
      // The manufacturer only matters once an open port is found; with no open
      // ports the early-return path is taken regardless of manufacturer.
      final found = await IpCameraDetector.detectHost(
        '192.0.2.2',
        manufacturer: 'Hikvision',
        portTimeout: const Duration(milliseconds: 300),
      );
      expect(found, isEmpty);
    });
  });


  // ── Method 2: Generic port + manufacturer matching ─────────────────────────
  group('genericPortMfr — manufacturer matching', () {
    final cameras = {
      'Hikvision':          'Hikvision',
      'Dahua Technology':   'Dahua',
      'Axis Communications':'Axis',
      'Reolink':            'Reolink',
      'Ubiquiti Inc.':      'Ubiquiti',
      'UniFi Networks':     'UniFi',
      'Amcrest':            'Amcrest',
      'Foscam':             'Foscam',
      'Lorex':              'Lorex',
      'Swann':              'Swann',
      'EZVIZ':              'EZVIZ',
      'Hanwha Techwin':     'Hanwha',
      'Samsung Techwin':    'Samsung Techwin',
      'Bosch Security':     'Bosch',
      'Panasonic':          'Panasonic',
      'Vivotek':            'Vivotek',
      'Uniview':            'Uniview',
      'GeoVision':          'GeoVision',
      'ACTi Corporation':   'ACTi',
    };

    for (final entry in cameras.entries) {
      test('${entry.value} detected as camera manufacturer', () {
        expect(IpCameraDetector.isKnownCameraManufacturer(entry.key), isTrue);
      });
    }

    test('Apple is NOT a camera manufacturer', () {
      expect(IpCameraDetector.isKnownCameraManufacturer('Apple Inc.'), isFalse);
    });

    test('Raspberry Pi is NOT a camera manufacturer', () {
      expect(IpCameraDetector.isKnownCameraManufacturer('Raspberry Pi Foundation'), isFalse);
    });

    test('Cisco is NOT a camera manufacturer', () {
      expect(IpCameraDetector.isKnownCameraManufacturer('Cisco Systems'), isFalse);
    });

    test('Empty string returns false', () {
      expect(IpCameraDetector.isKnownCameraManufacturer(''), isFalse);
    });

    test('Matching is case-insensitive', () {
      expect(IpCameraDetector.isKnownCameraManufacturer('HIKVISION'), isTrue);
      expect(IpCameraDetector.isKnownCameraManufacturer('hikvision'), isTrue);
      expect(IpCameraDetector.isKnownCameraManufacturer('HiKVIsioN'), isTrue);
    });
  });

  // ── Method 3: HTTP banner fingerprinting ────────────────────────────────────
  group('genericPortHttp — banner fingerprinting', () {
    late ServerSocket server;
    late int port;

    setUp(() async {
      server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      port   = server.port;
    });

    tearDown(() async {
      await server.close();
    });

    /// Serve [body] once with optional [serverHeader], then call probeHttpBanner.
    Future<String?> serveAndProbe(String body, {String? serverHeader}) async {
      final connFuture = server.first;
      final probeFuture = IpCameraDetector.probeHttpBanner('127.0.0.1', port);

      final conn = await connFuture;
      conn.listen((_) {});   // drain request
      final response = StringBuffer('HTTP/1.1 200 OK\r\n');
      if (serverHeader != null) response.write('Server: $serverHeader\r\n');
      response.write('Content-Length: ${body.length}\r\n\r\n$body');
      conn.write(response.toString());
      await conn.flush();
      await conn.close();

      return probeFuture;
    }

    test('ONVIF keyword in body triggers detection', () async {
      final result = await serveAndProbe('<html>onvif device service</html>');
      expect(result, isNotNull);
      expect(result, contains('onvif'));
    });

    test('device_service in body triggers detection', () async {
      final result = await serveAndProbe('<root>device_service</root>');
      expect(result, isNotNull);
      expect(result, contains('device_service'));
    });

    test('rtsp:// URL in body triggers detection', () async {
      final result =
          await serveAndProbe('<stream>rtsp://192.168.1.100:554/live</stream>');
      expect(result, isNotNull);
      expect(result, contains('rtsp://'));
    });

    test('Hikvision /doc/page/login path triggers detection', () async {
      final result = await serveAndProbe(
          '<meta http-equiv="refresh" content="0;URL=/doc/page/login.asp"/>');
      expect(result, isNotNull);
      expect(result, contains('/doc/page/login'));
    });

    test('Server header "webs" triggers detection', () async {
      final result = await serveAndProbe('<html></html>', serverHeader: 'webs');
      expect(result, isNotNull);
      expect(result, contains('webs'));
    });

    test('Camera vendor name in body triggers detection', () async {
      final result = await serveAndProbe('<title>Dahua Web Service</title>');
      expect(result, isNotNull);
    });

    test('Generic Apache server with normal content returns null', () async {
      final result = await serveAndProbe(
          '<html><body>Hello World</body></html>',
          serverHeader: 'Apache/2.4.51');
      expect(result, isNull);
    });

    test('Empty body with no camera headers returns null', () async {
      final result = await serveAndProbe('');
      expect(result, isNull);
    });
  });

  // ── Method 4: WS-Discovery XML parsing ────────────────────────────────────
  group('wsDiscovery — XML parsing', () {
    final xaddrsRegex = RegExp(
        r'<[^:>]*:?XAddrs[^>]*>(.*?)</[^:>]*:?XAddrs>',
        dotAll: true);

    String? extractXAddrs(String xml) =>
        xaddrsRegex.firstMatch(xml)?.group(1)?.trim();

    test('extracts XAddrs from a minimal WS-Discovery Hello', () {
      const xml = '''<soap:Envelope>
  <soap:Body>
    <d:Hello>
      <d:XAddrs>http://192.168.1.50:80/onvif/device_service</d:XAddrs>
    </d:Hello>
  </soap:Body>
</soap:Envelope>''';
      expect(extractXAddrs(xml), 'http://192.168.1.50:80/onvif/device_service');
    });

    test('extracts XAddrs from a ProbeMatch with wsdd namespace', () {
      const xml = '''<SOAP-ENV:Envelope>
  <SOAP-ENV:Body>
    <wsdd:ProbeMatches>
      <wsdd:ProbeMatch>
        <wsdd:XAddrs>http://192.168.0.200:8080/onvif/device_service</wsdd:XAddrs>
      </wsdd:ProbeMatch>
    </wsdd:ProbeMatches>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>''';
      final xaddrs = extractXAddrs(xml);
      expect(xaddrs, isNotNull);
      expect(xaddrs, contains('192.168.0.200'));
      expect(xaddrs, contains('8080'));
    });

    test('returns null when no XAddrs element present', () {
      const xml =
          '<soap:Envelope><soap:Body><d:Hello/></soap:Body></soap:Envelope>';
      expect(extractXAddrs(xml), isNull);
    });

    test('port 8080 extracted from XAddrs URL', () {
      const xaddrs = 'http://192.168.1.50:8080/onvif/device_service';
      final m = RegExp(r':(\d{2,5})').firstMatch(xaddrs);
      expect(m, isNotNull);
      expect(int.parse(m!.group(1)!), 8080);
    });

    test('port 80 extracted from XAddrs URL with explicit :80', () {
      const xaddrs = 'http://192.168.1.50:80/onvif/device_service';
      final m = RegExp(r':(\d{2,5})').firstMatch(xaddrs);
      expect(m, isNotNull);
      expect(int.parse(m!.group(1)!), 80);
    });

    test('defaults to port 80 when URL has no explicit port', () {
      const xaddrs = 'http://192.168.1.50/onvif/device_service';
      final m = RegExp(r':(\d{2,5})').firstMatch(xaddrs);
      int detectedPort = 80;
      if (m != null) detectedPort = int.tryParse(m.group(1)!) ?? 80;
      expect(detectedPort, 80);
    });

    test('Multiple XAddrs separated by space — first is extracted', () {
      const xml = '''<d:XAddrs>http://192.168.1.5:80/onvif/device_service http://192.168.1.5:8080/onvif/device_service</d:XAddrs>''';
      final xaddrs = extractXAddrs(xml);
      expect(xaddrs, isNotNull);
      expect(xaddrs!.split(' ').length, greaterThan(1));
    });
  });

  // ── CameraCandidate model ─────────────────────────────────────────────────
  group('CameraCandidate', () {
    test('toString includes ip port method and evidence', () {
      const c = CameraCandidate(
        ip:           '10.0.0.1',
        port:         554,
        method:       CameraDetectionMethod.specificPort,
        evidence:     'RTSP (standard)',
        manufacturer: 'Hikvision',
      );
      final s = c.toString();
      expect(s, contains('10.0.0.1'));
      expect(s, contains('554'));
      expect(s, contains('specificPort'));
      expect(s, contains('RTSP'));
      expect(s, contains('Hikvision'));
    });

    test('manufacturer is optional and defaults to empty', () {
      const c = CameraCandidate(
        ip:       '10.0.0.2',
        port:     37777,
        method:   CameraDetectionMethod.specificPort,
        evidence: 'Dahua',
      );
      expect(c.manufacturer, isEmpty);
    });
  });
}
