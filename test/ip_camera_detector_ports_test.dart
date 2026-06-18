import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/ip_camera_detector.dart';

void main() {
  group('IpCameraDetector port groups', () {
    test('specificPorts includes the standard RTSP port', () {
      expect(IpCameraDetector.specificPorts, contains(554));
    });

    test('genericPorts includes common web ports', () {
      expect(IpCameraDetector.genericPorts, containsAll([80, 443, 8080]));
    });

    test('allPorts is the union of specific and generic ports', () {
      expect(
        IpCameraDetector.allPorts,
        [...IpCameraDetector.specificPorts, ...IpCameraDetector.genericPorts],
      );
    });

    test('specific and generic ports do not overlap', () {
      final overlap = IpCameraDetector.specificPorts
          .toSet()
          .intersection(IpCameraDetector.genericPorts.toSet());
      expect(overlap, isEmpty);
    });
  });

  group('IpCameraDetector.isKnownCameraManufacturer', () {
    test('matches known camera vendors case-insensitively', () {
      expect(IpCameraDetector.isKnownCameraManufacturer('HIKVISION'), isTrue);
      expect(IpCameraDetector.isKnownCameraManufacturer('Dahua Technology'), isTrue);
      expect(IpCameraDetector.isKnownCameraManufacturer('Axis Communications'), isTrue);
    });

    test('rejects non-camera vendors and empty input', () {
      expect(IpCameraDetector.isKnownCameraManufacturer('Apple'), isFalse);
      expect(IpCameraDetector.isKnownCameraManufacturer('Cisco'), isFalse);
      expect(IpCameraDetector.isKnownCameraManufacturer(''), isFalse);
    });
  });

  group('CameraCandidate', () {
    test('toString includes manufacturer when present', () {
      const c = CameraCandidate(
        ip: '10.0.0.5',
        port: 554,
        method: CameraDetectionMethod.specificPort,
        evidence: 'RTSP open',
        manufacturer: 'Hikvision',
      );
      final s = c.toString();
      expect(s, contains('10.0.0.5:554'));
      expect(s, contains('RTSP open'));
      expect(s, contains('Hikvision'));
    });

    test('toString omits manufacturer parens when empty', () {
      const c = CameraCandidate(
        ip: '10.0.0.6',
        port: 80,
        method: CameraDetectionMethod.genericPortHttp,
        evidence: 'ONVIF banner',
      );
      expect(c.manufacturer, '');
      expect(c.toString(), isNot(contains('(')));
    });
  });
}
