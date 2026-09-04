// Pure builders for the "About" section's outbound links, kept out of the
// widget so they can be unit-tested.

const feedbackEmail = 'support.simplytools.psglwm@bumpmail.io';
const feedbackSubject = 'SimplyNet: idea for improvement';
const coffeeUrl = 'https://www.buymeacoffee.com/igrowing';

/// `"1.1.0 (8)"` — or just `"1.1.0"` when the build number is missing.
/// Used for feedback triage, where the build number matters.
String formatAppVersion(String version, String buildNumber) =>
    buildNumber.isEmpty ? version : '$version ($buildNumber)';

/// Single-line title for the About row: `"SimplyNet v1.1.0"` (no build number).
String aboutTitle(String version) =>
    version.isEmpty ? 'SimplyNet' : 'SimplyNet v$version';

/// `mailto:` URI for the feedback action, with the subject and a pre-filled
/// body carrying the app version and platform for triage.
Uri feedbackMailtoUri({String? appVersion, String? platform}) {
  final lines = <String>[
    '',
    '',
    '---',
    if (appVersion != null && appVersion.isNotEmpty)
      'App: SimplyNet v$appVersion',
    if (platform != null && platform.isNotEmpty) 'Platform: $platform',
  ];
  return Uri(
    scheme: 'mailto',
    path: feedbackEmail,
    query: _encodeQuery({
      'subject': feedbackSubject,
      'body': lines.join('\n'),
    }),
  );
}

String _encodeQuery(Map<String, String> params) => params.entries
    .map((e) =>
        '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
    .join('&');
