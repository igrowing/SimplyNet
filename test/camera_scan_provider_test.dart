import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/providers/camera_scan_provider.dart';
import 'package:simply_net/services/ip_camera_detector.dart';
import 'package:simply_net/services/scan_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('CameraScanProvider', () {
    test('starts empty and not scanning', () {
      final p = CameraScanProvider();
      expect(p.results, isEmpty);
      expect(p.scanning, isFalse);
      expect(p.cidr, '');
    });

    test('loadCache is a no-op when nothing is stored', () async {
      final p = CameraScanProvider();
      await p.loadCache();
      expect(p.results, isEmpty);
    });

    test('loadCache restores candidates and cidr from storage', () async {
      const cam = CameraCandidate(
        ip: '192.168.1.50',
        port: 554,
        method: CameraDetectionMethod.specificPort,
        evidence: 'RTSP',
        manufacturer: 'Hikvision',
      );
      await ScanStorage.save(ScanStorage.kCameras, '192.168.1.0/24', [
        cam.toJson(),
      ]);

      final p = CameraScanProvider();
      await p.loadCache();
      expect(p.cidr, '192.168.1.0/24');
      expect(p.results, hasLength(1));
      expect(p.results.first.ip, '192.168.1.50');
      expect(p.results.first.port, 554);
    });

    test('loadCache discards a corrupt cache without throwing', () async {
      SharedPreferences.setMockInitialValues({
        ScanStorage.kCameras: 'not-json-at-all',
      });
      final p = CameraScanProvider();
      await p.loadCache();
      expect(p.results, isEmpty);
    });

    test('results list is unmodifiable', () {
      final p = CameraScanProvider();
      expect(() => p.results.clear(), throwsUnsupportedError);
    });
  });
}
