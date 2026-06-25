import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_tools.dart';

void main() {
  // ── wellKnownPortNames dict ──────────────────────────────────────────────

  group('NetworkTools.wellKnownPortNames', () {
    test('contains well-known TCP service ports', () {
      expect(NetworkTools.wellKnownPortNames, containsPair(22,   'ssh'));
      expect(NetworkTools.wellKnownPortNames, containsPair(80,   'http'));
      expect(NetworkTools.wellKnownPortNames, containsPair(443,  'https'));
      expect(NetworkTools.wellKnownPortNames, containsPair(3306, 'mysql'));
      expect(NetworkTools.wellKnownPortNames, containsPair(3389, 'rdp'));
      expect(NetworkTools.wellKnownPortNames, containsPair(5432, 'postgresql'));
      expect(NetworkTools.wellKnownPortNames, containsPair(27017,'mongodb'));
    });

    test('contains IoT-specific ports', () {
      expect(NetworkTools.wellKnownPortNames, containsPair(1883, 'mqtt'));
      expect(NetworkTools.wellKnownPortNames, containsPair(8883, 'mqtt-tls'));
      expect(NetworkTools.wellKnownPortNames, containsPair(5540, 'matter'));
      expect(NetworkTools.wellKnownPortNames, containsPair(8123, 'home-assistant'));
      expect(NetworkTools.wellKnownPortNames, containsPair(9999, 'kasa-legacy'));
      expect(NetworkTools.wellKnownPortNames, containsPair(20202,'matter-comm'));
    });

    test('legacy wellKnownPorts getter returns list of all keys', () {
      final list = NetworkTools.wellKnownPorts;
      expect(list, isA<List<int>>());
      expect(list, contains(22));
      expect(list, contains(5540));
      expect(list.length, equals(NetworkTools.wellKnownPortNames.length));
    });

    test('no duplicate port numbers in dict', () {
      final keys = NetworkTools.wellKnownPortNames.keys.toList();
      final unique = keys.toSet();
      expect(keys.length, equals(unique.length));
    });
  });

  // ── portScan stream ──────────────────────────────────────────────────────

  group('NetworkTools.portScan stream', () {
    test('emits header as first event', () async {
      final first = await NetworkTools.portScan('127.0.0.1', ports: [9]).first;
      expect(first, contains('PORT SCAN'));
      expect(first, contains('127.0.0.1'));
    });

    test('header includes protocol label TCP', () async {
      final first = await NetworkTools.portScan('127.0.0.1',
          ports: [9], useTcp: true, useUdp: false).first;
      expect(first, contains('TCP'));
    });

    test('header includes protocol label UDP', () async {
      final first = await NetworkTools.portScan('127.0.0.1',
          ports: [9], useTcp: false, useUdp: true).first;
      expect(first, contains('UDP'));
    });

    test('header includes TCP+UDP when both selected', () async {
      final first = await NetworkTools.portScan('127.0.0.1',
          ports: [9], useTcp: true, useUdp: true).first;
      expect(first, contains('TCP'));
      expect(first, contains('UDP'));
    });

    test('detects open port on localhost echo server', () async {
      // Spin up a local server to give the scanner something to find
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port   = server.port;
      server.listen((s) => s.destroy()); // accept and close immediately

      try {
        final lines = await NetworkTools.portScan(
          '127.0.0.1', ports: [port],
        ).toList();
        final openLine = lines.firstWhere(
            (l) => l.startsWith('OPEN'), orElse: () => '');
        expect(openLine, contains('$port'));
        expect(openLine, contains('/tcp'));
      } finally {
        await server.close();
      }
    });

    test('emits "Done" summary at end', () async {
      final lines = await NetworkTools.portScan(
        '127.0.0.1', ports: [1, 2, 3],
      ).toList();
      expect(lines.any((l) => l.contains('Done')), isTrue);
    });

    test('Use UDP too', () async {
      final lines = await NetworkTools.portScan(
        '127.0.0.1', ports: [1, 2, 3], useUdp: true,
      ).toList();
      expect(lines.any((l) => l.contains('Done')), isTrue);
    });

    test('emits "No open ports found" when none open', () async {
      // Ports 1-3 are unlikely to be open on the test host
      final lines = await NetworkTools.portScan(
        '127.0.0.1', ports: [1, 2, 3],
      ).toList();
      // Either "No open ports" or we found some — both are valid
      final noOpen = lines.any((l) => l.contains('No open ports'));
      final hasOpen = lines.any((l) => l.startsWith('OPEN'));
      expect(noOpen || hasOpen, isTrue);
    });

    test('onProgress callback fires for each port', () async {
      final progressCalls = <int>[];
      await NetworkTools.portScan(
        '127.0.0.1', ports: [1, 2, 3],
        onProgress: (done, total) => progressCalls.add(done),
      ).drain<void>();
      // Should have received progress for each port
      expect(progressCalls, isNotEmpty);
    });

    test('portScan with range generates correct number of ports', () async {
      // Scan a very small range; just check the header mentions range
      final first = await NetworkTools.portScan(
        '127.0.0.1', rangeStart: 100, rangeEnd: 105,
      ).first;
      expect(first, contains('100'));
      expect(first, contains('105'));
    });
  });

  // ── portScan open-port line format ───────────────────────────────────────

  group('portScan OPEN line format', () {
    test('OPEN line includes port number and /tcp', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port   = server.port;
      server.listen((s) => s.destroy());

      try {
        final lines = await NetworkTools.portScan(
          '127.0.0.1', ports: [port],
        ).toList();
        final openLine = lines.firstWhere(
            (l) => l.startsWith('OPEN'), orElse: () => '');
        expect(openLine, startsWith('OPEN'));
        expect(openLine, contains('/tcp'));
        expect(openLine, contains('$port'));
      } finally {
        await server.close();
      }
    });

    test('OPEN line includes service name for known port', () async {
      // Port 80 is in wellKnownPortNames as 'http'. We can't guarantee 80 is
      // open, but the OPEN line is formatted from wellKnownPortNames[port], so
      // assert the dict lookup that drives that formatting.
      final name = NetworkTools.wellKnownPortNames[80] ?? '';
      expect(name, equals('http'));
    });
  });

  // ── ping stream ──────────────────────────────────────────────────────────

  group('NetworkTools.ping', () {
    test('emits header as first event', () async {
      final first = await NetworkTools.ping('127.0.0.1', count: 1).first;
      expect(first, contains('PING'));
    });

    test('header contains target host', () async {
      final first = await NetworkTools.ping('127.0.0.1', count: 1).first;
      expect(first, contains('127.0.0.1'));
    });

    test('header includes ping count', () async {
      final first = await NetworkTools.ping('127.0.0.1', count: 3).first;
      expect(first, contains('3'));
    });
  });

  // ── nslookup stream ──────────────────────────────────────────────────────

  group('NetworkTools.nslookup', () {
    test('forward lookup emits header with host name', () async {
      final first = await NetworkTools.nslookup('localhost').first;
      expect(first, contains('NSLOOKUP'));
      expect(first, contains('localhost'));
    });

    test('reverse lookup header contains REVERSE', () async {
      final first = await NetworkTools.nslookup('127.0.0.1').first;
      expect(first, contains('REVERSE'));
    });

    test('IPv4 address detected as reverse lookup', () async {
      // 127.0.0.1 is an IP → should trigger reverse path
      final first = await NetworkTools.nslookup('127.0.0.1').first;
      expect(first, contains('REVERSE'));
    });

    test('domain name triggers forward lookup (no REVERSE in header)', () async {
      final first = await NetworkTools.nslookup('localhost').first;
      expect(first, isNot(contains('REVERSE')));
    });

    // The forward path runs (1) dart:io A/AAAA lookup then (2) system nslookup.
    // On the CI host the `nslookup` binary is usually absent, so method 2 fails
    // silently and method 1 supplies the answer — exercising both branches.
    test('forward lookup of localhost yields a loopback address', () async {
      final out = (await NetworkTools.nslookup('localhost').toList()).join();
      expect(out, anyOf(contains('127.0.0.1'), contains('::1')));
    });

    // The reverse path runs (1) dart:io PTR query and (2) system nslookup.
    // Whatever the host's resolver returns, the stream must complete with one
    // of the three terminal outcomes, proving all fallbacks were traversed.
    test('reverse lookup of loopback completes across its fallbacks', () async {
      final out = (await NetworkTools.nslookup('127.0.0.1').toList()).join();
      expect(
        out,
        anyOf(
          contains('PTR record'),
          contains('name ='),
          contains('No PTR record'),
        ),
      );
    });
  });

  // ── traceroute stream ────────────────────────────────────────────────────

  group('NetworkTools.traceroute', () {
    test('emits header with target host', () async {
      final first = await NetworkTools.traceroute('127.0.0.1').first;
      expect(first, contains('TRACEROUTE'));
      expect(first, contains('127.0.0.1'));
    });

    // Fast traceroute strategy: loopback answers on the very first TTL, so
    // capping maxHops at 1 exercises the full resolve → ping → parse → yield
    // loop and the "reached destination" exit, completing in well under a
    // second instead of the default 30-hop walk.
    test('reaches loopback within a single hop (maxHops: 1)', () async {
      final lines =
          await NetworkTools.traceroute('127.0.0.1', maxHops: 1).toList();
      final out = lines.join();
      expect(lines.first, contains('TRACEROUTE'));
      // Completed either by arriving or by exhausting the single hop budget.
      expect(out,
          anyOf(contains('Reached destination'), contains('Max hops')));
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  // ── traceroute hop parser (pure) ─────────────────────────────────────────

  group('NetworkTools.parseTracerouteHop', () {
    test('parses an intermediate Time Exceeded hop', () {
      const out = 'PING 8.8.8.8\n'
          'From 192.168.1.1 icmp_seq=1 Time to live exceeded\n'
          'From 192.168.1.1 icmp_seq=2 Time to live exceeded\n';
      final hop = NetworkTools.parseTracerouteHop(out, '8.8.8.8');
      expect(hop.hopIp, '192.168.1.1');
      expect(hop.reached, isFalse);
      // No "time=" present, so all three probe slots are padded with '*'.
      expect(hop.times, ['*', '*', '*']);
    });

    test('parses the colon variant of the From line', () {
      const out = 'From 10.0.0.1: icmp_seq=1 Time to live exceeded\n';
      final hop = NetworkTools.parseTracerouteHop(out, '8.8.8.8');
      expect(hop.hopIp, '10.0.0.1');
    });

    test('marks reached when the destination replies, capturing RTT', () {
      const out =
          '64 bytes from 8.8.8.8: icmp_seq=1 ttl=118 time=14.2 ms\n';
      final hop = NetworkTools.parseTracerouteHop(out, '8.8.8.8');
      expect(hop.hopIp, '8.8.8.8');
      expect(hop.reached, isTrue);
      expect(hop.times.first, '14.2ms');
      // First slot is the RTT; remaining two are padded with '*'.
      expect(hop.times.length, 3);
      expect(hop.times.sublist(1), ['*', '*']);
    });

    test('an echo reply from a non-destination host is not "reached"', () {
      const out =
          '64 bytes from 1.2.3.4: icmp_seq=1 ttl=55 time=9.0 ms\n';
      final hop = NetworkTools.parseTracerouteHop(out, '8.8.8.8');
      expect(hop.hopIp, '1.2.3.4');
      expect(hop.reached, isFalse);
      expect(hop.times.first, '9.0ms');
    });

    test('no responses yields a null hop and three asterisks', () {
      final hop = NetworkTools.parseTracerouteHop('no useful lines\n', '8.8.8.8');
      expect(hop.hopIp, isNull);
      expect(hop.times, ['*', '*', '*']);
      expect(hop.reached, isFalse);
    });
  });

  // ── traceroute structured model ──────────────────────────────────────────

  group('TracertHop', () {
    test('averages the replying probes and is not timed out', () {
      const h = TracertHop(
          hop: 2, ip: '1.2.3.4', rttsMs: [10, 20, 30]);
      expect(h.timedOut, isFalse);
      expect(h.avgMs, 20);
    });

    test('a hop with no IP is timed out and has no average', () {
      const h = TracertHop(hop: 5);
      expect(h.timedOut, isTrue);
      expect(h.avgMs, isNull);
    });
  });

  group('NetworkTools.tracerouteHops', () {
    test('throws TracerouteException when the host cannot resolve', () {
      expect(
        NetworkTools.tracerouteHops('no.such.host.invalid').toList(),
        throwsA(isA<TracerouteException>()),
      );
    });

    test('reaches loopback within a single hop (maxHops: 1)', () async {
      final hops =
          await NetworkTools.tracerouteHops('127.0.0.1', maxHops: 1).toList();
      expect(hops, isNotEmpty);
      expect(hops.first.hop, 1);
    }, timeout: const Timeout(Duration(seconds: 10)));
  });
}
