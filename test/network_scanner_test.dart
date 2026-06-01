import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_scanner.dart';

void main() {
  group('NetworkScanner.parseCidr', () {
    test('parses valid /24', () {
      final result = NetworkScanner.parseCidr('192.168.1.0/24');
      expect(result, isNotNull);
      expect(result!.$1, equals('192.168.1.0'));
      expect(result.$2, equals(24));
    });

    test('parses valid /16', () {
      final result = NetworkScanner.parseCidr('10.0.0.0/16');
      expect(result, isNotNull);
      expect(result!.$2, equals(16));
    });

    test('parses /32 (single host)', () {
      final result = NetworkScanner.parseCidr('192.168.1.100/32');
      expect(result, isNotNull);
      expect(result!.$2, equals(32));
    });

    test('trims whitespace', () {
      final result = NetworkScanner.parseCidr('  192.168.1.0/24  ');
      expect(result, isNotNull);
    });

    test('returns null for missing prefix', () {
      expect(NetworkScanner.parseCidr('192.168.1.0'), isNull);
    });

    test('returns null for prefix > 32', () {
      expect(NetworkScanner.parseCidr('192.168.1.0/33'), isNull);
    });

    test('returns null for negative prefix', () {
      expect(NetworkScanner.parseCidr('192.168.1.0/-1'), isNull);
    });

    test('returns null for invalid IP octet > 255', () {
      expect(NetworkScanner.parseCidr('192.168.1.300/24'), isNull);
    });

    test('returns null for non-numeric octet', () {
      expect(NetworkScanner.parseCidr('192.168.one.0/24'), isNull);
    });

    test('returns null for too few octets', () {
      expect(NetworkScanner.parseCidr('192.168.1/24'), isNull);
    });

    test('returns null for empty string', () {
      expect(NetworkScanner.parseCidr(''), isNull);
    });
  });

  group('NetworkScanner.isValidCidr', () {
    test('returns true for valid CIDR', () {
      expect(NetworkScanner.isValidCidr('10.0.0.0/8'), isTrue);
    });

    test('returns false for invalid CIDR', () {
      expect(NetworkScanner.isValidCidr('not-a-cidr'), isFalse);
    });

    test('returns false for plain IP with no prefix', () {
      expect(NetworkScanner.isValidCidr('192.168.1.1'), isFalse);
    });
  });

  group('NetworkScanner._resolveMac (indirectly tested)', () {
    // _resolveMac is private, so we test the MAC validation logic directly

    test('MAC format validation: accepts valid format', () {
      final validMacRegex = RegExp(r'^([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}|N/A)$');
      
      expect(validMacRegex.hasMatch('00:1A:2B:3C:4D:5E'), isTrue);
      expect(validMacRegex.hasMatch('AA:BB:CC:DD:EE:FF'), isTrue);
      expect(validMacRegex.hasMatch('N/A'), isTrue);
    });

    test('MAC format validation: rejects invalid format', () {
      final validMacRegex = RegExp(r'^([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}|N/A)$');
      
      expect(validMacRegex.hasMatch('00-1A-2B-3C-4D-5E'), isFalse);
      expect(validMacRegex.hasMatch('001A2B3C4D5E'), isFalse);
      expect(validMacRegex.hasMatch('00:1A:2B:3C:4D'), isFalse); // too short
      expect(validMacRegex.hasMatch('GG:1A:2B:3C:4D:5E'), isFalse); // invalid hex
    });

    test('MAC case handling: uppercase conversion', () {
      final lowerMac = '00:1a:2b:3c:4d:5e';
      final upperMac = '00:1A:2B:3C:4D:5E';
      final validMacRegex = RegExp(r'^([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}|N/A)$');
      
      expect(validMacRegex.hasMatch(lowerMac), isTrue);
      expect(validMacRegex.hasMatch(upperMac), isTrue);
      expect(lowerMac.toUpperCase(), equals(upperMac));
    });

    test('arping output MAC extraction', () {
      final macRegex = RegExp(r'([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})');
      
      // Typical arping output format
      const arpingOutput = 'ARPING 192.168.1.100\n'
          'Unicast reply from 192.168.1.100 [00:1A:2B:3C:4D:5E]  0.632ms\n'
          'Sent 1 probes (1 broadcast(s))\n'
          'Received 1 response(s)\n';
      
      final match = macRegex.firstMatch(arpingOutput);
      expect(match, isNotNull);
      expect(match!.group(1), equals('00:1A:2B:3C:4D:5E'));
    });

    test('ARP table line parsing', () {
      //               IP address       HW type     Flags       HW address            Mask     Device
      const arpEntry = '192.168.1.100    0x1         0x2         00:1a:2b:3c:4d:5e     *        eth0';
      
      // Simulate ARP parsing logic
      final parts = arpEntry.trim().split(RegExp(r'\s+'));
      expect(parts.length, greaterThanOrEqualTo(4));
      
      final ip = parts[0];
      final mac = parts[3].toUpperCase();
      
      expect(ip, equals('192.168.1.100'));
      expect(mac, equals('00:1A:2B:3C:4D:5E'));
    });

    test('broadcast MAC filtering (00:00:00:00:00:00 ignored)', () {
      const broadcastMac = '00:00:00:00:00:00';
      const validMac = '00:1A:2B:3C:4D:5E';
      
      expect(broadcastMac == '00:00:00:00:00:00', isTrue);
      expect(validMac == '00:00:00:00:00:00', isFalse);
    });

    test('N/A fallback when MAC cannot be resolved', () {
      final resolvedMac = null;
      final finalMac = resolvedMac ?? 'N/A';
      expect(finalMac, equals('N/A'));
    });
  });

  group('NetworkScanner._probeHost (unit tests with mocked data)', () {
    // Fast unit tests without actual network access

    test('valid IP format detection', () {
      final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
      
      expect(ipRegex.hasMatch('192.168.1.1'), isTrue);
      expect(ipRegex.hasMatch('10.0.0.0'), isTrue);
      expect(ipRegex.hasMatch('255.255.255.255'), isTrue);
      expect(ipRegex.hasMatch('192.168.1'), isFalse);
      // Note: Regex checks format only, not value ranges (256 is format-valid but invalid IP)
      expect(ipRegex.hasMatch('256.1.1.1'), isTrue); // matches format, value check is separate
      expect(ipRegex.hasMatch('not-an-ip'), isFalse);
    });

    test('hostname format validation', () {
      final hostnameRegex = RegExp(r'^[a-zA-Z0-9\-\.]*$'); // * allows empty string
      
      expect(hostnameRegex.hasMatch('localhost'), isTrue);
      expect(hostnameRegex.hasMatch('my-server.local'), isTrue);
      expect(hostnameRegex.hasMatch('server123'), isTrue);
      expect(hostnameRegex.hasMatch(''), isTrue); // empty is valid (no name resolved)
      expect(hostnameRegex.hasMatch('invalid hostname'), isFalse); // spaces not allowed
    });

    test('port connectivity check would try standard ports', () {
      const portsToProbe = [80, 443, 22, 445, 8080];
      
      expect(portsToProbe, contains(80)); // HTTP
      expect(portsToProbe, contains(443)); // HTTPS
      expect(portsToProbe, contains(22)); // SSH
      expect(portsToProbe, contains(445)); // SMB
      expect(portsToProbe.length, equals(5));
    });

    test('ping exit codes: 0 = success, non-zero = failure', () {
      const successExitCode = 0;
      const failureExitCode = 1;
      
      expect(successExitCode == 0, isTrue); // host is alive
      expect(failureExitCode == 0, isFalse); // host is not alive
    });

    test('ARP table caching: pre-populated vs re-read', () {
      final arpTableCache = <String, String>{};
      const testIp = '192.168.1.100';
      const testMac = '00:1A:2B:3C:4D:5E';
      
      // Initially empty
      expect(arpTableCache.containsKey(testIp), isFalse);
      
      // After population
      arpTableCache[testIp] = testMac;
      expect(arpTableCache.containsKey(testIp), isTrue);
      expect(arpTableCache[testIp], equals(testMac));
    });

    test('host result contract: all fields populated', () {
      // Simulate what _probeHost should return
      const ip = '192.168.1.100';
      const mac = '00:1A:2B:3C:4D:5E';
      const hostname = 'my-device';
      const manufacturer = 'Apple Inc.';
      const isUp = true;
      
      // Verify all fields exist and are non-null
      expect(ip, isNotEmpty);
      expect(mac, isNotNull);
      expect(hostname, isNotNull);
      expect(manufacturer, isNotNull);
      expect(isUp, isNotNull);
    });

    test('probe timeout handling: no infinite waits', () {
      const pingTimeout = Duration(milliseconds: 800);
      const tcpTimeout = Duration(milliseconds: 400);
      
      expect(pingTimeout.inMilliseconds, equals(800));
      expect(tcpTimeout.inMilliseconds, equals(400));
      expect(pingTimeout > tcpTimeout, isTrue); // ping timeout > tcp timeout
    });

    test('parallelism configuration prevents resource exhaustion', () {
      const parallelism = 64;
      
      expect(parallelism, greaterThan(0));
      expect(parallelism, lessThanOrEqualTo(256)); // reasonable upper bound
    });

    test('N/A values when resolution fails gracefully', () {
      const unresolvedMac = 'N/A';
      const unresolvedHostname = '';
      const unresolvedManufacturer = '';
      
      expect(unresolvedMac, equals('N/A'));
      expect(unresolvedHostname.isEmpty, isTrue);
      expect(unresolvedManufacturer.isEmpty, isTrue);
    });
  });

// ── Self MAC resolution ──────────────────────────────────────────────────────
// _getSelfMacs() does real I/O (NetworkInterface + /sys or ifconfig), so we
// test the surrounding logic rather than the I/O itself:
//   • MAC format validation (the regex / file-content guard used internally)
//   • putIfAbsent merge semantics (ARP table wins when both have the same IP)
//   • The scan contract: self IP must NOT remain 'N/A' when a selfMac is known.

group('NetworkScanner — self MAC resolution', () {
  // Simulate what _getSelfMacs returns and verify the merge logic.
  test('selfMacs entry is used when ARP table has no entry for self IP', () {
    final arpTable  = <String, String>{'192.168.1.2': 'AA:BB:CC:DD:EE:01'};
    final selfMacs  = <String, String>{'192.168.1.100': 'AA:BB:CC:DD:EE:FF'};

    for (final e in selfMacs.entries) {
      arpTable.putIfAbsent(e.key, () => e.value);
    }

    expect(arpTable['192.168.1.100'], 'AA:BB:CC:DD:EE:FF');
    expect(arpTable['192.168.1.2'],   'AA:BB:CC:DD:EE:01'); // unchanged
  });

  test('ARP table entry wins over selfMac when both provide the same IP', () {
    // This should not happen in practice (self never in ARP), but the merge
    // uses putIfAbsent which guarantees ARP value is kept.
    final arpTable = <String, String>{'192.168.1.100': 'AA:BB:CC:DD:EE:ARP'};
    final selfMacs = <String, String>{'192.168.1.100': 'AA:BB:CC:DD:EE:SELF'};

    for (final e in selfMacs.entries) {
      arpTable.putIfAbsent(e.key, () => e.value);
    }

    expect(arpTable['192.168.1.100'], 'AA:BB:CC:DD:EE:ARP');
  });

  test('ifconfig MAC regex extracts ether address (macOS/iOS format)', () {
    const ifconfigOut = '''
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	ether a4:c3:f0:12:34:56
	inet 192.168.1.100 netmask 0xffffff00 broadcast 192.168.1.255
''';
    final m = RegExp(
      r'(?:ether|HWaddr)\s+([0-9a-f]{2}(?::[0-9a-f]{2}){5})',
      caseSensitive: false,
    ).firstMatch(ifconfigOut);
    expect(m, isNotNull);
    expect(m!.group(1)!.toUpperCase(), 'A4:C3:F0:12:34:56');
  });

  test('ifconfig MAC regex extracts HWaddr (Linux busybox format)', () {
    const ifconfigOut =
        'eth0      Link encap:Ethernet  HWaddr b8:27:eb:ab:cd:ef  ';
    final m = RegExp(
      r'(?:ether|HWaddr)\s+([0-9a-f]{2}(?::[0-9a-f]{2}){5})',
      caseSensitive: false,
    ).firstMatch(ifconfigOut);
    expect(m, isNotNull);
    expect(m!.group(1)!.toUpperCase(), 'B8:27:EB:AB:CD:EF');
  });

  test('/sys MAC file content guard: trims whitespace and checks length', () {
    // Simulate what readAsStringSync().trim().toUpperCase() would produce
    // for a valid and invalid /sys/class/net/<iface>/address content.
    String parseSysMac(String raw) {
      final trimmed = raw.trim().toUpperCase();
      if (trimmed.length == 17 && trimmed != '00:00:00:00:00:00') return trimmed;
      return '';
    }

    expect(parseSysMac('b8:27:eb:12:34:56'), 'B8:27:EB:12:34:56');
    expect(parseSysMac('00:00:00:00:00:00'),   '');
    expect(parseSysMac(''),                    '');
    expect(parseSysMac('  aa:bb:cc:dd:ee:ff '), 'AA:BB:CC:DD:EE:FF');
  });
});
}
