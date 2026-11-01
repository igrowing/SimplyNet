import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/host_result.dart';
import 'package:simply_net/services/iot_scanner.dart';
import 'package:simply_net/services/mdns_discovery.dart';

import 'support/fake_mdns_browser.dart';

MdnsServiceInstance svc(
  String type,
  String ip, {
  String host = '',
  int port = 5540,
}) => MdnsServiceInstance(
  serviceType: type,
  instance: 'dev',
  hostname: host,
  ip: ip,
  port: port,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');

  setUp(() {
    SharedPreferences.setMockInitialValues({});
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

  group('IotScanner.mergeMdnsHosts', () {
    test('fills an empty hostname from mDNS and marks the host up', () {
      final merged = IotScanner.mergeMdnsHosts(
        [HostResult(ip: '192.0.2.5', isUp: false)],
        MdnsDiscovery.groupByIp([
          svc('_matter._tcp', '192.0.2.5', host: 'plug-5.local'),
        ]),
      );
      expect(merged.single.hostname, 'plug-5.local');
      expect(merged.single.isUp, isTrue);
    });

    test('keeps a hostname the LAN scan already resolved', () {
      final merged = IotScanner.mergeMdnsHosts(
        [HostResult(ip: '192.0.2.5', hostname: 'ha.fritz.box')],
        MdnsDiscovery.groupByIp([
          svc('_matter._tcp', '192.0.2.5', host: 'other.local'),
        ]),
      );
      expect(merged.single.hostname, 'ha.fritz.box');
    });

    test('appends hosts that only mDNS knows', () {
      final merged = IotScanner.mergeMdnsHosts(
        [HostResult(ip: '192.0.2.5')],
        MdnsDiscovery.groupByIp([
          svc('_hap._tcp', '192.0.2.77', host: 'bridge.local'),
        ]),
      );
      expect(merged.map((h) => h.ip), ['192.0.2.5', '192.0.2.77']);
      expect(merged.last.hostname, 'bridge.local');
      expect(merged.last.isUp, isTrue);
    });

    test('leaves hosts without mDNS data untouched', () {
      final original = HostResult(ip: '192.0.2.5', hostname: 'x');
      final merged = IotScanner.mergeMdnsHosts([original], const {});
      expect(merged.single, same(original));
    });
  });

  group('IotScanner.scanHosts with mDNS', () {
    test(
      'a Matter device with no open port and no hostname is found',
      () async {
        final devices = await IotScanner.scanHosts(
          [HostResult(ip: '192.0.2.50')],
          mdns: FakeMdnsBrowser([
            svc('_matter._tcp', '192.0.2.50', host: 'node-7f3a.local'),
          ]),
        ).toList();
        expect(devices, hasLength(1));
        final d = devices.single;
        expect(d.protocol, 'Matter device');
        expect(d.confidence, IotConfidence.definite);
        expect(d.hostname, 'node-7f3a.local');
        expect(d.detectionMethod, contains('mDNS _matter._tcp'));
        expect(d.extra['mdns'], '_matter._tcp');
      },
    );

    test('a device missing from the host list is added from mDNS', () async {
      final devices = await IotScanner.scanHosts(
        [HostResult(ip: '192.0.2.50', hostname: 'desktop-pc')],
        mdns: FakeMdnsBrowser([
          svc('_esphomelib._tcp', '192.0.2.51', host: 'sensor.local'),
        ]),
      ).toList();
      expect(devices.map((d) => d.ip), ['192.0.2.51']);
      expect(devices.single.protocol, 'ESPHome');
    });

    test('several services on one host are all reported', () async {
      final devices = await IotScanner.scanHosts(
        [HostResult(ip: '192.0.2.50')],
        mdns: FakeMdnsBrowser([
          svc('_matter._tcp', '192.0.2.50'),
          svc('_hap._tcp', '192.0.2.50'),
        ]),
      ).toList();
      expect(devices.single.extra['mdns'], '_hap._tcp, _matter._tcp');
    });

    test(
      'an mDNS failure is reported and hostname detection still works',
      () async {
        final diagnostics = <String>[];
        final devices = await IotScanner.scanHosts(
          [HostResult(ip: '192.0.2.60', hostname: 'tasmota-1A2B3C')],
          mdns: FakeMdnsBrowser(const [], const MdnsException('port busy')),
          onDiagnostic: diagnostics.add,
        ).toList();
        expect(devices.single.protocol, 'Tasmota');
        expect(
          diagnostics.single,
          allOf(contains('mDNS'), contains('port busy')),
        );
      },
    );

    test('a successful browse reports how many hosts answered', () async {
      final diagnostics = <String>[];
      await IotScanner.scanHosts(
        [HostResult(ip: '192.0.2.50')],
        mdns: FakeMdnsBrowser([svc('_matter._tcp', '192.0.2.50')]),
        onDiagnostic: diagnostics.add,
      ).toList();
      expect(diagnostics.single, contains('mDNS'));
      expect(diagnostics.single, contains('1 host'));
    });

    test('without a browser mDNS is not used at all', () async {
      final devices = await IotScanner.scanHosts([
        HostResult(ip: '192.0.2.50'),
      ]).toList();
      expect(devices, isEmpty);
    });

    test('an empty host list still browses (mDNS-only networks)', () async {
      final fake = FakeMdnsBrowser([svc('_matter._tcp', '192.0.2.50')]);
      final devices = await IotScanner.scanHosts(const [], mdns: fake).toList();
      expect(fake.calls, 1);
      expect(devices.single.protocol, 'Matter device');
    });
  });

  group('IotScanner.scanSubnet with mDNS', () {
    test('devices announced over mDNS are found on the subnet scan', () async {
      final devices = await IotScanner.scanSubnet(
        '192.0.2.0/30',
        mdns: FakeMdnsBrowser([svc('_matter._tcp', '192.0.2.2')]),
      ).toList();
      expect(devices.map((d) => d.ip), ['192.0.2.2']);
    });
  });
}
