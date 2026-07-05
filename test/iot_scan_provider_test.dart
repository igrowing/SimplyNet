import 'dart:io';
 
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/providers/iot_scan_provider.dart';
import 'package:simply_net/services/iot_scanner.dart';
import 'package:simply_net/services/scan_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tmp;
 
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    // LogService.createLog (reached on the scan-complete path) needs a docs dir.
    tmp = await Directory.systemTemp.createTemp('simplynet_iot_prov_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') return tmp.path;
      return null;
    });
  });
 
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });
 

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

    test('shouldAutoScan is true once when cache is empty', () async {
      final p = IotScanProvider();
      expect(await p.shouldAutoScan(), isTrue);
      expect(await p.shouldAutoScan(), isFalse);
    });

    test('shouldAutoScan is false when cached devices exist', () async {
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
      expect(await p.shouldAutoScan(), isFalse);
    });
  });
 
  group('IotScanProvider scan lifecycle', () {
    // 192.0.2.0/24 is RFC 5737 TEST-NET-1 (reserved, unroutable): probes never
    // connect, so a scan completes with zero devices without real network I/O.
    // FgService.start/stop early-return off-Android, so they are safe to drive.
    test('startScan(knownIps) probes only the given hosts and completes',
        () async {
      final p = IotScanProvider();
      p.startScan('192.0.2.0/24',
          knownIps: ['192.0.2.1', '192.0.2.2'], logging: true);
      expect(p.scanning, isTrue);
      expect(p.cidr, '192.0.2.0/24');
      expect(p.total, 2);
 
      final done =
          await _waitUntil(() => !p.scanning, const Duration(seconds: 25));
      expect(done, isTrue, reason: 'scan did not finish in time');
      expect(p.devices, isEmpty);
      // Let the async onDone (save + log) settle before disposing.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      p.dispose();
    });
 
    test('startScan(full subnet) derives the host total and completes',
        () async {
      final p = IotScanProvider();
      p.startScan('192.0.2.0/30', logging: false); // /30 → 2 host addresses
      expect(p.scanning, isTrue);
      expect(p.total, 2);
 
      final done =
          await _waitUntil(() => !p.scanning, const Duration(seconds: 25));
      expect(done, isTrue, reason: 'scan did not finish in time');
      expect(p.devices, isEmpty);
      p.dispose();
    });
 
    test('startScan is a no-op while a scan is already running', () {
      final p = IotScanProvider();
      p.startScan('192.0.2.0/30', logging: false);
      expect(p.scanning, isTrue);
      p.startScan('10.0.0.0/30', logging: false); // ignored — already scanning
      expect(p.cidr, '192.0.2.0/30');
      p.dispose();
    });
 
    test('stopScan clears scanning state and notifies', () {
      final p = IotScanProvider();
      var notified = 0;
      p.addListener(() => notified++);
      p.startScan('192.0.2.0/30', logging: false);
      p.stopScan();
      expect(p.scanning, isFalse);
      expect(notified, greaterThan(0));
      p.dispose();
    });
 
    test('dispose during an in-flight scan does not throw', () {
      final p = IotScanProvider();
      p.startScan('192.0.2.0/30', logging: false);
      expect(p.scanning, isTrue);
      expect(p.dispose, returnsNormally);
    });

    test('collects a live device, caches and logs it', () async {
      // Open the MQTT port (1883) on loopback so the scan classifies the host
      // as an MQTT broker via a raw TCP knock — no HttpClient, which the test
      // binding stubs to HTTP 400. Drives the provider's onData → save → log.
      ServerSocket? srv;
      try {
        srv = await ServerSocket.bind(InternetAddress.loopbackIPv4, 1883);
      } on SocketException {
        return; // Port already in use on this host — skip silently.
      }
      srv.listen((s) => s.destroy());

      final p = IotScanProvider();
      try {
        p.startScan('127.0.0.1/32', knownIps: ['127.0.0.1'], logging: true);
        final done =
            await _waitUntil(() => !p.scanning, const Duration(seconds: 25));
        expect(done, isTrue, reason: 'scan did not finish in time');
        expect(p.devices, hasLength(1));
        expect(p.devices.single.ip, '127.0.0.1');
        expect(p.devices.single.protocol, contains('MQTT'));

        final snap = await ScanStorage.load(ScanStorage.kIotDevices);
        expect(snap, isNotNull);
        expect(snap!.items, hasLength(1));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      } finally {
        await srv.close();
        p.dispose();
      }
    }, timeout: const Timeout(Duration(seconds: 30)));
  });
}
 
/// Polls [cond] every 50ms until it is true or [timeout] elapses.
Future<bool> _waitUntil(bool Function() cond, Duration timeout) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (cond()) return true;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  return cond();
}
