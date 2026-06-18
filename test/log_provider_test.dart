import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/providers/log_provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/services/log_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('simplynet_logprov_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') return tmp.path;
      return null;
    });
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('LogProvider', () {
    test('logs is empty before loading', () {
      expect(LogProvider().logs, isEmpty);
    });

    test('loadLogs pulls entries from LogService and notifies', () async {
      await LogService.createLog(function: 'ping', content: 'x');
      final p = LogProvider();
      var notified = 0;
      p.addListener(() => notified++);
      await p.loadLogs();
      expect(p.logs, isNotEmpty);
      expect(notified, 1);
    });

    test('deleteLog removes the entry from the in-memory list', () async {
      final entry = await LogService.createLog(function: 'scan', content: 'y');
      final p = LogProvider();
      await p.loadLogs();
      expect(p.logs.map((e) => e.id), contains(entry.id));
      await p.deleteLog(entry);
      expect(p.logs.map((e) => e.id), isNot(contains(entry.id)));
    });

    test('readLog delegates to LogService', () async {
      final entry =
          await LogService.createLog(function: 'traceroute', content: 'hop');
      final p = LogProvider();
      expect(await p.readLog(entry.filePath), 'hop');
    });

    test('listenToScanProvider reloads logs when logVersion changes', () async {
      await LogService.createLog(function: 'ping', content: 'z');
      final scan = ScanProvider();
      final p = LogProvider();
      p.listenToScanProvider(scan);
      scan.logVersion.value++;
      await Future<void>.delayed(Duration.zero);
      expect(p.logs, isNotEmpty);
    });
  });
}
