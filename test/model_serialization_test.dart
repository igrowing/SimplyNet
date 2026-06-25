import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/iot_scanner.dart';
import 'package:simply_net/services/ip_camera_detector.dart';

void main() {
  group('IotDevice JSON', () {
    test('toJson/fromJson round-trips every field', () {
      const original = IotDevice(
        ip: '192.168.1.20',
        mac: 'AA:BB:CC:DD:EE:01',
        vendor: 'Espressif',
        protocol: 'Tasmota',
        model: 'Sonoff',
        openPorts: [80, 1883],
        confidence: IotConfidence.definite,
        detectionMethod: 'HTTP/Tasmota',
        extra: {'fw': '12.1.0'},
      );
      final restored = IotDevice.fromJson(original.toJson());
      expect(restored.ip, original.ip);
      expect(restored.mac, original.mac);
      expect(restored.vendor, original.vendor);
      expect(restored.protocol, original.protocol);
      expect(restored.model, original.model);
      expect(restored.openPorts, original.openPorts);
      expect(restored.confidence, original.confidence);
      expect(restored.detectionMethod, original.detectionMethod);
      expect(restored.extra, original.extra);
    });

    test('fromJson falls back to possible for an unknown confidence', () {
      final restored = IotDevice.fromJson({
        'ip': '10.0.0.5',
        'confidence': 'bogus',
      });
      expect(restored.confidence, IotConfidence.possible);
      expect(restored.openPorts, isEmpty);
    });

    test('fromJson throws when the mandatory ip is missing', () {
      expect(() => IotDevice.fromJson(const {}), throwsFormatException);
    });
  });

  group('CameraCandidate JSON', () {
    test('toJson/fromJson round-trips every field', () {
      const original = CameraCandidate(
        ip: '192.168.1.30',
        port: 554,
        method: CameraDetectionMethod.specificPort,
        evidence: 'RTSP banner',
        manufacturer: 'Hikvision',
      );
      final restored = CameraCandidate.fromJson(original.toJson());
      expect(restored.ip, original.ip);
      expect(restored.port, original.port);
      expect(restored.method, original.method);
      expect(restored.evidence, original.evidence);
      expect(restored.manufacturer, original.manufacturer);
    });

    test('fromJson falls back to specificPort for an unknown method', () {
      final restored = CameraCandidate.fromJson({
        'ip': '10.0.0.6',
        'method': 'bogus',
      });
      expect(restored.method, CameraDetectionMethod.specificPort);
    });

    test('fromJson throws when the mandatory ip is missing', () {
      expect(() => CameraCandidate.fromJson(const {}), throwsFormatException);
    });
  });
}
