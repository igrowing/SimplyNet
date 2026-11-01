import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/oui_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkScanner.macFromHostname', () {
    test('parses a bare 12-hex leftmost label', () {
      expect(
        NetworkScanner.macFromHostname('a4cf12aabbcc'),
        'A4:CF:12:AA:BB:CC',
      );
    });

    test('parses the leftmost label of an FQDN, case-insensitively', () {
      expect(
        NetworkScanner.macFromHostname('A4CF12AABBCC.lan'),
        'A4:CF:12:AA:BB:CC',
      );
      expect(
        NetworkScanner.macFromHostname('a4cf12aabbcc.home.arpa'),
        'A4:CF:12:AA:BB:CC',
      );
    });

    test('returns null for a 12-character label that is not hex', () {
      expect(NetworkScanner.macFromHostname('livingroom12'), isNull);
    });

    test('returns null for 11 or 13 hex characters', () {
      expect(NetworkScanner.macFromHostname('a4cf12aabbc'), isNull);
      expect(NetworkScanner.macFromHostname('a4cf12aabbccd'), isNull);
    });

    test('returns null for a delimited MAC', () {
      expect(NetworkScanner.macFromHostname('a4-cf-12-aa-bb-cc'), isNull);
    });

    test('returns null when the MAC is only part of the leftmost label', () {
      expect(NetworkScanner.macFromHostname('esp-a4cf12aabbcc'), isNull);
    });

    test('returns null for the all-zero and broadcast addresses', () {
      expect(NetworkScanner.macFromHostname('000000000000'), isNull);
      expect(NetworkScanner.macFromHostname('ffffffffffff'), isNull);
    });

    test('returns null for an empty hostname', () {
      expect(NetworkScanner.macFromHostname(''), isNull);
    });
  });

  group('NetworkScanner.applyMac hostname fallback', () {
    setUpAll(OuiService.init);

    test('fills MAC, vendor and type from the hostname when ARP has none', () {
      final host = HostResult(
        ip: '192.0.2.10',
        mac: '',
        hostname: 'a4cf12aabbcc',
      );
      NetworkScanner.applyMac(host, const {});
      expect(host.mac, 'A4:CF:12:AA:BB:CC');
      expect(host.manufacturer.toLowerCase(), contains('espressif'));
      expect(host.deviceType, 'IoT Device');
    });

    test('an ARP MAC wins over the hostname MAC', () {
      final host = HostResult(
        ip: '192.0.2.10',
        mac: '',
        hostname: 'a4cf12aabbcc',
      );
      NetworkScanner.applyMac(host, const {'192.0.2.10': '28:6F:B9:11:22:33'});
      expect(host.mac, '28:6F:B9:11:22:33');
      expect(host.manufacturer.toLowerCase(), contains('nokia'));
    });

    test('keeps N/A when neither ARP nor the hostname has a MAC', () {
      final host = HostResult(ip: '192.0.2.10', mac: '', hostname: 'laptop');
      NetworkScanner.applyMac(host, const {});
      expect(host.mac, 'N/A');
      expect(host.manufacturer, '');
    });
  });
}
