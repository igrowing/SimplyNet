import 'dart:async';
import 'dart:io';

/// Wrappers for diagnostic network tools.
/// Each returns a Stream<String> so callers can display output progressively.
class NetworkTools {
  // ── Ping ───────────────────────────────────────────────────────────────────
  static Stream<String> ping(String host, {int count = 4}) async* {
    yield '=== PING $host ===\n';
    try {
      final proc = await Process.start('ping', ['-c', count.toString(), '-W', '2', host]);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      await proc.exitCode;
    } catch (e) {
      yield 'ping not available: $e\n';
      // Dart fallback: ICMP-ish via Socket
      yield* _dartPing(host, count);
    }
  }

  static Stream<String> _dartPing(String host, int count) async* {
    for (var i = 1; i <= count; i++) {
      try {
        final sw = Stopwatch()..start();
        final sock = await Socket.connect(host, 80,
            timeout: const Duration(seconds: 2));
        sock.destroy();
        sw.stop();
        yield 'Reply from $host: time=${sw.elapsedMilliseconds}ms\n';
      } catch (_) {
        yield 'Request timeout for $host\n';
      }
      if (i < count) await Future.delayed(const Duration(seconds: 1));
    }
  }

  // ── NSLookup ───────────────────────────────────────────────────────────────
  static Stream<String> nslookup(String host) async* {
    yield '=== NSLOOKUP $host ===\n';
    try {
      final addrs = await InternetAddress.lookup(host);
      for (final a in addrs) {
        yield 'Address : ${a.address}\n';
        yield 'Hostname: ${a.host}\n';
      }
    } catch (e) {
      yield 'Lookup failed: $e\n';
    }
    // Try system nslookup
    try {
      final proc = await Process.start('nslookup', [host]);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      await proc.exitCode;
    } catch (_) {}
  }

  // ── Traceroute ─────────────────────────────────────────────────────────────
  static Stream<String> traceroute(String host, {int maxHops = 30}) async* {
    yield '=== TRACEROUTE $host ===\n';
    final cmd = Platform.isWindows ? 'tracert' : 'traceroute';
    final args = Platform.isWindows
        ? ['-h', maxHops.toString(), host]
        : ['-m', maxHops.toString(), '-w', '2', host];
    try {
      final proc = await Process.start(cmd, args);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      await proc.exitCode;
    } catch (e) {
      yield 'traceroute not available: $e\n';
      yield* _dartTraceroute(host, maxHops);
    }
  }

  static Stream<String> _dartTraceroute(String host, int maxHops) async* {
    yield '(Fallback mode — TCP probe per hop)\n';
    try {
      final target = (await InternetAddress.lookup(host)).first;
      for (var ttl = 1; ttl <= maxHops; ttl++) {
        final sw = Stopwatch()..start();
        try {
          final sock = await Socket.connect(
            target.address, 80,
            timeout: const Duration(seconds: 2),
          );
          sock.destroy();
          sw.stop();
          yield '$ttl  ${target.address}  ${sw.elapsedMilliseconds}ms\n';
          break;
        } catch (_) {
          sw.stop();
          yield '$ttl  *  ${sw.elapsedMilliseconds}ms\n';
        }
      }
    } catch (e) {
      yield 'Error: $e\n';
    }
  }

  // ── Port Scan ──────────────────────────────────────────────────────────────
  static const commonPorts = [
    21, 22, 23, 25, 53, 80, 110, 143, 161, 443, 445, 465,
    587, 631, 993, 995, 1080, 1194, 1433, 1521, 1723, 2049,
    3306, 3389, 5432, 5900, 6379, 8080, 8443, 8888, 9200, 27017,
  ];

  static Stream<String> portScan(
    String host, {
    List<int> ports = commonPorts,
    void Function(int done, int total)? onProgress,
  }) async* {
    yield '=== PORT SCAN $host ===\n';
    final open = <int>[];
    for (var i = 0; i < ports.length; i++) {
      final port = ports[i];
      try {
        final sock = await Socket.connect(host, port,
            timeout: const Duration(milliseconds: 500));
        sock.destroy();
        open.add(port);
        yield 'OPEN  $port/tcp  ${_portName(port)}\n';
      } catch (_) {}
      onProgress?.call(i + 1, ports.length);
    }
    if (open.isEmpty) yield 'No open ports found.\n';
    yield '\nDone. ${open.length} open port(s) found.\n';
  }

  static String _portName(int port) => switch (port) {
        21 => 'ftp',
        22 => 'ssh',
        23 => 'telnet',
        25 => 'smtp',
        53 => 'dns',
        80 => 'http',
        110 => 'pop3',
        143 => 'imap',
        161 => 'snmp',
        443 => 'https',
        445 => 'smb',
        465 => 'smtps',
        587 => 'submission',
        631 => 'ipp',
        993 => 'imaps',
        995 => 'pop3s',
        1433 => 'mssql',
        1521 => 'oracle',
        2049 => 'nfs',
        3306 => 'mysql',
        3389 => 'rdp',
        5432 => 'postgresql',
        5900 => 'vnc',
        6379 => 'redis',
        8080 => 'http-alt',
        8443 => 'https-alt',
        9200 => 'elasticsearch',
        27017 => 'mongodb',
        1080 => 'socks',
        1194 => 'openvpn',
        1723 => 'pptp',
        8888 => 'http-alt2',
        _ => 'unknown',
      };
}
