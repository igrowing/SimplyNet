import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/iot_scanner.dart';

void main() {
  group('IotScanner Kasa XOR codec', () {
    test('encode produces a 4-byte length header + autokey ciphertext', () {
      final out = IotScanner.kasaXorEncode('AB');
      expect(out.length, 6); // 4 header + 2 payload
      expect(out[0], 0);
      expect(out[1], 0);
      expect(out[2], 0); // high byte of length 2
      expect(out[3], 2); // low byte of length 2
      // autokey: first key 0xAB, 'A'=0x41 -> 0x41^0xAB = 0xEA
      expect(out[4], 0x41 ^ 0xAB);
      expect(out[5], 0x42 ^ 0xEA); // next key is previous cipher byte
    });

    test('decode reverses encode (round-trip)', () {
      const plain = '{"system":{"get_sysinfo":{}}}';
      final encoded = IotScanner.kasaXorEncode(plain);
      // Drop the 4-byte length header before decoding (as the probe does).
      final decoded = IotScanner.kasaXorDecode(
        Uint8List.fromList(encoded.sublist(4)),
      );
      expect(decoded, plain);
    });

    test('round-trips arbitrary ASCII payloads', () {
      for (final s in ['', 'x', 'hello world', '0123456789']) {
        final enc = IotScanner.kasaXorEncode(s);
        expect(IotScanner.kasaXorDecode(Uint8List.fromList(enc.sublist(4))), s);
      }
    });
  });

  group('IotScanner.classifyHttp', () {
    test('returns null when nothing matches', () {
      expect(
        IotScanner.classifyHttp(
          server: 'nginx',
          xFirmware: '',
          body: '<html/>',
        ),
        isNull,
      );
    });

    test('matches a fingerprint in the Server header', () {
      final r = IotScanner.classifyHttp(
        server: 'Tasmota/12.0',
        xFirmware: '',
        body: '',
      );
      expect(r, isNotNull);
      expect(r!.$1, 'Tasmota');
      expect(r.$3['server'], 'Tasmota/12.0');
    });

    test('extracts Tasmota model from <title>', () {
      final r = IotScanner.classifyHttp(
        server: 'Tasmota',
        xFirmware: '',
        body: '<html><title>Sonoff Basic</title></html>',
      );
      expect(r!.$2, 'Sonoff Basic');
    });

    test('extracts ESPHome device name from JSON body', () {
      final r = IotScanner.classifyHttp(
        server: '',
        xFirmware: '',
        body: 'esphome {"name": "living-room-sensor"}',
      );
      expect(r!.$1, 'ESPHome');
      expect(r.$2, 'living-room-sensor');
    });

    test('builds Home Assistant model from version header', () {
      final r = IotScanner.classifyHttp(
        server: 'Home Assistant/2024.1',
        xFirmware: '',
        body: '',
        haVersion: '2024.1.0',
      );
      expect(r!.$1, 'Home Assistant');
      expect(r.$2, 'HA 2024.1.0');
    });

    test('captures firmware header in extras', () {
      final r = IotScanner.classifyHttp(
        server: 'Tasmota',
        xFirmware: 'Shelly-1.9',
        body: '',
      );
      expect(r!.$3['firmware'], 'Shelly-1.9');
    });
  });

  group('IotScanner.classifyHttp — extra firmware', () {
    for (final (needle, protocol) in [
      ('OpenBeken', 'OpenBeken'),
      ('WLED', 'WLED'),
      ('OctoPrint', 'OctoPrint'),
      ('motionEye', 'motionEye'),
      ('Homebridge', 'Homebridge'),
      ('SLZB-06', 'Zigbee hub'),
      ('Pi-hole', 'Pi-hole'),
      ('Homey', 'Homey'),
      ('Hubitat', 'Hubitat'),
      ('Aqara', 'Aqara'),
    ]) {
      test('$needle in the body → $protocol', () {
        final r = IotScanner.classifyHttp(
          server: '',
          xFirmware: '',
          body: '<title>$needle</title>',
        );
        expect(r?.$1, protocol);
      });
    }

    test('the loose "chip" keyword no longer matches', () {
      expect(
        IotScanner.classifyHttp(
          server: '',
          xFirmware: '',
          body: 'Welcome to chipotle-fan-club',
        ),
        isNull,
      );
    });
  });
}
