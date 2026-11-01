import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/iot_scanner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');

  // scanHosts reads the ARP table, which logs (SharedPreferences + docs dir)
  // when the read itself fails.
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

  group('IotScanner.probeOutcome', () {
    test('a Dart connect timeout (no OS error) is a timeout', () {
      expect(
        IotScanner.probeOutcome(const SocketException('Connection timed out')),
        PortProbeOutcome.timeout,
      );
    });

    test('OS-level ETIMEDOUT is a timeout', () {
      for (final code in [110, 60, 10060]) {
        expect(
          IotScanner.probeOutcome(
            SocketException('x', osError: OSError('timed out', code)),
          ),
          PortProbeOutcome.timeout,
          reason: 'errno $code',
        );
      }
    });

    test('connection refused means the host answered: closed', () {
      for (final code in [111, 61, 10061, 1225]) {
        expect(
          IotScanner.probeOutcome(
            SocketException('x', osError: OSError('refused', code)),
          ),
          PortProbeOutcome.closed,
          reason: 'errno $code',
        );
      }
    });

    test('any other OS error is unreachable', () {
      expect(
        IotScanner.probeOutcome(
          SocketException('x', osError: OSError('no route', 113)),
        ),
        PortProbeOutcome.unreachable,
      );
    });
  });

  group('IotScanner.scanPorts', () {
    test('reports an open port and counts a refused one as closed', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final sub = server.listen((s) => s.destroy());
      // Bind and release a second port so it is almost certainly closed.
      final probe = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final closedPort = probe.port;
      await probe.close();

      final r = await IotScanner.scanPorts('127.0.0.1', [
        server.port,
        closedPort,
      ], knownAlive: true);
      await sub.cancel();
      await server.close();

      expect(r.open, [server.port]);
      expect(r.hostResponded, isTrue);
      if (Platform.isWindows) {
        // Windows retries a refused connect for ~2 s before reporting it,
        // which can exceed the probe timeout; Linux/Android refuse at once.
        expect(r.closed + r.timedOut, 1);
      } else {
        expect(r.closed, 1);
        expect(r.timedOut, 0);
      }
    });

    test('summary lists every outcome count', () {
      const r = PortScanResult(
        open: [80],
        closed: 3,
        timedOut: 2,
        unreachable: 1,
      );
      expect(r.summary, 'ports=[80] closed=3 timeout=2 unreachable=1');
    });

    test('a host with only timeouts did not respond', () {
      const r = PortScanResult(
        open: [],
        closed: 0,
        timedOut: 4,
        unreachable: 0,
      );
      expect(r.hostResponded, isFalse);
    });
  });

  group('IotScanner.subnetTargets', () {
    test('every address is probed; ping hits keep their details', () {
      final targets = IotScanner.subnetTargets('192.0.2.0/29', {
        '192.0.2.3': HostResult(ip: '192.0.2.3', hostname: 'ha'),
      });
      expect(targets.map((h) => h.ip), [
        '192.0.2.1',
        '192.0.2.2',
        '192.0.2.3',
        '192.0.2.4',
        '192.0.2.5',
        '192.0.2.6',
      ]);
      final known = targets.firstWhere((h) => h.ip == '192.0.2.3');
      expect(known.hostname, 'ha');
      expect(known.isUp, isTrue);
      expect(
        targets.where((h) => h.ip != '192.0.2.3').every((h) => !h.isUp),
        isTrue,
      );
    });

    test('an invalid CIDR gives no targets', () {
      expect(IotScanner.subnetTargets('not-a-cidr', const {}), isEmpty);
    });
  });

  group('IotScanner.effectiveMac', () {
    test('a known host MAC wins', () {
      expect(
        IotScanner.effectiveMac(
          HostResult(ip: '192.0.2.1', mac: 'aa:bb:cc:dd:ee:ff'),
          const {'192.0.2.1': '11:22:33:44:55:66'},
        ),
        'AA:BB:CC:DD:EE:FF',
      );
    });

    test('falls back to the ARP table read during the IoT scan', () {
      expect(
        IotScanner.effectiveMac(
          HostResult(ip: '192.0.2.1', hostname: 'b4deab12de34'),
          const {'192.0.2.1': '11:22:33:44:55:66'},
        ),
        '11:22:33:44:55:66',
      );
    });

    test('then to a MAC published as the hostname', () {
      expect(
        IotScanner.effectiveMac(
          HostResult(ip: '192.0.2.1', hostname: 'b4deab12de34.lan'),
          const {},
        ),
        'B4:DE:AB:12:DE:34',
      );
    });

    test('null when no source knows the MAC', () {
      expect(
        IotScanner.effectiveMac(HostResult(ip: '192.0.2.1'), const {}),
        isNull,
      );
    });
  });

  group('IotScanner.scanHosts diagnostics', () {
    test('a skipped host line carries the probe outcome counts', () async {
      final skipped = <String>[];
      await IotScanner.scanHosts([
        HostResult(ip: '127.0.0.1', hostname: 'desktop-pc'),
      ], onSkipped: skipped.add).toList();
      expect(skipped.single, contains('desktop-pc'));
      expect(skipped.single, contains('closed='));
      expect(skipped.single, contains('timeout='));
    });

    test('an unknown address that never answers is not logged', () async {
      final skipped = <String>[];
      await IotScanner.scanHosts([
        HostResult(ip: '192.0.2.200', isUp: false),
      ], onSkipped: skipped.add).toList();
      expect(skipped, isEmpty);
    });
  });
}
