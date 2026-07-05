import 'package:flutter/widgets.dart';

/// A language the app can be displayed in. [endonym] is the language's own name
/// (shown regardless of the active locale) and [countryCode] selects the flag.
class AppLanguage {
  final Locale locale;
  final String countryCode;
  final String endonym;

  const AppLanguage({
    required this.locale,
    required this.countryCode,
    required this.endonym,
  });

  /// Stable identifier used to persist the choice (e.g. 'en', 'zh_Hant').
  String get tag => locale.scriptCode == null
      ? locale.languageCode
      : '${locale.languageCode}_${locale.scriptCode}';

  /// Languages offered in the Settings language picker, in display order.
  static const List<AppLanguage> supported = [
    AppLanguage(locale: Locale('en'), countryCode: 'GB', endonym: 'English'),
    AppLanguage(locale: Locale('it'), countryCode: 'IT', endonym: 'Italiano'),
    AppLanguage(locale: Locale('es'), countryCode: 'ES', endonym: 'Español'),
    AppLanguage(locale: Locale('de'), countryCode: 'DE', endonym: 'Deutsch'),
    AppLanguage(locale: Locale('pt'), countryCode: 'PT', endonym: 'Português'),
    AppLanguage(locale: Locale('fr'), countryCode: 'FR', endonym: 'Français'),
    AppLanguage(
        locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        countryCode: 'CN',
        endonym: '简体中文'),
    AppLanguage(
        locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        countryCode: 'TW',
        endonym: '繁體中文'),
    AppLanguage(locale: Locale('ja'), countryCode: 'JP', endonym: '日本語'),
    AppLanguage(locale: Locale('th'), countryCode: 'TH', endonym: 'ไทย'),
    AppLanguage(locale: Locale('ru'), countryCode: 'RU', endonym: 'Русский'),
    AppLanguage(locale: Locale('uk'), countryCode: 'UA', endonym: 'Українська'),
    AppLanguage(locale: Locale('pl'), countryCode: 'PL', endonym: 'Polski'),
    AppLanguage(locale: Locale('cs'), countryCode: 'CZ', endonym: 'Čeština'),
    AppLanguage(locale: Locale('ko'), countryCode: 'KR', endonym: '한국어'),
    AppLanguage(locale: Locale('hi'), countryCode: 'IN', endonym: 'हिन्दी'),
  ];

  /// The [Locale]s to pass to [MaterialApp.supportedLocales].
  static List<Locale> get supportedLocales =>
      supported.map((l) => l.locale).toList();

  /// Resolves a persisted [tag] back to a language, defaulting to English.
  static AppLanguage fromTag(String? tag) {
    return supported.firstWhere(
      (l) => l.tag == tag,
      orElse: () => supported.first,
    );
  }
}
