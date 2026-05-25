import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/models/host_result.dart';

void main() {
  group('HostResult', () {
    test('default optional fields', () {
      final h = HostResult(ip: '192.168.1.1');
      expect(h.ip, '192.168.1.1');
      expect(h.mac, 'N/A');
      expect(h.hostname, '');
      expect(h.manufacturer, '');
      expect(h.deviceType, '');
      expect(h.isUp, isTrue);
    });

    test('copyWith replaces specified fields', () {
      final h = HostResult(ip: '10.0.0.1', mac: 'AA:BB:CC:DD:EE:FF');
      final updated = h.copyWith(hostname: 'router', manufacturer: 'Cisco');
      expect(updated.ip, '10.0.0.1');
      expect(updated.mac, 'AA:BB:CC:DD:EE:FF');
      expect(updated.hostname, 'router');
      expect(updated.manufacturer, 'Cisco');
    });

    test('copyWith preserves isUp when not specified', () {
      final h = HostResult(ip: '10.0.0.1', isUp: true);
      final copy = h.copyWith(hostname: 'test');
      expect(copy.isUp, isTrue);
    });

    test('copyWith can set isUp to false', () {
      final h = HostResult(ip: '10.0.0.1', isUp: true);
      final copy = h.copyWith(isUp: false);
      expect(copy.isUp, isFalse);
    });
  });
}
