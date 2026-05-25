import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_scanner.dart';

void main() {
  group('NetworkScanner.parseCidr', () {
    test('parses valid /24', () {
      final result = NetworkScanner.parseCidr('192.168.1.0/24');
      expect(result, isNotNull);
      expect(result!.$1, equals('192.168.1.0'));
      expect(result.$2, equals(24));
    });

    test('parses valid /16', () {
      final result = NetworkScanner.parseCidr('10.0.0.0/16');
      expect(result, isNotNull);
      expect(result!.$2, equals(16));
    });

    test('parses /32 (single host)', () {
      final result = NetworkScanner.parseCidr('192.168.1.100/32');
      expect(result, isNotNull);
      expect(result!.$2, equals(32));
    });

    test('trims whitespace', () {
      final result = NetworkScanner.parseCidr('  192.168.1.0/24  ');
      expect(result, isNotNull);
    });

    test('returns null for missing prefix', () {
      expect(NetworkScanner.parseCidr('192.168.1.0'), isNull);
    });

    test('returns null for prefix > 32', () {
      expect(NetworkScanner.parseCidr('192.168.1.0/33'), isNull);
    });

    test('returns null for negative prefix', () {
      expect(NetworkScanner.parseCidr('192.168.1.0/-1'), isNull);
    });

    test('returns null for invalid IP octet > 255', () {
      expect(NetworkScanner.parseCidr('192.168.1.300/24'), isNull);
    });

    test('returns null for non-numeric octet', () {
      expect(NetworkScanner.parseCidr('192.168.one.0/24'), isNull);
    });

    test('returns null for too few octets', () {
      expect(NetworkScanner.parseCidr('192.168.1/24'), isNull);
    });

    test('returns null for empty string', () {
      expect(NetworkScanner.parseCidr(''), isNull);
    });
  });

  group('NetworkScanner.isValidCidr', () {
    test('returns true for valid CIDR', () {
      expect(NetworkScanner.isValidCidr('10.0.0.0/8'), isTrue);
    });

    test('returns false for invalid CIDR', () {
      expect(NetworkScanner.isValidCidr('not-a-cidr'), isFalse);
    });

    test('returns false for plain IP with no prefix', () {
      expect(NetworkScanner.isValidCidr('192.168.1.1'), isFalse);
    });
  });
}
