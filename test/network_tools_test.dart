import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_tools.dart';

void main() {
  group('NetworkTools._portName (via portScan header)', () {
    // We test the port-name lookup indirectly by checking the commonPorts list
    // and that portScan emits an initial header line.
    test('commonPorts contains well-known ports', () {
      expect(NetworkTools.commonPorts, contains(22));   // ssh
      expect(NetworkTools.commonPorts, contains(80));   // http
      expect(NetworkTools.commonPorts, contains(443));  // https
      expect(NetworkTools.commonPorts, contains(3306)); // mysql
      expect(NetworkTools.commonPorts, contains(3389)); // rdp
    });

    test('commonPorts has no duplicates', () {
      final unique = NetworkTools.commonPorts.toSet();
      expect(unique.length, equals(NetworkTools.commonPorts.length));
    });

    test('portScan emits header as first event', () async {
      // Scan localhost with a single unlikely port — we only check the header
      final stream = NetworkTools.portScan('127.0.0.1', ports: []);
      final events = await stream.toList();
      expect(events.first, contains('PORT SCAN'));
    });

    test('ping emits header as first event', () async {
      final stream = NetworkTools.ping('127.0.0.1', count: 1);
      final first = await stream.first;
      expect(first, contains('PING'));
    });

    test('nslookup emits header as first event', () async {
      final stream = NetworkTools.nslookup('localhost');
      final first = await stream.first;
      expect(first, contains('NSLOOKUP'));
    });
  });
}
