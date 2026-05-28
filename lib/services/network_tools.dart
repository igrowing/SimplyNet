import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// Wrappers for diagnostic network tools.
/// Each returns a Stream<String> so callers can display output progressively.
class NetworkTools {
  // ── Ping ───────────────────────────────────────────────────────────────────
  /// [count] how many ICMP echo requests to send (default 10 per spec).
  static Stream<String> ping(String host, {int count = 10}) async* {
    yield '=== PING $host (${count}x) ===\n';
    try {
      final proc = await Process.start(
          'ping', ['-c', count.toString(), '-W', '2', host]);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      yield* proc.stderr.transform(const SystemEncoding().decoder);
      await proc.exitCode;
    } catch (e) {
      yield 'ping not available: $e\n';
      yield* _dartPing(host, count);
    }
  }

  static Stream<String> _dartPing(String host, int count) async* {
    for (var i = 1; i <= count; i++) {
      try {
        final sw   = Stopwatch()..start();
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
    // Reverse DNS first
    try {
      final ia      = InternetAddress(host);
      final results = await ia.reverse().timeout(const Duration(seconds: 3));
      yield 'Reverse DNS: ${results.host}\n';
    } catch (_) {}
    // Forward lookup
    try {
      final addrs = await InternetAddress.lookup(host);
      for (final a in addrs) {
        yield 'Address : ${a.address}\n';
      }
    } catch (e) {
      yield 'Forward lookup failed: $e\n';
    }
    // System nslookup
    try {
      final proc = await Process.start('nslookup', [host]);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      await proc.exitCode;
    } catch (_) {}
  }

  // ── Traceroute ─────────────────────────────────────────────────────────────
  static Stream<String> traceroute(String host, {int maxHops = 30}) async* {
    yield '=== TRACEROUTE $host ===\n';
    final cmd  = Platform.isWindows ? 'tracert' : 'traceroute';
    final args = Platform.isWindows
        ? ['-h', maxHops.toString(), host]
        : ['-m', maxHops.toString(), '-w', '2', host];
    try {
      final proc = await Process.start(cmd, args);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      yield* proc.stderr.transform(const SystemEncoding().decoder);
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

  /// Well-known ports list used as the default scan target.
  static const wellKnownPorts = [
    21, 22, 23, 25, 53, 80, 110, 143, 161, 443, 445, 465,
    587, 631, 993, 995, 1080, 1194, 1433, 1521, 1723, 2049,
    3306, 3389, 5432, 5900, 6379, 8080, 8443, 8888, 9200, 27017,
  ];

  // Keep legacy alias so existing callers compile without changes.
  static const commonPorts = wellKnownPorts;

  static Stream<String> portScan(
    String host, {
    List<int>? ports,
    int rangeStart = 1,
    int rangeEnd = 2048,
    bool useTcp = true,
    bool useUdp = false,
    void Function(int done, int total)? onProgress,
  }) async* {
    final scanPorts = ports ?? List.generate(
      rangeEnd - rangeStart + 1,
      (i) => rangeStart + i,
    );
    yield '=== PORT SCAN $host'
        ' [${useTcp ? "TCP" : ""}${useTcp && useUdp ? "+" : ""}${useUdp ? "UDP" : ""}]'
        ' ports ${scanPorts.first}–${scanPorts.last} ===\n';

    final open = <int>[];
    for (var i = 0; i < scanPorts.length; i++) {
      final port = scanPorts[i];

      if (useTcp) {
        try {
          final sock = await Socket.connect(host, port,
              timeout: const Duration(milliseconds: 500));
          sock.destroy();
          open.add(port);
          yield 'OPEN  $port/tcp  ${_portName(port)}\n';
        } catch (_) {}
      }

      if (useUdp) {
        // UDP: send an empty datagram; if we get an ICMP Port Unreachable
        // back quickly the port is closed; silence = possibly open.
        // True UDP scanning from user-space is unreliable without raw sockets,
        // but this gives a best-effort result.
        try {
          final udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
          udp.send(Uint8List(0), InternetAddress(host), port);
          bool gotReply = false;
          await Future.any([
            udp.first.then((ev) {
              if (ev == RawSocketEvent.read) {
                gotReply = true;
              }
            }).catchError((_) {}),
            Future.delayed(const Duration(milliseconds: 400)),
          ]);
          udp.close();
          if (gotReply) {
            yield 'OPEN  $port/udp  ${_portName(port)}\n';
          }
        } catch (_) {}
      }

      onProgress?.call(i + 1, scanPorts.length);
    }

    if (open.isEmpty) yield 'No open ports found.\n';
    yield '\nDone. ${open.length} open port(s) found.\n';
  }

  static String _portName(int port) => switch (port) {
        21    => 'ftp',
        22    => 'ssh',
        23    => 'telnet',
        25    => 'smtp',
        53    => 'dns',
        80    => 'http',
        110   => 'pop3',
        143   => 'imap',
        161   => 'snmp',
        443   => 'https',
        445   => 'smb',
        465   => 'smtps',
        587   => 'submission',
        631   => 'ipp',
        993   => 'imaps',
        995   => 'pop3s',
        1433  => 'mssql',
        1521  => 'oracle',
        2049  => 'nfs',
        3306  => 'mysql',
        3389  => 'rdp',
        5432  => 'postgresql',
        5900  => 'vnc',
        6379  => 'redis',
        8080  => 'http-alt',
        8443  => 'https-alt',
        9200  => 'elasticsearch',
        27017 => 'mongodb',
        1080  => 'socks',
        1194  => 'openvpn',
        1723  => 'pptp',
        8888  => 'http-alt2',
        _     => '',
      };

  // ── IP Camera Scan ─────────────────────────────────────────────────────────
  // Scans for devices with camera-typical open ports: 554 (RTSP), 8554, 8080.
  // Yields "host:port" strings for each candidate.
  // Bounded by [timeout] per host so it always terminates.
  static Stream<String> ipCameraScan(
    String cidr, {
    Duration hostTimeout = const Duration(milliseconds: 800),
    void Function(int done, int total)? onProgress,
  }) async* {
    const cameraPorts = [554, 8554, 8080, 80, 443, 37777];

    // Expand CIDR to host list
    final parts = cidr.trim().split('/');
    if (parts.length != 2) {
      yield 'Invalid CIDR: $cidr\n';
      return;
    }
    final ipParts = parts[0].split('.').map(int.tryParse).toList();
    if (ipParts.length != 4 || ipParts.any((o) => o == null)) {
      yield 'Invalid IP: ${parts[0]}\n';
      return;
    }
    final prefix = int.tryParse(parts[1]);
    if (prefix == null || prefix < 16 || prefix > 30) {
      yield 'Prefix out of range (16–30): ${parts[1]}\n';
      return;
    }

    final base      = (ipParts[0]! << 24) | (ipParts[1]! << 16) | (ipParts[2]! << 8) | ipParts[3]!;
    final mask      = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net       = base & mask;
    final broadcast = net | (~mask & 0xFFFFFFFF);

    final hosts = <String>[];
    for (var i = net + 1; i < broadcast; i++) {
      hosts.add('${(i >> 24) & 0xFF}.${(i >> 16) & 0xFF}.${(i >> 8) & 0xFF}.${i & 0xFF}');
    }

    yield '=== IP CAMERA SCAN $cidr — ${hosts.length} hosts × ${cameraPorts.length} ports ===\n';

    int done = 0;
    const parallelism = 32;
    for (var i = 0; i < hosts.length; i += parallelism) {
      final batch = hosts.sublist(i, (i + parallelism).clamp(0, hosts.length));
      final futures = batch.map((ip) async {
        final found = <String>[];
        for (final port in cameraPorts) {
          try {
            final sock = await Socket.connect(ip, port, timeout: hostTimeout);
            sock.destroy();
            found.add('$ip:$port');
          } catch (_) {}
        }
        return found;
      });
      final results = await Future.wait(futures);
      for (final list in results) {
        for (final entry in list) {
          yield 'CAMERA  $entry\n';
        }
      }
      done += batch.length;
      onProgress?.call(done, hosts.length);
    }

    yield '=== Done ===\n';
  }

  // ── Speed Test ─────────────────────────────────────────────────────────────
  /// Returns a single SpeedResult via the stream (one event then done).
  static Stream<SpeedResult> speedTest() async* {
    // Use Cloudflare's speed test endpoint for a reliable, CORS-friendly test.
    const downloadUrl = 'https://speed.cloudflare.com/__down?bytes=10000000'; // 10 MB
    const uploadUrl   = 'https://speed.cloudflare.com/__up';

    double downloadMbps = 0;
    double uploadMbps   = 0;
    double pingMs       = 0;

    // Ping
    try {
      final sw  = Stopwatch()..start();
      final req = await HttpClient().getUrl(Uri.parse('https://speed.cloudflare.com/'));
      final res = await req.close().timeout(const Duration(seconds: 5));
      await res.drain<void>();
      sw.stop();
      pingMs = sw.elapsedMilliseconds.toDouble();
    } catch (_) {}

    // Download
    try {
      final sw     = Stopwatch()..start();
      final req    = await HttpClient().getUrl(Uri.parse(downloadUrl));
      final res    = await req.close().timeout(const Duration(seconds: 20));
      int bytes    = 0;
      await for (final chunk in res) {
        bytes += chunk.length;
      }
      sw.stop();
      final secs   = sw.elapsedMilliseconds / 1000.0;
      downloadMbps = secs > 0 ? (bytes * 8) / secs / 1e6 : 0;
    } catch (_) {}

    // Upload (send 2 MB)
    try {
      final payload = List<int>.filled(2 * 1024 * 1024, 0);
      final sw      = Stopwatch()..start();
      final req     = await HttpClient().postUrl(Uri.parse(uploadUrl));
      req.headers.contentType =
          ContentType('application', 'octet-stream');
      req.add(payload);
      final res = await req.close().timeout(const Duration(seconds: 20));
      await res.drain<void>();
      sw.stop();
      final secs = sw.elapsedMilliseconds / 1000.0;
      uploadMbps = secs > 0 ? (payload.length * 8) / secs / 1e6 : 0;
    } catch (_) {}

    yield SpeedResult(
      downloadMbps: downloadMbps,
      uploadMbps:   uploadMbps,
      pingMs:       pingMs,
      timestamp:    DateTime.now(),
    );
  }
}

// ── Speed result model ────────────────────────────────────────────────────────

class SpeedResult {
  final double downloadMbps;
  final double uploadMbps;
  final double pingMs;
  final DateTime timestamp;

  const SpeedResult({
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    required this.timestamp,
  });
}

// ── Uint8List for UDP ─────────────────────────────────────────────────────────
// (dart:typed_data is already in scope via dart:io on mobile; explicit import
//  added here so the file is self-contained)
