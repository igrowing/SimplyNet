import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/providers/iot_scan_provider.dart';
import 'package:simply_net/services/iot_scanner.dart';
import 'package:simply_net/services/scan_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('IotScanProvider', () {
    test('starts empty and not scanning', () {
      final p = IotScanProvider();
      expect(p.devices, isEmpty);
      expect(p.scanning, isFalse);
      expect(p.cidr, '');
    });

    test('loadCache is a no-op when nothing is stored', () async {
      final p = IotScanProvider();
      await p.loadCache();
      expect(p.devices, isEmpty);
    });

    test('loadCache restores devices and cidr from storage', () async {
      const device = IotDevice(
        ip: '192.168.1.40',
        mac: 'AA:00',
        vendor: 'Espressif',
        protocol: 'Tasmota',
        model: '',
        openPorts: [80],
        confidence: IotConfidence.probable,
        detectionMethod: 'HTTP',
      );
      await ScanStorage.save(ScanStorage.kIotDevices, '192.168.1.0/24', [
        device.toJson(),
      ]);

      final p = IotScanProvider();
      await p.loadCache();
      expect(p.cidr, '192.168.1.0/24');
      expect(p.devices, hasLength(1));
      expect(p.devices.first.ip, '192.168.1.40');
    });

    test('loadCache discards a corrupt cache without throwing', () async {
      SharedPreferences.setMockInitialValues({
        ScanStorage.kIotDevices: 'not-json-at-all',
      });
      final p = IotScanProvider();
      await p.loadCache();
      expect(p.devices, isEmpty);
    });

    test('devices list is unmodifiable', () {
      final p = IotScanProvider();
      expect(() => p.devices.clear(), throwsUnsupportedError);
    });
  });
}
