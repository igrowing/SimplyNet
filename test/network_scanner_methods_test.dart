import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_scanner.dart';

/// Tests for the I/O-touching NetworkScanner methods.
///
/// These run against the loopback interface and RFC 5737 TEST-NET subnets
/// (reserved, guaranteed unroutable) so no real LAN traffic is generated.
///
/// Platform caveat: `readArpTable` branches on `Platform.isIOS` vs the
/// Android/Linux path, and `resolveHostname` shells out to `avahi-resolve` /
/// `nslookup`. A unit test on the Linux CI runner can only execute the
/// host-OS branch and whichever external binaries exist there. Exercising the
/// iOS `arp -a` branch (or the avahi path on a host without the daemon) would
/// require abstracting `Process.run`/`Platform` behind an injectable runner.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');

  setUp(() {
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
  group('NetworkScanner.readArpTable', () {
    test('returns an ip→mac map without throwing (host-OS branch)', () async {
      final table = await NetworkScanner.readArpTable();
      expect(table, isA<Map<String, String>>());
      // Every value that is present must be a 17-char colon-separated MAC.
      for (final mac in table.values) {
        expect(mac, matches(RegExp(r'^[0-9A-F:]{17}$')));
      }
    });
  });

  group('NetworkScanner.getSelfMacs', () {
    test('maps each local IPv4 interface address to a MAC string', () async {
      final selfMacs = await NetworkScanner.getSelfMacs();
      expect(selfMacs, isA<Map<String, String>>());
      // Keys are interface IPv4 addresses; values are MAC or the 'N/A' fallback
      // (the mac_address_plus plugin is unavailable under flutter_test).
      selfMacs.forEach((ip, mac) {
        expect(ip, matches(RegExp(r'^\d+\.\d+\.\d+\.\d+$')));
        expect(mac, isNotEmpty);
      });
    });
  });

  group('NetworkScanner.resolveHostname', () {
    test('returns a String for the loopback address (PTR approach)', () async {
      final name = await NetworkScanner.resolveHostname('127.0.0.1');
      expect(name, isA<String>());
    });

    test('returns empty when every approach fails for an unroutable IP',
        () async {
      // 198.51.100.50 is RFC 5737 TEST-NET-2: no PTR record, and the avahi /
      // nslookup fallbacks find nothing (or their binaries are absent), so all
      // three approaches fall through to the empty-string result.
      final name = await NetworkScanner.resolveHostname('198.51.100.50');
      expect(name, '');
    }, timeout: const Timeout(Duration(seconds: 15)));
  });

  group('NetworkScanner.hostsInCidr', () {
    test('returns empty for an invalid CIDR', () {
      expect(NetworkScanner.hostsInCidr('not-a-cidr'), isEmpty);
    });

    test('excludes network and broadcast addresses', () {
      // /30 has 4 addresses: .0 network, .1/.2 hosts, .3 broadcast.
      expect(NetworkScanner.hostsInCidr('192.0.2.0/30'),
          ['192.0.2.1', '192.0.2.2']);
    });
  });

  group('NetworkScanner.scan', () {
    test('yields nothing for an invalid CIDR', () async {
      final hosts = await NetworkScanner.scan('not-a-cidr').toList();
      expect(hosts, isEmpty);
    });

    test('discovers zero hosts on a tiny unroutable /30 subnet', () async {
      // 192.0.2.0/30 (RFC 5737 TEST-NET-1) expands to exactly two probe-able
      // addresses (.1 and .2). Neither answers, so the scan completes empty
      // without touching the real network.
      final hosts = await NetworkScanner.scan('192.0.2.0/30').toList();
      expect(hosts, isEmpty);
    }, timeout: const Timeout(Duration(seconds: 20)));
  });
}
