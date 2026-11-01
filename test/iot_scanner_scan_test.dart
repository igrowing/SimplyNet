import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/iot_scanner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');

  // The subnet path runs NetworkScanner.scan, which writes a diagnostic log
  // (SharedPreferences + docs dir) when the ARP table can't be read.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (call) async {
          if (call.method == 'getApplicationDocumentsDirectory') {
            return '/tmp';
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
  });

  group('IotScanner.scanHosts', () {
    test('empty host list completes immediately with no devices', () async {
      final devices = await IotScanner.scanHosts([]).toList();
      expect(devices, isEmpty);
    });

    // 192.0.2.0/24 is RFC 5737 TEST-NET-1: no port ever answers, so the only
    // possible evidence is the hostname / MAC / vendor carried by HostResult.
    test('a host with an IoT hostname and no open ports is detected', () async {
      final devices = await IotScanner.scanHosts([
        HostResult(
          ip: '192.0.2.10',
          mac: 'N/A',
          hostname: 'tasmota-1A2B3C-4567',
        ),
      ]).toList();
      expect(devices, hasLength(1));
      expect(devices.single.protocol, 'Tasmota');
      expect(devices.single.hostname, 'tasmota-1A2B3C-4567');
      expect(devices.single.openPorts, isEmpty);
    });

    test('a host whose hostname is its MAC is a definite smart plug', () async {
      final devices = await IotScanner.scanHosts([
        HostResult(
          ip: '192.0.2.11',
          mac: 'B4:DE:AB:12:DE:34',
          hostname: 'b4deab12de34.lan',
        ),
      ]).toList();
      expect(devices, hasLength(1));
      expect(devices.single.protocol, 'Smart plug');
      expect(devices.single.confidence, IotConfidence.definite);
      expect(devices.single.mac, 'B4:DE:AB:12:DE:34');
    });

    test('a host with an IoT OUI vendor and no ports is detected', () async {
      final devices = await IotScanner.scanHosts([
        HostResult(
          ip: '192.0.2.12',
          mac: 'A4:CF:12:AA:BB:CC',
          manufacturer: 'Espressif Inc.',
        ),
      ]).toList();
      expect(devices, hasLength(1));
      expect(devices.single.vendor, 'Espressif Inc.');
    });

    test('a non-IoT host is skipped and reported', () async {
      final skipped = <String>[];
      final devices = await IotScanner.scanHosts([
        HostResult(ip: '192.0.2.13', hostname: 'desktop-pc'),
      ], onSkipped: skipped.add).toList();
      expect(devices, isEmpty);
      expect(skipped.single, contains('192.0.2.13'));
      expect(skipped.single, contains('desktop-pc'));
    });
  });

  group('IotScanner.scanSubnet', () {
    test('normal CIDR', () async {
      final devices = await IotScanner.scanSubnet('192.0.2.0/30').toList();
      expect(devices, isList);
      expect(devices.length, 0);
    });

    test(
      'malformed CIDR (no prefix) yields no devices and completes',
      () async {
        final devices = await IotScanner.scanSubnet('192.168.1.0').toList();
        expect(devices, isEmpty);
      },
    );

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
      expect(IotConfidence.values, [
        IotConfidence.definite,
        IotConfidence.probable,
        IotConfidence.possible,
      ]);
    });
  });
}
