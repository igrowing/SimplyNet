import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/providers/scan_provider.dart';

void main() {
  group('ScanProvider target', () {
    test('default target is empty and invalid', () {
      final p = ScanProvider();
      expect(p.target, '');
      expect(p.isValidTarget, isFalse);
    });

    test('setTarget updates target and notifies listeners', () {
      final p = ScanProvider();
      var notified = 0;
      p.addListener(() => notified++);
      p.setTarget('192.168.1.0/24');
      expect(p.target, '192.168.1.0/24');
      expect(notified, 1);
    });

    test('isValidTarget reflects CIDR validity', () {
      final p = ScanProvider();
      p.setTarget('10.0.0.0/8');
      expect(p.isValidTarget, isTrue);
      p.setTarget('not-a-cidr');
      expect(p.isValidTarget, isFalse);
    });
  });

  group('ScanProvider sorting state', () {
    test('defaults to ascending by IP', () {
      final p = ScanProvider();
      expect(p.sortColumn, ScanSortColumn.ip);
      expect(p.sortAsc, isTrue);
    });

    test('toggleSort on same column flips direction', () {
      final p = ScanProvider();
      p.toggleSort(ScanSortColumn.ip);
      expect(p.sortColumn, ScanSortColumn.ip);
      expect(p.sortAsc, isFalse);
      p.toggleSort(ScanSortColumn.ip);
      expect(p.sortAsc, isTrue);
    });

    test('toggleSort on new column selects it ascending', () {
      final p = ScanProvider();
      p.toggleSort(ScanSortColumn.ip); // now descending
      p.toggleSort(ScanSortColumn.mac);
      expect(p.sortColumn, ScanSortColumn.mac);
      expect(p.sortAsc, isTrue);
    });

    test('toggleSort notifies listeners', () {
      final p = ScanProvider();
      var notified = 0;
      p.addListener(() => notified++);
      p.toggleSort(ScanSortColumn.hostname);
      expect(notified, 1);
    });
  });

  group('ScanProvider results cache', () {
    test('starts empty', () {
      final p = ScanProvider();
      expect(p.results, isEmpty);
      expect(p.rawResults, isEmpty);
      expect(p.isScanning, isFalse);
    });

    test('hasValidResults is false with no results', () {
      final p = ScanProvider();
      p.setTarget('192.168.1.0/24');
      expect(p.hasValidResults('192.168.1.0/24'), isFalse);
    });

    test('clearCache empties results and notifies', () {
      final p = ScanProvider();
      var notified = 0;
      p.addListener(() => notified++);
      p.clearCache();
      expect(p.rawResults, isEmpty);
      expect(notified, 1);
    });

    test('rawResults is unmodifiable', () {
      final p = ScanProvider();
      expect(() => p.rawResults.clear(), throwsUnsupportedError);
    });
  });
}
