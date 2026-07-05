import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('uk'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @screenOnTimeout.
  ///
  /// In en, this message translates to:
  /// **'Screen On Timeout'**
  String get screenOnTimeout;

  /// No description provided for @timeoutSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get timeoutSystem;

  /// No description provided for @timeoutTriple.
  ///
  /// In en, this message translates to:
  /// **'3× System'**
  String get timeoutTriple;

  /// No description provided for @timeoutStayOn.
  ///
  /// In en, this message translates to:
  /// **'Stay On'**
  String get timeoutStayOn;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanning;

  /// No description provided for @showMacAddress.
  ///
  /// In en, this message translates to:
  /// **'Show MAC Address'**
  String get showMacAddress;

  /// No description provided for @showMacBlocked.
  ///
  /// In en, this message translates to:
  /// **'Disabled on Android v.11 and up due to Google privacy concerns'**
  String get showMacBlocked;

  /// No description provided for @showMacSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display MAC column in scan results'**
  String get showMacSubtitle;

  /// No description provided for @resolveHostnames.
  ///
  /// In en, this message translates to:
  /// **'Resolve Hostnames'**
  String get resolveHostnames;

  /// No description provided for @resolveHostnamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Perform reverse-DNS + mDNS during scan'**
  String get resolveHostnamesSubtitle;

  /// No description provided for @enableLogging.
  ///
  /// In en, this message translates to:
  /// **'Enable Logging'**
  String get enableLogging;

  /// No description provided for @enableLoggingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save scan and tool output to log files'**
  String get enableLoggingSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutSimplyNet.
  ///
  /// In en, this message translates to:
  /// **'About SimplyNet'**
  String get aboutSimplyNet;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @networkTools.
  ///
  /// In en, this message translates to:
  /// **'Network Tools'**
  String get networkTools;

  /// No description provided for @networkTarget.
  ///
  /// In en, this message translates to:
  /// **'Network Target'**
  String get networkTarget;

  /// No description provided for @networkTargetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 192.168.1.0/24'**
  String get networkTargetHint;

  /// No description provided for @invalidCidr.
  ///
  /// In en, this message translates to:
  /// **'Invalid CIDR — use format like 192.168.1.0/24'**
  String get invalidCidr;

  /// No description provided for @detectMyNetwork.
  ///
  /// In en, this message translates to:
  /// **'Detect my network'**
  String get detectMyNetwork;

  /// No description provided for @toolSpeedTest.
  ///
  /// In en, this message translates to:
  /// **'Speed Test'**
  String get toolSpeedTest;

  /// No description provided for @toolSpeedTestSub.
  ///
  /// In en, this message translates to:
  /// **'Download & upload speed'**
  String get toolSpeedTestSub;

  /// No description provided for @toolPublicIp.
  ///
  /// In en, this message translates to:
  /// **'Public IP'**
  String get toolPublicIp;

  /// No description provided for @toolPublicIpSub.
  ///
  /// In en, this message translates to:
  /// **'Your IP, ISP & location'**
  String get toolPublicIpSub;

  /// No description provided for @toolIpCameras.
  ///
  /// In en, this message translates to:
  /// **'IP Cameras'**
  String get toolIpCameras;

  /// No description provided for @toolIpCamerasSub.
  ///
  /// In en, this message translates to:
  /// **'Find cameras on your LAN'**
  String get toolIpCamerasSub;

  /// No description provided for @toolIotDevices.
  ///
  /// In en, this message translates to:
  /// **'IoT Devices'**
  String get toolIotDevices;

  /// No description provided for @toolIotDevicesSub.
  ///
  /// In en, this message translates to:
  /// **'Matter, Tasmota, Shelly & more'**
  String get toolIotDevicesSub;

  /// No description provided for @toolMqttSub.
  ///
  /// In en, this message translates to:
  /// **'MQTT Sub'**
  String get toolMqttSub;

  /// No description provided for @toolMqttSubSub.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to an MQTT topic'**
  String get toolMqttSubSub;

  /// No description provided for @toolMqttPub.
  ///
  /// In en, this message translates to:
  /// **'MQTT Pub'**
  String get toolMqttPub;

  /// No description provided for @toolMqttPubSub.
  ///
  /// In en, this message translates to:
  /// **'Publish to an MQTT topic'**
  String get toolMqttPubSub;

  /// No description provided for @toolPortScan.
  ///
  /// In en, this message translates to:
  /// **'Port Scan'**
  String get toolPortScan;

  /// No description provided for @toolPortScanSub.
  ///
  /// In en, this message translates to:
  /// **'Open TCP/UDP ports on any host'**
  String get toolPortScanSub;

  /// No description provided for @toolPing.
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get toolPing;

  /// No description provided for @toolPingSub.
  ///
  /// In en, this message translates to:
  /// **'Live ping with graph'**
  String get toolPingSub;

  /// No description provided for @toolTraceroute.
  ///
  /// In en, this message translates to:
  /// **'Traceroute'**
  String get toolTraceroute;

  /// No description provided for @toolTracerouteSub.
  ///
  /// In en, this message translates to:
  /// **'Hop-by-hop path to any host'**
  String get toolTracerouteSub;

  /// No description provided for @toolWhois.
  ///
  /// In en, this message translates to:
  /// **'Who Is…'**
  String get toolWhois;

  /// No description provided for @toolWhoisSub.
  ///
  /// In en, this message translates to:
  /// **'WHOIS, DNS & reverse lookup'**
  String get toolWhoisSub;

  /// No description provided for @toolWifiChannels.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Channels'**
  String get toolWifiChannels;

  /// No description provided for @toolWifiChannelsSub.
  ///
  /// In en, this message translates to:
  /// **'2.4 & 5 GHz interference map'**
  String get toolWifiChannelsSub;

  /// No description provided for @toolCellularInfo.
  ///
  /// In en, this message translates to:
  /// **'Cellular Info'**
  String get toolCellularInfo;

  /// No description provided for @toolCellularInfoSub.
  ///
  /// In en, this message translates to:
  /// **'Signal, cell ID & tower data'**
  String get toolCellularInfoSub;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pl',
    'pt',
    'ru',
    'th',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
