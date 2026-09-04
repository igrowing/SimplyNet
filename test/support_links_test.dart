import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/utils/support_links.dart';

void main() {
  group('formatAppVersion', () {
    test('combines version and build number', () {
      expect(formatAppVersion('1.1.0', '8'), '1.1.0 (8)');
    });

    test('omits the parenthetical when build number is empty', () {
      expect(formatAppVersion('1.1.0', ''), '1.1.0');
    });
  });

  group('aboutTitle', () {
    test('is a single line: name + v-prefixed version, no build number', () {
      expect(aboutTitle('1.1.0'), 'SimplyNet v1.1.0');
    });

    test('falls back to the bare name before PackageInfo resolves', () {
      expect(aboutTitle(''), 'SimplyNet');
    });
  });

  group('feedbackMailtoUri', () {
    test('targets the support address with the fixed subject', () {
      final uri = feedbackMailtoUri();
      expect(uri.scheme, 'mailto');
      expect(uri.path, feedbackEmail);
      expect(uri.queryParameters['subject'], feedbackSubject);
    });

    test('body carries app version and platform when provided', () {
      final body = feedbackMailtoUri(
        appVersion: '1.1.0 (8)',
        platform: 'android',
      ).queryParameters['body']!;
      expect(body, contains('App: SimplyNet v1.1.0 (8)'));
      expect(body, contains('Platform: android'));
      expect(body, contains('---'));
    });

    test('body omits missing/empty fields', () {
      final body = feedbackMailtoUri(appVersion: '', platform: null)
          .queryParameters['body']!;
      expect(body, isNot(contains('App:')));
      expect(body, isNot(contains('Platform:')));
    });

    test('query is encoded (no raw spaces; values survive round-trip)', () {
      final uri = feedbackMailtoUri(appVersion: '1.0.0', platform: 'ios');
      expect(uri.query, isNot(contains(' ')));
      expect(uri.queryParameters['subject'], 'SimplyNet: idea for improvement');
      expect(uri.queryParameters['body'], contains('App: SimplyNet v1.0.0'));
    });
  });

  test('coffeeUrl is the maintainer BuyMeACoffee page', () {
    final uri = Uri.parse(coffeeUrl);
    expect(uri.scheme, 'https');
    expect(uri.host, 'www.buymeacoffee.com');
    expect(uri.path, '/igrowing');
  });
}
