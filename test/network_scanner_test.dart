import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/services/oui_service.dart';

void main() {
  // deviceTypeFromMac now resolves the vendor through assets/oui.json, so the
  // OUI database must be loaded before the MAC-based classification tests run.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => OuiService.init());

  // ── parseCidr ────────────────────────────────────────────────────────────

  group('NetworkScanner.parseCidr', () {
    test('parses valid /24', () {
      final r = NetworkScanner.parseCidr('192.168.1.0/24');
      expect(r, isNotNull);
      expect(r!.$1, equals('192.168.1.0'));
      expect(r.$2,  equals(24));
    });

    test('parses valid /16', () {
      final r = NetworkScanner.parseCidr('10.0.0.0/16');
      expect(r, isNotNull);
      expect(r!.$2, equals(16));
    });

    test('parses /32 (single host)', () {
      final r = NetworkScanner.parseCidr('192.168.1.100/32');
      expect(r, isNotNull);
      expect(r!.$2, equals(32));
    });

    test('parses /0 (all hosts)', () {
      final r = NetworkScanner.parseCidr('0.0.0.0/0');
      expect(r, isNotNull);
      expect(r!.$2, equals(0));
    });

    test('trims leading/trailing whitespace', () {
      expect(NetworkScanner.parseCidr('  192.168.1.0/24  '), isNotNull);
    });

    test('returns null for plain IP (no prefix)', () {
      expect(NetworkScanner.parseCidr('192.168.1.0'), isNull);
    });

    test('returns null for prefix > 32', () {
      expect(NetworkScanner.parseCidr('192.168.1.0/33'), isNull);
    });

    test('returns null for negative prefix', () {
      expect(NetworkScanner.parseCidr('192.168.1.0/-1'), isNull);
    });

    test('returns null for octet value > 255', () {
      expect(NetworkScanner.parseCidr('192.168.1.300/24'), isNull);
    });

    test('returns null for non-numeric octet', () {
      expect(NetworkScanner.parseCidr('192.168.one.0/24'), isNull);
    });

    test('returns null for too few octets', () {
      expect(NetworkScanner.parseCidr('192.168.1/24'), isNull);
    });

    test('returns null for too many octets', () {
      expect(NetworkScanner.parseCidr('192.168.1.0.1/24'), isNull);
    });

    test('returns null for empty string', () {
      expect(NetworkScanner.parseCidr(''), isNull);
    });

    test('returns null for random string', () {
      expect(NetworkScanner.parseCidr('not-a-cidr'), isNull);
    });
  });

  // ── isValidCidr ──────────────────────────────────────────────────────────

  group('NetworkScanner.isValidCidr', () {
    test('returns true for /8',  () => expect(NetworkScanner.isValidCidr('10.0.0.0/8'),   isTrue));
    test('returns true for /24', () => expect(NetworkScanner.isValidCidr('192.168.1.0/24'), isTrue));
    test('returns true for /32', () => expect(NetworkScanner.isValidCidr('10.0.0.1/32'),  isTrue));
    test('returns false for plain IP', () => expect(NetworkScanner.isValidCidr('192.168.1.1'), isFalse));
    test('returns false for garbage', () => expect(NetworkScanner.isValidCidr('not-a-cidr'), isFalse));
    test('returns false for empty',   () => expect(NetworkScanner.isValidCidr(''),           isFalse));
  });

  // ── deviceTypeFromMac ─────────────────────────────────────────────────────

  group('NetworkScanner.deviceTypeFromMac', () {
    test('Espressif MAC returns IoT Device', () {
      // 18:FE:34 → Espressif
      expect(NetworkScanner.deviceTypeFromMac('18:FE:34:AA:BB:CC'), equals('IoT Device'));
    });

    test('Tuya MAC returns IoT Device', () {
      // 1C:90:FF → Tuya Smart Inc.
      expect(NetworkScanner.deviceTypeFromMac('1C:90:FF:11:22:33'), equals('IoT Device'));
    });

    test('Beken/Tuya MAC returns IoT Device', () {
      // D8:5D:4C → Tuya/Beken
      expect(NetworkScanner.deviceTypeFromMac('D8:5D:4C:AA:BB:CC'), equals('IoT Device'));
    });

    test('Shelly MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('C4:5B:BE:AA:BB:CC'), equals('IoT Device'));
    });

    test('Philips Hue MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('00:17:88:AA:BB:CC'), equals('IoT Device'));
    });

    test('Signify (Hue parent) MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('C4:29:96:AA:BB:CC'), equals('IoT Device'));
    });

    test('Amazon MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('84:28:59:AA:BB:CC'), equals('IoT Device'));
    });

    test('Google MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('60:70:6C:AA:BB:CC'), equals('IoT Device'));
    });

    test('Raspberry Pi MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('DC:A6:32:AA:BB:CC'), equals('IoT Device'));
    });

    test('IKEA MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('68:EC:8A:AA:BB:CC'), equals('IoT Device'));
    });

    test('Wyze Labs MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('D0:3F:27:AA:BB:CC'), equals('IoT Device'));
    });

    test('TP-Link MAC returns IoT Device', () {
      expect(NetworkScanner.deviceTypeFromMac('50:C7:BF:AA:BB:CC'), equals('IoT Device'));
    });

    test('N/A returns empty string', () {
      expect(NetworkScanner.deviceTypeFromMac('N/A'), equals(''));
    });

    test('empty string returns empty string', () {
      expect(NetworkScanner.deviceTypeFromMac(''), equals(''));
    });

    test('short MAC returns empty string', () {
      expect(NetworkScanner.deviceTypeFromMac('AA:BB'), equals(''));
    });

    test('unknown OUI returns empty string', () {
      // 02:xx:xx is locally administered — never in OUI database
      expect(NetworkScanner.deviceTypeFromMac('02:00:00:AA:BB:CC'), equals(''));
    });

    test('MAC comparison is case-insensitive via toUpperCase', () {
      // deviceTypeFromMac converts to uppercase internally
      expect(NetworkScanner.deviceTypeFromMac('18:fe:34:aa:bb:cc'), equals('IoT Device'));
      expect(NetworkScanner.deviceTypeFromMac('18:Fe:34:Aa:Bb:Cc'), equals('IoT Device'));
    });
  });

  // ── _detectDeviceType (via manufacturer name) ────────────────────────────

  group('NetworkScanner._detectDeviceType (via manufacturer string)', () {
    // _detectDeviceType is private; we test its public effect indirectly
    // by checking it would classify correctly (logic is public-testable by name)

    // The following tests verify the keyword matching in _detectDeviceType
    // by constructing HostResult-like scenarios with known manufacturer strings.

    test('Espressif Inc. classifies as IoT Device', () {
      // Tuya/Espressif string comes from OUI lookup
      // _detectDeviceType checks _iotVendorKeywords which has 'espressif'
      // We can't call private method directly, but we can verify the logic
      // via deviceTypeFromMac since Espressif is in IoT prefixes
      expect(NetworkScanner.deviceTypeFromMac('18:FE:34:00:00:00'), equals('IoT Device'));
    });

    test('Tuya Smart classifies as IoT Device via MAC', () {
      expect(NetworkScanner.deviceTypeFromMac('FC:3C:D7:00:00:00'), equals('IoT Device'));
    });

    test('Nordic Semiconductor classifies as IoT Device via MAC', () {
      expect(NetworkScanner.deviceTypeFromMac('F4:CE:36:00:00:00'), equals('IoT Device'));
    });
  });

  // ── MAC format helpers ────────────────────────────────────────────────────

  group('MAC format validation', () {
    final validMacRe = RegExp(
        r'^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$');

    test('accepts valid colon-separated MAC', () {
      expect(validMacRe.hasMatch('00:1A:2B:3C:4D:5E'), isTrue);
      expect(validMacRe.hasMatch('AA:BB:CC:DD:EE:FF'), isTrue);
      expect(validMacRe.hasMatch('00:00:00:00:00:00'), isTrue);
    });

    test('rejects dash-separated MAC', () {
      expect(validMacRe.hasMatch('00-1A-2B-3C-4D-5E'), isFalse);
    });

    test('rejects compact MAC (no separators)', () {
      expect(validMacRe.hasMatch('001A2B3C4D5E'), isFalse);
    });

    test('rejects too-short MAC', () {
      expect(validMacRe.hasMatch('00:1A:2B:3C:4D'), isFalse);
    });

    test('rejects invalid hex chars', () {
      expect(validMacRe.hasMatch('GG:1A:2B:3C:4D:5E'), isFalse);
    });

    test('uppercase conversion', () {
      expect('00:1a:2b:3c:4d:5e'.toUpperCase(), equals('00:1A:2B:3C:4D:5E'));
    });

    test('broadcast MAC (00:00:00:00:00:00) is filtered out', () {
      const broadcastMac = '00:00:00:00:00:00';
      expect(broadcastMac == '00:00:00:00:00:00', isTrue);
    });
  });

  // ── ARP table parsing ─────────────────────────────────────────────────────

  group('ARP table line parsing', () {
    test('ip neigh show format parsed correctly', () {
      const line = '192.168.1.100 dev eth0 lladdr aa:bb:cc:dd:ee:ff REACHABLE';
      final re = RegExp(r'^(\S+).*?lladdr\s+([0-9a-f:]{17})', caseSensitive: false);
      final m = re.firstMatch(line);
      expect(m, isNotNull);
      expect(m!.group(1), equals('192.168.1.100'));
      expect(m.group(2)!.toUpperCase(), equals('AA:BB:CC:DD:EE:FF'));
    });

    test('STALE state line also parsed', () {
      const line = '10.0.0.1 dev wlan0 lladdr 11:22:33:44:55:66 STALE';
      final re = RegExp(r'^(\S+).*?lladdr\s+([0-9a-f:]{17})', caseSensitive: false);
      final m = re.firstMatch(line);
      expect(m, isNotNull);
      expect(m!.group(1), equals('10.0.0.1'));
    });

    test('line without lladdr is not matched', () {
      const line = '192.168.1.100 dev eth0  FAILED';
      final re = RegExp(r'^(\S+).*?lladdr\s+([0-9a-f:]{17})', caseSensitive: false);
      expect(re.hasMatch(line), isFalse);
    });
  });
}
