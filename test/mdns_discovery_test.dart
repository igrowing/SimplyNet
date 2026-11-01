import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:simply_net/constants/iot_signatures.dart';
import 'package:simply_net/services/mdns_discovery.dart';
import 'package:simply_net/services/multicast_lock.dart';

import 'support/fake_mdns_browser.dart';

MdnsServiceInstance svc(
  String type,
  String ip, {
  String host = '',
  String instance = 'dev',
  int port = 5540,
}) => MdnsServiceInstance(
  serviceType: type,
  instance: instance,
  hostname: host,
  ip: ip,
  port: port,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MdnsDiscovery.serviceTypes', () {
    test('browses Matter operational and commissionable services', () {
      expect(MdnsDiscovery.serviceTypes, contains('_matter._tcp'));
      expect(MdnsDiscovery.serviceTypes, contains('_matterc._udp'));
    });

    test('is exactly the catalogue of identifying services', () {
      expect(
        MdnsDiscovery.serviceTypes.toSet(),
        IotSignatures.mdnsServices.keys.toSet(),
      );
    });

    test('every type has the _name._tcp / _name._udp form', () {
      for (final t in MdnsDiscovery.serviceTypes) {
        expect(t, matches(RegExp(r'^_[a-z0-9-]+\._(tcp|udp)$')), reason: t);
      }
    });
  });

  group('MdnsDiscovery.normalizeHostname', () {
    test('strips the trailing dot of an FQDN', () {
      expect(
        MdnsDiscovery.normalizeHostname('ESP-E286C2.local.'),
        'ESP-E286C2.local',
      );
    });

    test('leaves a name without a trailing dot alone', () {
      expect(MdnsDiscovery.normalizeHostname('plug.local'), 'plug.local');
    });

    test('empty stays empty', () {
      expect(MdnsDiscovery.normalizeHostname(''), '');
    });
  });

  group('MdnsDiscovery.instanceName', () {
    test('removes the service type and domain', () {
      expect(
        MdnsDiscovery.instanceName(
          'Living Room Plug._matter._tcp.local',
          '_matter._tcp',
        ),
        'Living Room Plug',
      );
    });

    test('tolerates a trailing dot', () {
      expect(
        MdnsDiscovery.instanceName('abc._hap._tcp.local.', '_hap._tcp'),
        'abc',
      );
    });

    test('returns the name unchanged when the type does not match', () {
      expect(MdnsDiscovery.instanceName('weird', '_hap._tcp'), 'weird');
    });
  });

  group('MdnsDiscovery.groupByIp', () {
    test('merges services of one address and keeps the hostname', () {
      final hosts = MdnsDiscovery.groupByIp([
        svc('_matter._tcp', '192.168.1.5', host: 'plug-1.local'),
        svc('_hap._tcp', '192.168.1.5'),
      ]);
      expect(hosts.keys, ['192.168.1.5']);
      expect(hosts['192.168.1.5']!.serviceTypes, {'_matter._tcp', '_hap._tcp'});
      expect(hosts['192.168.1.5']!.hostname, 'plug-1.local');
    });

    test('keeps separate addresses apart', () {
      final hosts = MdnsDiscovery.groupByIp([
        svc('_matter._tcp', '192.168.1.5'),
        svc('_esphomelib._tcp', '192.168.1.6'),
      ]);
      expect(hosts.keys.toSet(), {'192.168.1.5', '192.168.1.6'});
      expect(hosts['192.168.1.6']!.serviceTypes, {'_esphomelib._tcp'});
    });

    test('the first non-empty hostname wins', () {
      final hosts = MdnsDiscovery.groupByIp([
        svc('_hap._tcp', '10.0.0.2'),
        svc('_matter._tcp', '10.0.0.2', host: 'a.local'),
        svc('_hue._tcp', '10.0.0.2', host: 'b.local'),
      ]);
      expect(hosts['10.0.0.2']!.hostname, 'a.local');
    });

    test('empty input gives an empty map', () {
      expect(MdnsDiscovery.groupByIp(const []), isEmpty);
    });
  });

  group('MdnsDiscovery.browseHosts', () {
    test('asks the browser for every catalogue service type', () async {
      final fake = FakeMdnsBrowser();
      await MdnsDiscovery(fake).browseHosts();
      expect(fake.requestedTypes, MdnsDiscovery.serviceTypes);
    });

    test('groups what the browser found by address', () async {
      final hosts = await MdnsDiscovery(
        FakeMdnsBrowser([svc('_matter._tcp', '192.168.1.9')]),
      ).browseHosts();
      expect(hosts['192.168.1.9']!.serviceTypes, {'_matter._tcp'});
    });

    test('lets an MdnsException through', () {
      expect(
        MdnsDiscovery(
          FakeMdnsBrowser(const [], const MdnsException('port busy')),
        ).browseHosts(),
        throwsA(isA<MdnsException>()),
      );
    });
  });

  // dart:io raises a bare OSError (not a SocketException) when the platform
  // cannot join the multicast group, e.g. `reusePort` on Windows (10042).
  group('MulticastDnsBrowser failures', () {
    const channel = MethodChannel('simplynet/multicast');

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    MulticastDnsBrowser failingWith(Object error) => MulticastDnsBrowser(
      clientFactory: () => MDnsClient(
        rawDatagramSocketFactory:
            (
              dynamic host,
              int port, {
              bool reuseAddress = true,
              bool reusePort = true,
              int ttl = 1,
            }) async => throw error,
      ),
    );

    test('an OSError while opening the socket becomes an MdnsException', () {
      expect(
        failingWith(
          const OSError('option not supported', 10042),
        ).browse(['_matter._tcp']),
        throwsA(
          isA<MdnsException>().having(
            (e) => e.message,
            'message',
            contains('10042'),
          ),
        ),
      );
    });

    test('a SocketException becomes an MdnsException', () {
      expect(
        failingWith(
          const SocketException('bind failed'),
        ).browse(['_matter._tcp']),
        throwsA(isA<MdnsException>()),
      );
    });

    test('the multicast lock is released after a failure', () async {
      final calls = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            return true;
          });
      await expectLater(
        failingWith(const OSError('nope', 1)).browse(['_matter._tcp']),
        throwsA(isA<MdnsException>()),
      );
      expect(calls, ['acquire', 'release']);
    });
  });

  group('MulticastLock', () {
    const channel = MethodChannel('simplynet/multicast');

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('is a no-op off Android (no native handler)', () async {
      expect(await MulticastLock.acquire(), isFalse);
      await MulticastLock.release();
    });

    test('acquire and release reach the native side', () async {
      final calls = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            return true;
          });
      expect(await MulticastLock.acquire(), isTrue);
      await MulticastLock.release();
      expect(calls, ['acquire', 'release']);
    });

    test('a native failure becomes an MdnsException', () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(code: 'LOCK', message: 'denied');
          });
      expect(MulticastLock.acquire(), throwsA(isA<MdnsException>()));
    });
  });
}
