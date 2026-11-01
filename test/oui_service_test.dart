import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/oui_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OuiService.lookup', () {
    test('returns empty string for too-short MAC', () {
      expect(OuiService.lookup('AA:BB'), '');
    });

    test('resolves a known OUI prefix after init', () async {
      await OuiService.init();
      // 28:6F:B9 is present in assets/oui.json (Nokia Shanghai Bell).
      final vendor = OuiService.lookup('28:6F:B9:11:22:33');
      expect(vendor, isNotEmpty);
      expect(vendor.toLowerCase(), contains('nokia'));
    });

    test('lookup is case-insensitive on the prefix', () async {
      await OuiService.init();
      expect(
        OuiService.lookup('28:6f:b9:aa:bb:cc'),
        OuiService.lookup('28:6F:B9:AA:BB:CC'),
      );
    });

    test('returns empty string for an unknown prefix', () async {
      await OuiService.init();
      expect(OuiService.lookup('ZZ:ZZ:ZZ:00:00:00'), '');
    });

    test('init is idempotent (second call is a no-op)', () async {
      await OuiService.init();
      await OuiService.init();
      expect(OuiService.lookup('28:6F:B9:00:00:00'), isNotEmpty);
    });
  });

  // Prefixes kept from the former IoT scanner table that the IEEE registry
  // in assets/oui.json does not list.
  group('OuiService supplementary IoT prefixes', () {
    test('resolves prefixes missing from the IEEE registry', () async {
      await OuiService.init();
      expect(
        OuiService.lookup('CC:02:D1:00:00:01').toLowerCase(),
        contains('tuya'),
      );
      expect(
        OuiService.lookup('D0:F6:18:00:00:01').toLowerCase(),
        contains('nordic'),
      );
    });

    test('never overrides an IEEE registry entry', () async {
      await OuiService.init();
      expect(
        OuiService.lookup('AC:29:3A:00:00:01').toLowerCase(),
        contains('apple'),
      );
    });
  });
}
