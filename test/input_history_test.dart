import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/services/input_history.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('InputHistory', () {
    test('load is empty initially', () async {
      expect(await InputHistory.load('host'), isEmpty);
    });

    test('add stores values most-recent first and deduplicates', () async {
      await InputHistory.add('host', '192.168.1.1');
      await InputHistory.add('host', 'example.com');
      await InputHistory.add('host', '192.168.1.1');
      expect(await InputHistory.load('host'), ['192.168.1.1', 'example.com']);
    });

    test('add ignores blank values', () async {
      await InputHistory.add('host', '   ');
      expect(await InputHistory.load('host'), isEmpty);
    });

    test('add trims and caps at maxEntries', () async {
      for (var i = 0; i < InputHistory.maxEntries + 5; i++) {
        await InputHistory.add('host', 'h$i');
      }
      final stored = await InputHistory.load('host');
      expect(stored.length, InputHistory.maxEntries);
      expect(stored.first, 'h${InputHistory.maxEntries + 4}');
    });

    test('histories are isolated per field key', () async {
      await InputHistory.add('host', 'a');
      await InputHistory.add('mqtt_topic', 'b');
      expect(await InputHistory.load('host'), ['a']);
      expect(await InputHistory.load('mqtt_topic'), ['b']);
    });

    test('replace overwrites the stored list', () async {
      await InputHistory.add('host', 'a');
      await InputHistory.add('host', 'b');
      await InputHistory.replace('host', ['b']);
      expect(await InputHistory.load('host'), ['b']);
    });
  });
}
