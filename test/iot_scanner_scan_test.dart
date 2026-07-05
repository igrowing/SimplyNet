import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/iot_scanner.dart';

void main() {
  group('IotScanner.scanHosts', () {
    test('empty IP list completes immediately with no devices', () async {
      final devices = await IotScanner.scanHosts([]).toList();
      expect(devices, isEmpty);
    });

    test('probes a live host end-to-end and fingerprints it over HTTP',
        () async {
      // Stand up a real loopback HTTP server on an IoT port (8080) that answers
      // like a Tasmota device, so scanHosts drives the full per-host pipeline:
      // TCP port scan → ARP lookup → HTTP probe → fingerprint classification.
      HttpServer? server;
      try {
        server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
      } on SocketException {
        return; // Port 8080 already in use on this host — skip silently.
      }
      server.listen((req) {
        req.response.headers.set('server', 'Tasmota/13.0');
        req.response.headers.set('x-firmware', 'tasmota-13.0');
        req.response
            .write('<html><title>Sonoff Basic</title><body>ok</body></html>');
        req.response.close();
      });

      try {
        final devices = await IotScanner.scanHosts(['127.0.0.1']).toList();
        expect(devices, hasLength(1));
        final d = devices.single;
        expect(d.ip, '127.0.0.1');
        expect(d.protocol, 'Tasmota');
        expect(d.model, 'Sonoff Basic');
        expect(d.detectionMethod, contains('HTTP'));
        expect(d.confidence, IotConfidence.definite);
        expect(d.openPorts, contains(8080));
      } finally {
        await server.close(force: true);
      }
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('IotScanner.scanSubnet', () {
    test('normal CIDR', () async {
      final devices = await IotScanner.scanSubnet('192.168.1.0/30').toList();
      expect(devices, isList);
      expect(devices.length, 0);
    });

    test('malformed CIDR (no prefix) yields no devices and completes', () async {
      final devices = await IotScanner.scanSubnet('192.168.1.0').toList();
      expect(devices, isEmpty);
    });

    test('garbage input yields no devices and completes', () async {
      final devices = await IotScanner.scanSubnet('not-a-cidr').toList();
      expect(devices, isEmpty);
    });
  });

  group('IotDevice model', () {
    IotDevice make({Map<String, String>? extra}) => IotDevice(
          ip: '192.168.1.10',
          mac: 'AA:BB:CC:DD:EE:FF',
          vendor: 'Espressif',
          protocol: 'Tasmota',
          model: 'Sonoff',
          openPorts: const [80, 1883],
          confidence: IotConfidence.definite,
          detectionMethod: 'HTTP/Tasmota',
          extra: extra ?? const {},
        );

    test('toString contains ip, protocol, vendor and method', () {
      final s = make().toString();
      expect(s, contains('192.168.1.10'));
      expect(s, contains('Tasmota'));
      expect(s, contains('Espressif'));
      expect(s, contains('HTTP/Tasmota'));
      expect(s, contains('definite'));
    });

    test('extra defaults to an empty map', () {
      expect(make().extra, isEmpty);
    });

    test('confidence enum exposes three levels', () {
      expect(IotConfidence.values,
          [IotConfidence.definite, IotConfidence.probable, IotConfidence.possible]);
    });
  });
}
