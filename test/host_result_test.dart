import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/models/host_result.dart';

void main() {
  group('HostResult', () {
    test('default optional fields', () {
      final hostResult = HostResult(ip: '192.168.1.1');
      expect(hostResult.ip, '192.168.1.1');
      expect(hostResult.mac, 'N/A');
      expect(hostResult.hostname, '');
      expect(hostResult.manufacturer, '');
      expect(hostResult.deviceType, '');
      expect(hostResult.isUp, isTrue);
    });

    test('copyWith replaces specified fields', () {
      final hostResult = HostResult(ip: '10.0.0.1', mac: 'AA:BB:CC:DD:EE:FF');
      final updated = hostResult.copyWith(hostname: 'router', manufacturer: 'Cisco');
      expect(updated.ip, '10.0.0.1');
      expect(updated.mac, 'AA:BB:CC:DD:EE:FF');
      expect(updated.hostname, 'router');
      expect(updated.manufacturer, 'Cisco');
    });

    test('copyWith preserves isUp when not specified', () {
      final hostResult = HostResult(ip: '10.0.0.1', isUp: true);
      final copy = hostResult.copyWith(hostname: 'test');
      expect(copy.isUp, isTrue);
    });

    test('copyWith can set isUp to false', () {
      final hostResult = HostResult(ip: '10.0.0.1', isUp: true);
      final copy = hostResult.copyWith(isUp: false);
      expect(copy.isUp, isFalse);
    });

    test('toJson/fromJson round-trips every field', () {
      final original = HostResult(
        ip: '192.168.1.5',
        mac: 'AA:BB:CC:DD:EE:FF',
        hostname: 'nas',
        manufacturer: 'Synology',
        deviceType: 'NAS',
        isUp: false,
      );
      final restored = HostResult.fromJson(original.toJson());
      expect(restored.ip, original.ip);
      expect(restored.mac, original.mac);
      expect(restored.hostname, original.hostname);
      expect(restored.manufacturer, original.manufacturer);
      expect(restored.deviceType, original.deviceType);
      expect(restored.isUp, original.isUp);
    });

    test('fromJson applies defaults for absent optional fields', () {
      final restored = HostResult.fromJson({'ip': '10.0.0.9'});
      expect(restored.ip, '10.0.0.9');
      expect(restored.mac, 'N/A');
      expect(restored.hostname, '');
      expect(restored.isUp, isTrue);
    });

    test('fromJson throws when the mandatory ip is missing', () {
      expect(() => HostResult.fromJson(const {}), throwsFormatException);
      expect(
          () => HostResult.fromJson(const {'ip': ''}), throwsFormatException);
    });
  });
}
