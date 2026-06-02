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
  });
}
