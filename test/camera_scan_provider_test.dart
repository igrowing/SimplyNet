
import 'dart:io';
 
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/providers/camera_scan_provider.dart';
import 'package:simply_net/services/ip_camera_detector.dart';
import 'package:simply_net/services/scan_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tmp;
 
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    // LogService.createLog (reached when a camera is found) needs a docs dir.
    tmp = await Directory.systemTemp.createTemp('simplynet_cam_prov_test');
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

    test('shouldAutoScan is true once when cache is empty', () async {
      final p = CameraScanProvider();
      expect(await p.shouldAutoScan(), isTrue);
      expect(await p.shouldAutoScan(), isFalse);
    });

    test('shouldAutoScan is false when cached cameras exist', () async {
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
      expect(await p.shouldAutoScan(), isFalse);
    });
  });
  group('CameraScanProvider scan lifecycle', () {
    // 192.0.2.0/24 is RFC 5737 TEST-NET-1 (reserved, unroutable): probes never
    // connect, so a scan completes with zero cameras without real network I/O.
    test('startScan(knownIps) probes only the given hosts and completes',
        () async {
      final p = CameraScanProvider();
      p.startScan('192.0.2.0/24',
          knownIps: ['192.0.2.1', '192.0.2.2'], logging: true);
      expect(p.scanning, isTrue);
      expect(p.cidr, '192.0.2.0/24');
      expect(p.total, 2);
 
      final done =
          await _waitUntil(() => !p.scanning, const Duration(seconds: 25));
      expect(done, isTrue, reason: 'scan did not finish in time');
      expect(p.results, isEmpty);
      p.dispose();
    });
 
    test('startScan(full subnet) completes with no results', () async {
      final p = CameraScanProvider();
      p.startScan('192.0.2.0/30', logging: false);
      expect(p.scanning, isTrue);
 
      final done =
          await _waitUntil(() => !p.scanning, const Duration(seconds: 25));
      expect(done, isTrue, reason: 'scan did not finish in time');
      expect(p.results, isEmpty);
      p.dispose();
    });
 
    test('startScan is a no-op while a scan is already running', () {
      final p = CameraScanProvider();
      p.startScan('192.0.2.0/30', logging: false);
      expect(p.scanning, isTrue);
      p.startScan('10.0.0.0/30', logging: false); // ignored — already scanning
      expect(p.cidr, '192.0.2.0/30');
      p.dispose();
    });
 
    test('stopScan clears scanning state and notifies', () {
      final p = CameraScanProvider();
      var notified = 0;
      p.addListener(() => notified++);
      p.startScan('192.0.2.0/30', logging: true);
      p.stopScan();
      expect(p.scanning, isFalse);
      expect(notified, greaterThan(0));
      p.dispose();
    });
 
    test('dispose during an in-flight scan does not throw', () {
      final p = CameraScanProvider();
      p.startScan('192.0.2.0/30', logging: false);
      expect(p.scanning, isTrue);
      expect(p.dispose, returnsNormally);
    });
 
    test('finds a live camera, sorts, caches and logs it', () async {
      // Open an RTSP-alternate port (8554) on loopback: a camera-specific port,
      // so detectHost flags it without any HTTP banner. Drives the provider's
      // onData → sort → save → log path with a real result.
      ServerSocket? srv;
      try {
        srv = await ServerSocket.bind(InternetAddress.loopbackIPv4, 8554);
      } on SocketException {
        return; // Port already in use on this host — skip silently.
      }
      srv.listen((s) => s.destroy());
 
      final p = CameraScanProvider();
      try {
        p.startScan('127.0.0.1/32',
            knownIps: ['127.0.0.1'], logging: true);
        final done =
            await _waitUntil(() => !p.scanning, const Duration(seconds: 25));
        expect(done, isTrue, reason: 'scan did not finish in time');
        expect(p.results, hasLength(1));
        expect(p.results.single.ip, '127.0.0.1');
        expect(p.results.single.port, 8554);
 
        // Result was persisted to local storage.
        final snap = await ScanStorage.load(ScanStorage.kCameras);
        expect(snap, isNotNull);
        expect(snap!.items, hasLength(1));
        // Let the async log write settle before tearing down the mock.
        await Future<void>.delayed(const Duration(milliseconds: 200));
      } finally {
        await srv.close();
        p.dispose();
      }
    }, timeout: const Timeout(Duration(seconds: 30)));
  });
  

}

// Polls [cond] every 50ms until it is true or [timeout] elapses.
Future<bool> _waitUntil(bool Function() cond, Duration timeout) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (cond()) return true;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  return cond();
}