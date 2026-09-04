import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/models/log_entry.dart';
import 'package:simply_net/utils/log_sharing.dart';

void main() {
  final entry = LogEntry(
    id: 'iot_scan_20260904_120000',
    function: 'iot_scan',
    timestamp: DateTime(2026, 9, 4, 12, 0, 0),
    filePath: '/tmp/logs/iot_scan_20260904_120000.log',
    summary: 'IoT scan 192.168.1.0/24: 3 device(s) found',
  );

  group('logShareParams', () {
    test('shares exactly the log file', () {
      final params = logShareParams(entry);
      expect(params.files, hasLength(1));
      expect(params.files!.single.path, entry.filePath);
    });

    test('subject mirrors the UI log title (function + timestamp)', () {
      expect(
        logShareParams(entry).subject,
        'IOT_SCAN — 2026-09-04 12:00:00',
      );
    });

    test('does not attach free-form text (file only)', () {
      expect(logShareParams(entry).text, isNull);
    });
  });
}
