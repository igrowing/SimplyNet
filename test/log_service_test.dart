import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/services/log_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('simplynet_logs_test');
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

  group('LogService', () {
    test('loadIndex is empty initially', () async {
      expect(await LogService.loadIndex(), isEmpty);
    });

    test('createLog writes file, indexes it and derives summary', () async {
      final entry = await LogService.createLog(
        function: 'ping',
        content: 'first line\nsecond line',
      );
      expect(entry.function, 'ping');
      expect(entry.summary, 'first line'); // first line of content
      expect(File(entry.filePath).existsSync(), isTrue);

      final index = await LogService.loadIndex();
      expect(index.map((e) => e.id), contains(entry.id));
    });

    test('explicit summary overrides the first-line default', () async {
      final entry = await LogService.createLog(
        function: 'scan',
        content: 'body',
        summary: 'custom summary',
      );
      expect(entry.summary, 'custom summary');
    });

    test('readLog returns file contents', () async {
      final entry = await LogService.createLog(
        function: 'traceroute',
        content: 'hop1\nhop2',
      );
      expect(await LogService.readLog(entry.filePath), 'hop1\nhop2');
    });

    test('readLog returns placeholder for a missing file', () async {
      expect(await LogService.readLog('${tmp.path}/does_not_exist.log'),
          '(log file not found)');
    });

    test('deleteLog removes the file and the index entry', () async {
      final entry = await LogService.createLog(
        function: 'portscan',
        content: 'data',
      );
      await LogService.deleteLog(entry);
      expect(File(entry.filePath).existsSync(), isFalse);
      final index = await LogService.loadIndex();
      expect(index.map((e) => e.id), isNot(contains(entry.id)));
    });
  });
}
