import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/models/log_entry.dart';

void main() {
  group('LogEntry', () {
    final ts = DateTime.fromMillisecondsSinceEpoch(1700000000000);

    LogEntry sample({String summary = 'a summary'}) => LogEntry(
          id: 'abc123',
          function: 'ping',
          timestamp: ts,
          filePath: '/logs/ping/abc123.txt',
          summary: summary,
        );

    test('toJson produces all fields with epoch-ms timestamp', () {
      final json = sample().toJson();
      expect(json, {
        'id': 'abc123',
        'function': 'ping',
        'timestamp': ts.millisecondsSinceEpoch,
        'filePath': '/logs/ping/abc123.txt',
        'summary': 'a summary',
      });
    });

    test('fromJson round-trips a toJson map', () {
      final original = sample();
      final restored = LogEntry.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.function, original.function);
      expect(restored.timestamp, original.timestamp);
      expect(restored.filePath, original.filePath);
      expect(restored.summary, original.summary);
    });

    test('summary defaults to empty string when omitted in constructor', () {
      final entry = LogEntry(
        id: 'x',
        function: 'scan',
        timestamp: ts,
        filePath: '/logs/scan/x.txt',
      );
      expect(entry.summary, '');
      expect(entry.toJson()['summary'], '');
    });

    test('fromJson defaults summary to empty string when key absent', () {
      final entry = LogEntry.fromJson({
        'id': 'y',
        'function': 'traceroute',
        'timestamp': ts.millisecondsSinceEpoch,
        'filePath': '/logs/traceroute/y.txt',
      });
      expect(entry.summary, '');
    });

    test('fromJson reconstructs timestamp from epoch ms', () {
      final entry = LogEntry.fromJson({
        'id': 'z',
        'function': 'portscan',
        'timestamp': 1700000000000,
        'filePath': '/logs/portscan/z.txt',
        'summary': 's',
      });
      expect(entry.timestamp, DateTime.fromMillisecondsSinceEpoch(1700000000000));
    });
  });
}
