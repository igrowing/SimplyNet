import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_utils.dart';

void main() {
  // ────────────────────────────────────────────────────────────────────────────
  // inferPrefixFromAddress
  // ────────────────────────────────────────────────────────────────────────────
  group('inferPrefixFromAddress', () {
    test('192.168.x.x → /24', () {
      expect(inferPrefixFromAddress('192.168.1.1'), equals(24));
      expect(inferPrefixFromAddress('192.168.0.1'), equals(24));
      expect(inferPrefixFromAddress('192.168.255.254'), equals(24));
    });

    test('10.x.x.x → /24', () {
      expect(inferPrefixFromAddress('10.0.0.1'), equals(24));
      expect(inferPrefixFromAddress('10.10.50.200'), equals(24));
    });

    test('172.x.x.x → /24', () {
      expect(inferPrefixFromAddress('172.16.0.1'), equals(24));
      expect(inferPrefixFromAddress('172.31.255.1'), equals(24));
    });

    test('unknown range falls back to /24', () {
      expect(inferPrefixFromAddress('8.8.8.8'), equals(24));
      expect(inferPrefixFromAddress('1.2.3.4'), equals(24));
    });

    test('invalid IP with wrong octet count falls back to /24', () {
      expect(inferPrefixFromAddress('192.168.1'), equals(24));
      expect(inferPrefixFromAddress(''), equals(24));
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // networkAddress
  // ────────────────────────────────────────────────────────────────────────────
  group('networkAddress', () {
    test('/24 zeroes last octet', () {
      expect(networkAddress('192.168.1.100', 24), equals('192.168.1.0'));
      expect(networkAddress('192.168.1.255', 24), equals('192.168.1.0'));
      expect(networkAddress('192.168.1.1',   24), equals('192.168.1.0'));
    });

    test('/16 zeroes last two octets', () {
      expect(networkAddress('10.0.5.42',  16), equals('10.0.0.0'));
      expect(networkAddress('172.16.3.1', 16), equals('172.16.0.0'));
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
      expect(networkAddress('192.168.1.130', 25), equals('192.168.1.128'));
      expect(networkAddress('192.168.1.100', 25), equals('192.168.1.0'));
    });

    test('invalid prefix > 32 returns ip unchanged', () {
      expect(networkAddress('192.168.1.1', 33), equals('192.168.1.1'));
    });

    test('invalid prefix < 0 returns ip unchanged', () {
      expect(networkAddress('192.168.1.1', -1), equals('192.168.1.1'));
    });

    test('invalid IP returns ip unchanged', () {
      expect(networkAddress('not.an.ip.addr', 24), equals('not.an.ip.addr'));
    });

    test('too few octets returns ip unchanged', () {
      expect(networkAddress('192.168.1', 24), equals('192.168.1'));
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // cidrFromAddress  (combines inferPrefix + networkAddress → full CIDR string)
  // ────────────────────────────────────────────────────────────────────────────
  group('cidrFromAddress', () {
    test('192.168.1.42 → 192.168.1.0/24', () {
      expect(cidrFromAddress('192.168.1.42'), equals('192.168.1.0/24'));
    });

    test('10.0.5.200 → 10.0.5.0/24', () {
      expect(cidrFromAddress('10.0.5.200'), equals('10.0.5.0/24'));
    });

    test('172.16.3.1 → 172.16.3.0/24', () {
      expect(cidrFromAddress('172.16.3.1'), equals('172.16.3.0/24'));
    });

    test('empty string returns null', () {
      expect(cidrFromAddress(''), isNull);
    });

    test('invalid IP returns null', () {
      expect(cidrFromAddress('not-an-ip'), isNull);
    });

    test('incomplete IP returns null', () {
      expect(cidrFromAddress('192.168.1'), isNull);
    });
  });
}
