import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/iot_scanner.dart';

void main() {
  group('IotScanner.scanHosts', () {
    test('empty IP list completes immediately with no devices', () async {
      final devices = await IotScanner.scanHosts([]).toList();
      expect(devices, isEmpty);
    });
  });

  group('IotScanner.scanSubnet', () {
    test('normal CIDR', () async {
      final devices = await IotScanner.scanSubnet('192.168.1.0/30').toList();
      expect(devices, isList);
      expect(devices.length, 0);
    });

    test('malformed CIDR (no prefix) yields no devices and completes', () async {
      final devices = await IotScanner.scanSubnet('192.168.1.0').toList();
      expect(devices, isEmpty);
    });

    test('garbage input yields no devices and completes', () async {
      final devices = await IotScanner.scanSubnet('not-a-cidr').toList();
      expect(devices, isEmpty);
    });
  });

  group('IotDevice model', () {
    IotDevice make({Map<String, String>? extra}) => IotDevice(
          ip: '192.168.1.10',
          mac: 'AA:BB:CC:DD:EE:FF',
          vendor: 'Espressif',
          protocol: 'Tasmota',
          model: 'Sonoff',
          openPorts: const [80, 1883],
          confidence: IotConfidence.definite,
          detectionMethod: 'HTTP/Tasmota',
          extra: extra ?? const {},
        );

    test('toString contains ip, protocol, vendor and method', () {
      final s = make().toString();
      expect(s, contains('192.168.1.10'));
      expect(s, contains('Tasmota'));
      expect(s, contains('Espressif'));
      expect(s, contains('HTTP/Tasmota'));
      expect(s, contains('definite'));
    });

    test('extra defaults to an empty map', () {
      expect(make().extra, isEmpty);
    });

    test('confidence enum exposes three levels', () {
      expect(IotConfidence.values,
          [IotConfidence.definite, IotConfidence.probable, IotConfidence.possible]);
    });
  });
}
