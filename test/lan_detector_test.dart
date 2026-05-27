import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/lan_detector.dart';

void main() {
  // Initialize Flutter binding once so network_info_plus plugin
  // channels are available (detectLanCidr tests need this).
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

  // ──────────────────────────────────────────────────────────────────────────
  // subnetMaskToPrefix
  // ──────────────────────────────────────────────────────────────────────────
  group('subnetMaskToPrefix', () {
    test('common masks return correct prefix', () {
      expect(subnetMaskToPrefix('255.255.255.0'),   equals(24));
      expect(subnetMaskToPrefix('255.255.0.0'),     equals(16));
      expect(subnetMaskToPrefix('255.0.0.0'),       equals(8));
      expect(subnetMaskToPrefix('255.255.255.128'), equals(25));
      expect(subnetMaskToPrefix('255.255.255.192'), equals(26));
      expect(subnetMaskToPrefix('255.255.255.252'), equals(30));
      expect(subnetMaskToPrefix('255.255.255.255'), equals(32));
      expect(subnetMaskToPrefix('0.0.0.0'),         equals(0));
    });

    test('non-contiguous masks fall back to 24', () {
      // 255.0.255.0 — octet 3 is non-zero after a zero octet
      expect(subnetMaskToPrefix('255.0.255.0'),  equals(24));
      // 255.128.0.1 — last octet has a 1-bit after zero bits in octets 2-3
      expect(subnetMaskToPrefix('255.128.0.1'),  equals(24));
      // 0.255.0.0 — starts with a zero octet then has 1-bits
      expect(subnetMaskToPrefix('0.255.0.0'),    equals(24));
    });

    test('invalid strings fall back to 24', () {
      expect(subnetMaskToPrefix(''),            equals(24));
      expect(subnetMaskToPrefix('255.255'),     equals(24));
      expect(subnetMaskToPrefix('abc.def.g.h'), equals(24));
      expect(subnetMaskToPrefix('256.0.0.0'),   equals(24));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // inferPrefixFromAddress
  // ──────────────────────────────────────────────────────────────────────────
  group('inferPrefixFromAddress', () {
    test('192.168.x.x returns /24', () {
      expect(inferPrefixFromAddress('192.168.1.1'),     equals(24));
      expect(inferPrefixFromAddress('192.168.0.1'),     equals(24));
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

    test('invalid IP falls back to /24', () {
      expect(inferPrefixFromAddress('192.168.1'),  equals(24));
      expect(inferPrefixFromAddress(''),           equals(24));
      expect(inferPrefixFromAddress('abc.x.y.z'), equals(24));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // networkAddress
  // ──────────────────────────────────────────────────────────────────────────
  group('networkAddress', () {
    test('/24 zeroes last octet', () {
      expect(networkAddress('192.168.1.100', 24), equals('192.168.1.0'));
      expect(networkAddress('192.168.1.255', 24), equals('192.168.1.0'));
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
      expect(networkAddress('192.168.1.200', 25), equals('192.168.1.128'));
      expect(networkAddress('192.168.1.127', 25), equals('192.168.1.0'));
    });

    test('out-of-range prefix returns ip unchanged', () {
      expect(networkAddress('192.168.1.1', 33), equals('192.168.1.1'));
      expect(networkAddress('192.168.1.1', -1), equals('192.168.1.1'));
    });

    test('invalid IP octets return ip unchanged', () {
      expect(networkAddress('192.168.1',   24), equals('192.168.1'));
      expect(networkAddress('192.168.x.1', 24), equals('192.168.x.1'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // detectLanCidr — shape/contract tests (no mock, runs on CI host)
  // ──────────────────────────────────────────────────────────────────────────
  group('detectLanCidr', () {
    test('returns null or a valid CIDR string', () async {
      final result = await detectLanCidr();
      if (result == null) return;

      final cidrRe = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}$');
      expect(result, matches(cidrRe),
          reason: 'detectLanCidr returned "$result" — not a valid CIDR');
    });

    test('returned CIDR has host bits zeroed', () async {
      final result = await detectLanCidr();
      if (result == null) return;

      final sep    = result.lastIndexOf('/');
      final ip     = result.substring(0, sep);
      final prefix = int.parse(result.substring(sep + 1));
      expect(networkAddress(ip, prefix), equals(ip),
          reason: 'Host bits not zeroed in "$result"');
    });

    test('prefix is in range [0, 32]', () async {
      final result = await detectLanCidr();
      if (result == null) return;

      final prefix = int.parse(result.split('/').last);
      expect(prefix, inInclusiveRange(0, 32));
    });
  });
}
