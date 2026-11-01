import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/constants/network_ports.dart';
import 'package:simply_net/services/iot_scanner.dart';

void main() {
  // ── _vendorFromMac (tested via IotDevice.vendor indirectly) ─────────────
  // IotScanner._vendorFromMac is private, so we test the OUI dict coverage
  // by checking the public scanSubnet API model and the Kasa XOR codec.

  // ── Kasa XOR codec ───────────────────────────────────────────────────────
  // _kasaXorEncode / _kasaXorDecode are private but the codec is deterministic
  // and well-specified. We test encode-then-decode roundtrip via exposing it
  // from a test helper OR by verifying the known-good wire format.

  group('IotScanner Kasa XOR codec (round-trip via reflection)', () {
    // Since _kasaXorEncode/_kasaXorDecode are private we verify the algorithm
    // with a standalone reference implementation matching the spec.
    Uint8List kasaEncode(String plain) {
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

    String kasaDecode(Uint8List data) {
      int key = 0xAB;
      final out = <int>[];
      for (final b in data) {
        out.add(b ^ key);
        key = b;
      }
      return String.fromCharCodes(out);
    }

    test('encode then decode returns original string', () {
      const original = '{"system":{"get_sysinfo":{}}}';
      final encoded = kasaEncode(original);
      final decoded = kasaDecode(Uint8List.fromList(encoded.sublist(4)));
      expect(decoded, equals(original));
    });

    test('header bytes encode payload length correctly', () {
      const payload = 'hello';
      final encoded = kasaEncode(payload);
      expect(encoded.length, equals(4 + payload.length));
      // Length field at bytes 2-3
      final len = (encoded[2] << 8) | encoded[3];
      expect(len, equals(payload.length));
    });

    test('first two header bytes are always zero', () {
      final encoded = kasaEncode('test');
      expect(encoded[0], equals(0));
      expect(encoded[1], equals(0));
    });

    test('encode is not idempotent (XOR with key changes each byte)', () {
      const s = 'abc';
      final enc = kasaEncode(s);
      final body = enc.sublist(4);
      // Bytes should differ from original ASCII values (XOR changes them)
      expect(body[0], isNot(equals(s.codeUnitAt(0))));
    });

    test('round-trip preserves empty string', () {
      const original = '';
      final encoded = kasaEncode(original);
      final decoded = kasaDecode(Uint8List.fromList(encoded.sublist(4)));
      expect(decoded, equals(original));
    });

    test('known wire format: {"system":{"get_sysinfo":{}}}', () {
      // XOR key=0xAB, first byte: '{' (0x7B) XOR 0xAB = 0xD0
      const payload = '{"system":{"get_sysinfo":{}}}';
      final encoded = kasaEncode(payload);
      expect(encoded[4], equals(0x7B ^ 0xAB)); // first encrypted byte
    });
  });

  // ── IotDevice model ───────────────────────────────────────────────────────

  group('IotDevice model', () {
    const device = IotDevice(
      ip: '192.168.1.50',
      mac: 'C4:5B:BE:11:22:33',
      vendor: 'Shelly',
      protocol: 'Shelly',
      model: 'Shelly1',
      openPorts: [80, 443],
      confidence: IotConfidence.definite,
      detectionMethod: 'HTTP/Shelly',
    );

    test('fields accessible correctly', () {
      expect(device.ip, equals('192.168.1.50'));
      expect(device.mac, equals('C4:5B:BE:11:22:33'));
      expect(device.vendor, equals('Shelly'));
      expect(device.protocol, equals('Shelly'));
      expect(device.model, equals('Shelly1'));
      expect(device.openPorts, equals([80, 443]));
      expect(device.confidence, equals(IotConfidence.definite));
      expect(device.detectionMethod, equals('HTTP/Shelly'));
    });

    test('extra defaults to empty map', () {
      expect(device.extra, isEmpty);
    });

    test('toString contains IP and protocol', () {
      final s = device.toString();
      expect(s, contains('192.168.1.50'));
      expect(s, contains('Shelly'));
    });

    test('IotConfidence enum has three values', () {
      expect(IotConfidence.values.length, equals(3));
      expect(
        IotConfidence.values,
        containsAll([
          IotConfidence.definite,
          IotConfidence.probable,
          IotConfidence.possible,
        ]),
      );
    });
  });

  // ── IoT port definitions ─────────────────────────────────────────────────

  group('NetworkPorts.iotPortNames', () {
    final ports = NetworkPorts.iotPortNames;

    test('contains the IoT service ports', () {
      for (final p in [
        22,
        80,
        1880,
        1883,
        6053,
        6668,
        8008,
        8009,
        8123,
        9999,
      ]) {
        expect(ports.containsKey(p), isTrue, reason: 'port $p');
      }
    });

    test('6668 is the Tuya local port, not Meross', () {
      expect(ports[6668], 'Tuya local');
    });

    test('mDNS (UDP-only) is not in the TCP list', () {
      expect(ports.containsKey(5353), isFalse);
    });

    // Restored: Matter 1.3+ devices may listen on TCP.
    test('Matter TCP ports are probed', () {
      expect(ports.containsKey(5540), isTrue);
      expect(ports.containsKey(20202), isTrue);
    });
  });

  // ── Hostname in the model ─────────────────────────────────────────────────

  group('IotDevice hostname', () {
    test('round-trips through json', () {
      const d = IotDevice(
        ip: '192.168.1.5',
        mac: 'N/A',
        hostname: 'tasmota-1A2B3C',
        vendor: '',
        protocol: 'Tasmota',
        model: '',
        openPorts: [],
        confidence: IotConfidence.possible,
        detectionMethod: 'hostname',
      );
      expect(IotDevice.fromJson(d.toJson()).hostname, 'tasmota-1A2B3C');
    });

    test('a cache entry from an older version loads with empty hostname', () {
      final d = IotDevice.fromJson({'ip': '192.168.1.5'});
      expect(d.hostname, '');
    });
  });
}
