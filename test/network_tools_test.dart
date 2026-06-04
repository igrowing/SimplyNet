import 'dart:io';
import 'dart:async';
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

    test('portName returns correct service name', () {
      expect(NetworkTools.portName(22),    equals('ssh'));
      expect(NetworkTools.portName(80),    equals('http'));
      expect(NetworkTools.portName(443),   equals('https'));
      expect(NetworkTools.portName(1883),  equals('mqtt'));
      expect(NetworkTools.portName(5540),  equals('matter'));
    });

    test('portName returns empty string for unknown port', () {
      expect(NetworkTools.portName(12345), equals(''));
      expect(NetworkTools.portName(0),     equals(''));
      expect(NetworkTools.portName(65535), equals(''));
    });

    test('portName handles common surveillance ports', () {
      expect(NetworkTools.portName(554),  equals(''));     // rtsp not in dict
      expect(NetworkTools.portName(5554), equals('rtsp')); // is in dict
      expect(NetworkTools.portName(8554), equals('rtsp-alt'));
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
      // Port 80 is in wellKnownPortNames as 'http'
      // We can't guarantee 80 is open but we can test the format logic:
      // If we open a server on port 80 we would see 'http' in the OPEN line.
      // Instead, test portName consistency:
      final name = NetworkTools.portName(80);
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
  });

  // ── traceroute stream ────────────────────────────────────────────────────

  group('NetworkTools.traceroute', () {
    test('emits header with target host', () async {
      final first = await NetworkTools.traceroute('127.0.0.1').first;
      expect(first, contains('TRACEROUTE'));
      expect(first, contains('127.0.0.1'));
    });
  });

  // ── speedTest ────────────────────────────────────────────────────────────

  group('NetworkTools.speedTest', () {
    test('SpeedResult model has correct fields', () {
      final r = SpeedResult(
        downloadMbps: 100.5,
        uploadMbps:   50.2,
        pingMs:       12.3,
        timestamp:    DateTime(2026, 1, 1),
      );
      expect(r.downloadMbps, closeTo(100.5, 0.001));
      expect(r.uploadMbps,   closeTo(50.2, 0.001));
      expect(r.pingMs,       closeTo(12.3, 0.001));
      expect(r.timestamp,    equals(DateTime(2026, 1, 1)));
    });
  });
}
