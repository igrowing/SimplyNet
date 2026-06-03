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
  // Auto-detects direction based on input:
  //   • IPv4 literal  →  reverse lookup  (PTR record: IP → FQDN)
  //   • Anything else →  forward lookup  (A/AAAA: name → IPs)
  // Falls back to the system `nslookup` binary for extra detail either way.
  static final _ipRegex = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');

  static Stream<String> nslookup(String host) async* {
    final input   = host.trim();
    final isIp    = _ipRegex.hasMatch(input);
    yield '=== ${isIp ? "REVERSE " : ""}NSLOOKUP $input ===\n';

    if (isIp) {
      // ── Reverse lookup: IP → FQDN ────────────────────────────────────────
      // Method 1: dart:io PTR query (cleanest)
      bool gotResult = false;
      try {
        final ia  = InternetAddress(input);
        final rev = await ia.reverse().timeout(const Duration(seconds: 4));
        if (rev.host.isNotEmpty && rev.host != input) {
          yield 'PTR record : ${rev.host}\n';
          gotResult = true;
        }
      } catch (_) {}

      // Method 2: system nslookup (shows full PTR chain)
      try {
        final proc = await Process.start('nslookup', [input]);
        final out  = await proc.stdout
            .transform(const SystemEncoding().decoder)
            .join()
            .timeout(const Duration(seconds: 5));
        await proc.exitCode;
        // Filter for the "name =" line which carries the FQDN
        for (final line in out.split('\n')) {
          final t = line.trim();
          if (t.contains('name =') || t.startsWith('Non-authoritative')) {
            yield '$t\n';
            gotResult = true;
          }
        }
      } catch (_) {}

      if (!gotResult) yield 'No PTR record found for $input\n';
    } else {
      // ── Forward lookup: name → IPs ───────────────────────────────────────
      // Method 1: dart:io A/AAAA lookup
      try {
        final addrs = await InternetAddress.lookup(input)
            .timeout(const Duration(seconds: 4));
        for (final a in addrs) {
          yield '${a.type == InternetAddressType.IPv6 ? "AAAA" : "A   "} : ${a.address}\n';
        }
      } catch (e) {
        yield 'Lookup failed: $e\n';
      }

      // Method 2: system nslookup for full answer (TTL, authoritative server)
      try {
        final proc = await Process.start('nslookup', [input]);
        final out  = await proc.stdout
            .transform(const SystemEncoding().decoder)
            .join()
            .timeout(const Duration(seconds: 5));
        await proc.exitCode;
        // Show the answer section (lines after the blank line)
        bool inAnswer = false;
        for (final line in out.split('\n')) {
          final t = line.trim();
          if (t.isEmpty) { inAnswer = true; continue; }
          if (inAnswer && t.isNotEmpty) yield '$t\n';
        }
      } catch (_) {}
    }
  }

  // ── Traceroute ─────────────────────────────────────────────────────────────
  // Uses `ping -c 1 -t <ttl>` per hop.
  //
  // Why ping instead of traceroute binary or raw sockets?
  //   • `traceroute` binary: always fails with "Permission denied" on stock
  //     Android — requires CAP_NET_RAW which unprivileged apps don't have.
  //   • Raw sockets (RawDatagramSocket): dart:io UDP sockets cannot set the
  //     IP_TTL socket option, so TTL-based probing is impossible in pure Dart.
  //   • `ping -t <ttl>`: the system `ping` binary has the setuid bit / ambient
  //     capabilities on Android, so it CAN send ICMP with a controlled TTL.
  //     When TTL expires mid-route the intermediate router sends back an ICMP
  //     Time Exceeded packet. Android's ping prints that router's IP in the
  //     "From <ip>: icmp_seq=..." or "From <ip> icmp_type=11" line.
  //     This is exactly how real traceroute works, using the same ICMP
  //     Time Exceeded mechanism — we just drive it from ping instead of
  //     the traceroute binary.
  //
  // 3 probes per hop (like traceroute -q 3) run sequentially (ping -c 3)
  // to match standard traceroute output format.
  //
  // Hop detection logic:
  //   ping exit code 0  → destination reached (successful ICMP echo reply)
  //   "From <ip>" line  → intermediate router sent Time Exceeded; ip ≠ dest
  //   No reply / "*"    → hop is firewalled or dropped (timeout)
  //
  // Falls back to TCP-connect if ping -t is not supported (some old kernels).

  static Stream<String> traceroute(String host, {int maxHops = 30}) async* {
    yield '=== TRACEROUTE $host ===\n';

    // Resolve destination once so we can detect arrival
    String destIp = host;
    try {
      final addrs = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 4));
      destIp = addrs.first.address;
      if (destIp != host) yield 'Resolved: $host → $destIp\n';
    } catch (e) {
      yield 'DNS resolution failed: $e\n';
      return;
    }
    yield '\n';

    // Regex to extract the replying IP from a Time Exceeded line.
    // Android ping prints:  "From 192.168.1.1 icmp_seq=1 Time to live exceeded"
    // Some versions print:  "From 192.168.1.1: icmp_seq=1 Time to live exceeded"
    final fromRe  = RegExp(r'From ([\d.]+)[: ]');
    // Regex to extract RTT from a normal echo reply line:
    // "64 bytes from 8.8.8.8: icmp_seq=1 ttl=118 time=14.2 ms"
    final timeRe  = RegExp(r'time=([\d.]+)\s*ms');
    // Regex to extract the replying IP from an echo reply line:
    final byteRe  = RegExp(r'bytes from ([\d.]+):');

    for (var ttl = 1; ttl <= maxHops; ttl++) {
      final sw = Stopwatch()..start();

      // ping -c 3 -t <ttl> -W 2: 3 packets, TTL=ttl, 2s wait per packet
      String? hopIp;
      final hopTimes = <String>[];
      bool reached = false;

      try {
        final result = await Process.run(
          'ping', ['-c', '3', '-t', ttl.toString(), '-W', '2', destIp],
          runInShell: false,
        ).timeout(const Duration(seconds: 9)); // 3 packets × 2s + buffer

        final out = '${result.stdout}${result.stderr}';

        // Parse each line for hop IP and RTT
        for (final line in out.split('\n')) {
          // Arrived at destination
          final byteMatch = byteRe.firstMatch(line);
          if (byteMatch != null) {
            hopIp   = byteMatch.group(1)!;
            reached = (hopIp == destIp);
            final t = timeRe.firstMatch(line);
            if (t != null) hopTimes.add('${double.parse(t.group(1)!).toStringAsFixed(1)}ms');
          }
          // Time Exceeded from intermediate router
          final fromMatch = fromRe.firstMatch(line);
          if (fromMatch != null && hopIp == null) {
            hopIp = fromMatch.group(1)!;
            final t = timeRe.firstMatch(line);
            if (t != null) hopTimes.add('${double.parse(t.group(1)!).toStringAsFixed(1)}ms');
          }
        }

        // Count asterisks for non-responding probes
        final stars = 3 - hopTimes.length;
        for (var i = 0; i < stars; i++) hopTimes.add('*');

      } catch (_) {
        hopTimes.addAll(['*', '*', '*']);
      }

      sw.stop();

      // Reverse-DNS the hop IP
      String label = hopIp ?? '*';
      if (hopIp != null) {
        try {
          final rev = await InternetAddress(hopIp)
              .reverse()
              .timeout(const Duration(seconds: 1));
          if (rev.host != hopIp) label = '${rev.host} ($hopIp)';
        } catch (_) {}
      }

      final hopNum = ttl.toString().padLeft(2);
      yield '$hopNum  $label  ${hopTimes.join("  ")}\n';

      if (reached) {
        yield '\nReached destination in $ttl hop${ttl == 1 ? "" : "s"}.\n';
        return;
      }

      // If we got the destination IP directly at this hop (exit code 0), stop
      if (hopIp == destIp) {
        yield '\nReached destination in $ttl hop${ttl == 1 ? "" : "s"}.\n';
        return;
      }
    }
    yield '\nMax hops ($maxHops) reached.\n';
  }

  // ── Port Scan ──────────────────────────────────────────────────────────────

  /// Well-known ports list used as the default scan target.
  static const wellKnownPorts = [
    21, 22, 23, 25, 53, 80, 81, 82, 83, 84, 85, 110, 143, 161, 443, 445, 465,
    587, 631, 993, 995, 1080, 1194, 1433, 1521, 1723, 1883, 1935, 2049,
    3306, 3389, 4040, 5353, 5540, 5432, 5554, 5900, 6379, 6668, 8080, 8081, 8123, 
    8443, 8554, 8888, 9000, 9001, 9200, 9443, 9999, 10554, 20202,	27017, 34567, 34599, 37777,	37778, 49153,	55443,
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
  // Moved to lib/services/ip_camera_detector.dart (IpCameraDetector.scanSubnet).
  // The multi-signal detection model (specific ports, manufacturer, HTTP
  // banner, WS-Discovery) lives there and replaces the old plain port-check.

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

