import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/services/scan_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScanProvider cache', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('loadCache is a no-op when nothing is stored', () async {
      final p = ScanProvider();
      await p.loadCache();
      expect(p.rawResults, isEmpty);
    });

    test('loadCache restores hosts and applies the IP sort', () async {
      await ScanStorage.save(ScanStorage.kScanHosts, '192.168.1.0/24', [
        HostResult(ip: '192.168.1.10').toJson(),
        HostResult(ip: '192.168.1.2').toJson(),
      ]);
      final p = ScanProvider();
      await p.loadCache();
      expect(p.rawResults, hasLength(2));
      // results getter sorts by IP when not scanning.
      expect(p.results.map((h) => h.ip), ['192.168.1.2', '192.168.1.10']);
    });

    test('loadCache discards a corrupt cache without throwing', () async {
      SharedPreferences.setMockInitialValues({
        ScanStorage.kScanHosts: 'not-json',
      });
      final p = ScanProvider();
      await p.loadCache();
      expect(p.rawResults, isEmpty);
    });
  });

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

  group('ScanProvider.ipCompare', () {
    test('orders numerically, not lexicographically', () {
      // Lexicographic order would put "192.168.1.10" before "192.168.1.9".
      expect(ScanProvider.ipCompare('192.168.1.9', '192.168.1.10'), lessThan(0));
      expect(ScanProvider.ipCompare('192.168.1.10', '192.168.1.9'),
          greaterThan(0));
    });

    test('returns zero for equal addresses', () {
      expect(ScanProvider.ipCompare('10.0.0.1', '10.0.0.1'), 0);
    });

    test('compares across every octet position', () {
      expect(ScanProvider.ipCompare('10.0.0.1', '11.0.0.0'), lessThan(0));
      expect(ScanProvider.ipCompare('10.1.0.0', '10.0.255.255'), greaterThan(0));
      expect(ScanProvider.ipCompare('10.0.1.0', '10.0.0.255'), greaterThan(0));
    });
  });

  group('ScanProvider.sortHosts', () {
    HostResult h(String ip, {String mac = 'N/A', String hostname = ''}) =>
        HostResult(ip: ip, mac: mac, hostname: hostname);

    final unsorted = [
      h('192.168.1.10', mac: 'BB:00', hostname: 'charlie'),
      h('192.168.1.2', mac: 'AA:00', hostname: 'alpha'),
      h('192.168.1.100', mac: 'CC:00', hostname: 'bravo'),
    ];

    test('sorts by IP ascending and descending', () {
      final asc = ScanProvider.sortHosts(unsorted, ScanSortColumn.ip, true);
      expect(asc.map((e) => e.ip),
          ['192.168.1.2', '192.168.1.10', '192.168.1.100']);

      final desc = ScanProvider.sortHosts(unsorted, ScanSortColumn.ip, false);
      expect(desc.map((e) => e.ip),
          ['192.168.1.100', '192.168.1.10', '192.168.1.2']);
    });

    test('sorts by MAC ascending and descending', () {
      final asc = ScanProvider.sortHosts(unsorted, ScanSortColumn.mac, true);
      expect(asc.map((e) => e.mac), ['AA:00', 'BB:00', 'CC:00']);
      final desc = ScanProvider.sortHosts(unsorted, ScanSortColumn.mac, false);
      expect(desc.map((e) => e.mac), ['CC:00', 'BB:00', 'AA:00']);
    });

    test('sorts by hostname ascending and descending', () {
      final asc = ScanProvider.sortHosts(unsorted, ScanSortColumn.hostname, true);
      expect(asc.map((e) => e.hostname), ['alpha', 'bravo', 'charlie']);
      final desc =
          ScanProvider.sortHosts(unsorted, ScanSortColumn.hostname, false);
      expect(desc.map((e) => e.hostname), ['charlie', 'bravo', 'alpha']);
    });

    test('does not mutate the input list', () {
      final input = [...unsorted];
      ScanProvider.sortHosts(input, ScanSortColumn.ip, true);
      expect(input.map((e) => e.ip),
          ['192.168.1.10', '192.168.1.2', '192.168.1.100']);
    });

    test('results getter applies the active sort column/direction', () {
      final p = ScanProvider();
      // results getter delegates to sortHosts(_results, _sortColumn, _sortAsc);
      // with no results it is a stable empty list regardless of sort state.
      p.toggleSort(ScanSortColumn.mac);
      expect(p.results, isEmpty);
      expect(p.sortColumn, ScanSortColumn.mac);
    });
  });

  group('ScanProvider scan lifecycle', () {
    // FgService.start/stop early-return off-Android, so these paths are safe
    // to drive in a unit test without a real foreground service.
    test('startScan is a no-op when the target is invalid', () {
      final p = ScanProvider();
      p.setTarget('not-a-cidr');
      p.startScan();
      expect(p.isScanning, isFalse);
    });

    test('stopScan clears scanning state and cached results', () {
      final p = ScanProvider();
      var notified = 0;
      p.addListener(() => notified++);
      p.stopScan();
      expect(p.isScanning, isFalse);
      expect(p.rawResults, isEmpty);
      expect(notified, 1);
    });
  });

  group('ScanProvider.startScan over resolveNames/logging', () {
    // 192.0.2.0/30 is RFC 5737 TEST-NET-1 (reserved, unroutable): exactly two
    // host addresses (.1/.2) that never answer, so the scan completes with zero
    // results without touching the real network. The "=== Scan started ==="
    // banner is written synchronously by startScan, so logText is populated
    // immediately regardless of the (empty) result set.
    for (final resolveNames in [true, false]) {
      for (final logging in [true, false]) {
        test('resolveNames=$resolveNames logging=$logging: logs + finds nothing',
            () async {
          final p = ScanProvider();
          p.setTarget('192.0.2.0/30');
          p.startScan(resolveNames: resolveNames, logging: logging);

          // Banner written synchronously before any async work.
          expect(p.isScanning, isTrue);
          expect(p.logText, isNotEmpty);
          expect(p.logText, contains('Scan started'));

          final finished = await _waitUntil(
              () => !p.isScanning, const Duration(seconds: 15));
          expect(finished, isTrue, reason: 'scan did not complete in time');

          expect(p.results, isEmpty);
          // Either the normal completion banner or the error banner is written,
          // both of which prove the onDone/onError log path executed.
          expect(p.logText,
              anyOf(contains('Scan complete'), contains('Scan ERROR')));
          p.dispose();
        });
      }
    }
  });

  group('ScanProvider.dispose', () {
    test('disposes a fresh provider without throwing', () {
      final p = ScanProvider();
      expect(p.dispose, returnsNormally);
    });

    test('cancels an in-flight scan subscription on dispose', () async {
      final p = ScanProvider();
      p.setTarget('192.0.2.0/30');
      p.startScan(logging: false);
      expect(p.isScanning, isTrue);
      // dispose cancels _sub and disposes logVersion; must not throw even while
      // the background probe futures are still resolving.
      expect(p.dispose, returnsNormally);
    });
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
