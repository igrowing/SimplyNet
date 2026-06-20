import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

/// One server from Ookla's speedtest.net fleet.
class OoklaServer {
  final String host;    // "name.example.com:8080" (may include a port)
  final String sponsor; // operator name
  final String name;    // city
  final String country;

  const OoklaServer({
    required this.host,
    this.sponsor = '',
    this.name = '',
    this.country = '',
  });

  String get label {
    final place = [name, country].where((s) => s.isNotEmpty).join(', ');
    if (sponsor.isEmpty) return place.isEmpty ? host : place;
    return place.isEmpty ? sponsor : '$sponsor — $place';
  }

  Uri downloadUri(int bytes) =>
      Uri.parse('https://$host/download?nocache=${_nonce()}&size=$bytes');
  Uri uploadUri() => Uri.parse('https://$host/upload?nocache=${_nonce()}');

  static String _nonce() => Random().nextInt(0x7fffffff).toString();
}

/// Measures connection speed against Ookla's third-party speedtest.net servers
/// over HTTPS. Used only after the user has accepted the Ookla consent.
class OoklaSpeedTest {
  static const serversUrl =
      'https://www.speedtest.net/api/js/servers?engine=js&limit=10';

  /// Parse the speedtest.net server-list JSON into [OoklaServer]s. Pure so it
  /// can be unit-tested without network access. Tolerates malformed entries.
  static List<OoklaServer> parseServers(String body) {
    dynamic data;
    try {
      data = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    if (data is! List) return const [];
    final out = <OoklaServer>[];
    for (final e in data) {
      if (e is! Map) continue;
      final host = (e['host'] as String?)?.trim();
      if (host == null || host.isEmpty) continue;
      out.add(OoklaServer(
        host:    host,
        sponsor: (e['sponsor'] as String?)?.trim() ?? '',
        name:    (e['name'] as String?)?.trim() ?? '',
        country: (e['country'] as String?)?.trim() ?? '',
      ));
    }
    return out;
  }

  /// Fetch the nearest candidate servers from speedtest.net.
  static Future<List<OoklaServer>> fetchServers() async {
    final resp = await http
        .get(Uri.parse(serversUrl))
        .timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) {
      throw Exception('Ookla server list returned HTTP ${resp.statusCode}');
    }
    return parseServers(resp.body);
  }

  /// Probe [servers] in order and return the first that answers, with its
  /// round-trip latency in milliseconds. Throws when none are reachable.
  static Future<({OoklaServer server, double pingMs})> bestServer(
      List<OoklaServer> servers) async {
    for (final s in servers) {
      try {
        final sw = Stopwatch()..start();
        final r = await http
            .get(s.downloadUri(1))
            .timeout(const Duration(seconds: 4));
        sw.stop();
        if (r.statusCode == 200) {
          return (server: s, pingMs: sw.elapsedMilliseconds.toDouble());
        }
      } catch (_) {
        // try the next server
      }
    }
    throw Exception('No reachable Ookla server');
  }
}
