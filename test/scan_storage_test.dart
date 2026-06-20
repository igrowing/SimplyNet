import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/services/scan_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ScanStorage', () {
    test('load returns null when nothing is stored', () async {
      final snap = await ScanStorage.load(ScanStorage.kScanHosts);
      expect(snap, isNull);
    });

    test('save then load round-trips cidr and items', () async {
      await ScanStorage.save(ScanStorage.kIotDevices, '192.168.1.0/24', [
        {'ip': '192.168.1.2', 'mac': 'AA:00'},
        {'ip': '192.168.1.3', 'mac': 'BB:00'},
      ]);
      final snap = await ScanStorage.load(ScanStorage.kIotDevices);
      expect(snap, isNotNull);
      expect(snap!.cidr, '192.168.1.0/24');
      expect(snap.items, hasLength(2));
      expect(snap.items.first['ip'], '192.168.1.2');
    });

    test('clear removes a stored snapshot', () async {
      await ScanStorage.save(ScanStorage.kCameras, '10.0.0.0/24', [
        {'ip': '10.0.0.2'},
      ]);
      await ScanStorage.clear(ScanStorage.kCameras);
      expect(await ScanStorage.load(ScanStorage.kCameras), isNull);
    });

    test('load throws on a corrupt (non-map) payload', () async {
      SharedPreferences.setMockInitialValues({
        ScanStorage.kScanHosts: '["not", "an", "object"]',
      });
      expect(
        () => ScanStorage.load(ScanStorage.kScanHosts),
        throwsFormatException,
      );
    });

    test('load throws when items is missing', () async {
      SharedPreferences.setMockInitialValues({
        ScanStorage.kScanHosts: '{"cidr":"192.168.1.0/24"}',
      });
      expect(
        () => ScanStorage.load(ScanStorage.kScanHosts),
        throwsFormatException,
      );
    });
  });
}
