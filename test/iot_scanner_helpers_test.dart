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
      final decoded =
          IotScanner.kasaXorDecode(Uint8List.fromList(encoded.sublist(4)));
      expect(decoded, plain);
    });

    test('round-trips arbitrary ASCII payloads', () {
      for (final s in ['', 'x', 'hello world', '0123456789']) {
        final enc = IotScanner.kasaXorEncode(s);
        expect(IotScanner.kasaXorDecode(Uint8List.fromList(enc.sublist(4))), s);
      }
    });
  });

  group('IotScanner.vendorFromMac', () {
    test('resolves a known Espressif OUI prefix', () {
      expect(IotScanner.vendorFromMac('18:FE:34:AA:BB:CC'), 'Espressif');
    });

    test('is case-insensitive', () {
      expect(IotScanner.vendorFromMac('18:fe:34:aa:bb:cc'), 'Espressif');
    });

    test('returns Unknown for N/A or too-short MACs', () {
      expect(IotScanner.vendorFromMac('N/A'), 'Unknown');
      expect(IotScanner.vendorFromMac('AA:BB'), 'Unknown');
    });

    test('returns empty string for an unmatched prefix', () {
      expect(IotScanner.vendorFromMac('02:00:00:11:22:33'), '');
    });
  });

  group('IotScanner.classifyHttp', () {
    test('returns null when nothing matches', () {
      expect(
        IotScanner.classifyHttp(server: 'nginx', xFirmware: '', body: '<html/>'),
        isNull,
      );
    });

    test('matches a fingerprint in the Server header', () {
      final r = IotScanner.classifyHttp(
          server: 'Tasmota/12.0', xFirmware: '', body: '');
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
}
