import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/lan_detector.dart';

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // inferPrefixFromAddress
  // ──────────────────────────────────────────────────────────────────────────
  group('inferPrefixFromAddress', () {
    test('192.168.x.x returns /24', () {
      expect(inferPrefixFromAddress('192.168.1.1'),   equals(24));
      expect(inferPrefixFromAddress('192.168.0.1'),   equals(24));
      expect(inferPrefixFromAddress('192.168.255.254'), equals(24));
    });

    test('10.x.x.x returns /24', () {
      expect(inferPrefixFromAddress('10.0.0.1'),     equals(24));
      expect(inferPrefixFromAddress('10.10.50.200'), equals(24));
    });

    test('172.x.x.x returns /24', () {
      expect(inferPrefixFromAddress('172.16.0.1'),   equals(24));
      expect(inferPrefixFromAddress('172.31.255.1'), equals(24));
    });

    test('public IP falls back to /24', () {
      expect(inferPrefixFromAddress('8.8.8.8'), equals(24));
      expect(inferPrefixFromAddress('1.2.3.4'), equals(24));
    });

    test('wrong octet count falls back to /24', () {
      expect(inferPrefixFromAddress('192.168.1'),  equals(24));
      expect(inferPrefixFromAddress('192.168'),    equals(24));
      expect(inferPrefixFromAddress(''),           equals(24));
    });

    test('non-numeric octet falls back to /24', () {
      expect(inferPrefixFromAddress('abc.168.1.1'), equals(24));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // networkAddress
  // ──────────────────────────────────────────────────────────────────────────
  group('networkAddress', () {
    test('/24 zeroes last octet', () {
      expect(networkAddress('192.168.1.100', 24), equals('192.168.1.0'));
      expect(networkAddress('192.168.1.255', 24), equals('192.168.1.0'));
      expect(networkAddress('192.168.1.1',   24), equals('192.168.1.0'));
    });

    test('/16 zeroes last two octets', () {
      expect(networkAddress('10.0.5.42',   16), equals('10.0.0.0'));
      expect(networkAddress('172.16.3.1',  16), equals('172.16.0.0'));
    });

    test('/8 zeroes last three octets', () {
      expect(networkAddress('10.20.30.40', 8), equals('10.0.0.0'));
    });

    test('/32 host route returns same IP', () {
      expect(networkAddress('192.168.1.50', 32), equals('192.168.1.50'));
    });

    test('/0 default route returns 0.0.0.0', () {
      expect(networkAddress('192.168.1.1', 0), equals('0.0.0.0'));
    });

    test('/25 splits last octet at midpoint', () {
      expect(networkAddress('192.168.1.200', 25), equals('192.168.1.128'));
      expect(networkAddress('192.168.1.127', 25), equals('192.168.1.0'));
    });

    test('prefix > 32 returns ip unchanged', () {
      expect(networkAddress('192.168.1.1', 33), equals('192.168.1.1'));
      expect(networkAddress('192.168.1.1', 99), equals('192.168.1.1'));
    });

    test('prefix < 0 returns ip unchanged', () {
      expect(networkAddress('192.168.1.1', -1), equals('192.168.1.1'));
    });

    test('wrong octet count returns ip unchanged', () {
      expect(networkAddress('192.168.1', 24),    equals('192.168.1'));
      expect(networkAddress('192.168.1.1.1', 24), equals('192.168.1.1.1'));
    });

    test('non-numeric octet returns ip unchanged', () {
      expect(networkAddress('192.168.x.1', 24), equals('192.168.x.1'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // detectLanCidr
  // ──────────────────────────────────────────────────────────────────────────
  group('detectLanCidr', () {
    // On the CI host (Linux) this will enumerate real interfaces and return a
    // CIDR, or null if detection fails.  We validate the *shape* of the result
    // rather than a fixed value so the test passes on any machine.

    test('returns null or a valid CIDR string', () async {
      final result = await detectLanCidr();

      if (result == null) {
        // Acceptable: no suitable interface found or running on web
        return;
      }

      // Must match x.x.x.x/n format
      final cidrPattern = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}$');
      expect(result, matches(cidrPattern),
          reason: 'detectLanCidr returned "$result" which is not a valid CIDR');

      // Host bits must be zero (it is a network address, not a host address)
      final parts = result.split('/');
      final prefix = int.parse(parts[1]);
      final computed = networkAddress(parts[0], prefix);
      expect(computed, equals(parts[0]),
          reason: 'Host bits are not zeroed: got "$result", expected "$computed/$prefix"');

      // Prefix must be in [0, 32]
      expect(prefix, inInclusiveRange(0, 32));
    });

    test('returned CIDR has zeroed host bits', () async {
      final result = await detectLanCidr();
      if (result == null) return; // skip if no interface

      final sep = result.lastIndexOf('/');
      final ip = result.substring(0, sep);
      final prefix = int.parse(result.substring(sep + 1));
      expect(networkAddress(ip, prefix), equals(ip));
    });
  });
}
