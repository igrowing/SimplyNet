import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/ookla_speed_test.dart';

void main() {
  group('OoklaSpeedTest.parseServers', () {
    test('parses a well-formed server list', () {
      const body =
          '['
          '{"host":"a.example.com:8080","sponsor":"Acme",'
          '"name":"Berlin","country":"Germany"},'
          '{"host":"b.example.com:8080","sponsor":"Globex",'
          '"name":"Paris","country":"France"}'
          ']';
      final servers = OoklaSpeedTest.parseServers(body);
      expect(servers.length, 2);
      expect(servers.first.host, 'a.example.com:8080');
      expect(servers.first.sponsor, 'Acme');
      expect(servers.first.label, 'Acme — Berlin, Germany');
    });

    test('skips entries without a host', () {
      const body =
          '['
          '{"sponsor":"NoHost","name":"Nowhere"},'
          '{"host":"good.example.com:8080","name":"Rome","country":"Italy"}'
          ']';
      final servers = OoklaSpeedTest.parseServers(body);
      expect(servers.length, 1);
      expect(servers.single.host, 'good.example.com:8080');
      expect(servers.single.label, 'Rome, Italy');
    });

    test('returns empty on malformed or non-list JSON', () {
      expect(OoklaSpeedTest.parseServers('not json'), isEmpty);
      expect(OoklaSpeedTest.parseServers('{"host":"x"}'), isEmpty);
      expect(OoklaSpeedTest.parseServers('[]'), isEmpty);
    });

    test('sends a non-Dart browser User-Agent (API 403s the Dart UA)', () {
      final ua = OoklaSpeedTest.headers['User-Agent'];
      expect(ua, isNotNull);
      expect(ua, isNot(contains('Dart')));
      expect(ua, contains('Mozilla'));
    });

    test('builds https download and upload URIs with size + nonce', () {
      const s = OoklaServer(host: 'srv.example.com:8080');
      final dl = s.downloadUri(1000);
      expect(dl.scheme, 'https');
      expect(dl.host, 'srv.example.com');
      expect(dl.port, 8080);
      expect(dl.path, '/download');
      expect(dl.queryParameters['size'], '1000');
      expect(dl.queryParameters['nocache'], isNotEmpty);

      final ul = s.uploadUri();
      expect(ul.path, '/upload');
      expect(ul.queryParameters['nocache'], isNotEmpty);
    });
  });
   
  group('OoklaServer.label', () {
    test('uses sponsor + place when both present', () {
      const s = OoklaServer(
          host: 'h:8080', sponsor: 'Acme', name: 'Berlin', country: 'Germany');
      expect(s.label, 'Acme — Berlin, Germany');
    });
 
    test('falls back to place when sponsor is empty', () {
      const s = OoklaServer(host: 'h:8080', name: 'Paris', country: 'France');
      expect(s.label, 'Paris, France');
    });
 
    test('falls back to sponsor when place is empty', () {
      const s = OoklaServer(host: 'h:8080', sponsor: 'Globex');
      expect(s.label, 'Globex');
    });
 
    test('falls back to host when sponsor and place are empty', () {
      const s = OoklaServer(host: 'srv.example.com:8080');
      expect(s.label, 'srv.example.com:8080');
    });
 
    test('joins only the non-empty of name/country', () {
      const onlyName = OoklaServer(host: 'h', name: 'Rome');
      expect(onlyName.label, 'Rome');
      const onlyCountry = OoklaServer(host: 'h', country: 'Italy');
      expect(onlyCountry.label, 'Italy');
    });
  });
 
  group('OoklaSpeedTest.bestServer', () {
    test('throws when the server list is empty', () {
      expect(OoklaSpeedTest.bestServer(const []), throwsA(isA<Exception>()));
    });
 
    test('throws when no server is reachable', () async {
      // RFC 5737 TEST-NET-1 hosts are unroutable, so every probe times out and
      // bestServer reports that none answered (exercises the worker + error
      // completion path without real network dependence).
      const servers = [
        OoklaServer(host: '192.0.2.1:8080'),
        OoklaServer(host: '192.0.2.2:8080'),
      ];
      await expectLater(
        OoklaSpeedTest.bestServer(servers),
        throwsA(isA<Exception>()),
      );
    }, timeout: const Timeout(Duration(seconds: 30)));
  });
}
