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

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @copyIp.
  ///
  /// In en, this message translates to:
  /// **'Copy IP'**
  String get copyIp;

  /// No description provided for @hostHint.
  ///
  /// In en, this message translates to:
  /// **'IP address or hostname'**
  String get hostHint;

  /// No description provided for @domainHostHint.
  ///
  /// In en, this message translates to:
  /// **'Domain, IP address, or hostname'**
  String get domainHostHint;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @trace.
  ///
  /// In en, this message translates to:
  /// **'Trace'**
  String get trace;

  /// No description provided for @lookUp.
  ///
  /// In en, this message translates to:
  /// **'Look up'**
  String get lookUp;

  /// No description provided for @lookingUp.
  ///
  /// In en, this message translates to:
  /// **'Looking up…'**
  String get lookingUp;

  /// No description provided for @enterHostGo.
  ///
  /// In en, this message translates to:
  /// **'Enter a host and press Go'**
  String get enterHostGo;

  /// No description provided for @enterHostTrace.
  ///
  /// In en, this message translates to:
  /// **'Enter a host and press Trace'**
  String get enterHostTrace;

  /// No description provided for @enterHostScan.
  ///
  /// In en, this message translates to:
  /// **'Enter a host and tap Scan'**
  String get enterHostScan;

  /// No description provided for @enterDomainIp.
  ///
  /// In en, this message translates to:
  /// **'Enter a domain, IP, or hostname'**
  String get enterDomainIp;

  /// No description provided for @aboutPing.
  ///
  /// In en, this message translates to:
  /// **'About Ping'**
  String get aboutPing;

  /// No description provided for @aboutTraceroute.
  ///
  /// In en, this message translates to:
  /// **'About Traceroute'**
  String get aboutTraceroute;

  /// No description provided for @aboutWhois.
  ///
  /// In en, this message translates to:
  /// **'About Who Is'**
  String get aboutWhois;

  /// No description provided for @aboutPortScan.
  ///
  /// In en, this message translates to:
  /// **'About Port Scan'**
  String get aboutPortScan;

  /// No description provided for @hiddenNode.
  ///
  /// In en, this message translates to:
  /// **'Hidden Node'**
  String get hiddenNode;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @yourRouter.
  ///
  /// In en, this message translates to:
  /// **'Your router'**
  String get yourRouter;

  /// No description provided for @networkHop.
  ///
  /// In en, this message translates to:
  /// **'Network Hop'**
  String get networkHop;

  /// No description provided for @hop.
  ///
  /// In en, this message translates to:
  /// **'Hop'**
  String get hop;

  /// No description provided for @noReply.
  ///
  /// In en, this message translates to:
  /// **'no reply'**
  String get noReply;

  /// No description provided for @probingNextHop.
  ///
  /// In en, this message translates to:
  /// **'Probing next hop…'**
  String get probingNextHop;

  /// No description provided for @hiddenNodeInfo.
  ///
  /// In en, this message translates to:
  /// **'This router did not reply to our probes. Many ISPs, firewalls and security appliances deliberately drop or rate-limit ICMP (ping) traffic, so the hop stays anonymous even though your data still passes through it.\n\nThis is normal and does not mean the route is broken.'**
  String get hiddenNodeInfo;

  /// No description provided for @portsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ports:'**
  String get portsLabel;

  /// No description provided for @wellKnown.
  ///
  /// In en, this message translates to:
  /// **'Well-known'**
  String get wellKnown;

  /// No description provided for @rangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get rangeLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From:'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get toLabel;

  /// No description provided for @protocolLabel.
  ///
  /// In en, this message translates to:
  /// **'Protocol:'**
  String get protocolLabel;

  /// No description provided for @hideSettings.
  ///
  /// In en, this message translates to:
  /// **'Hide settings'**
  String get hideSettings;

  /// No description provided for @myPublicIp.
  ///
  /// In en, this message translates to:
  /// **'My Public IP'**
  String get myPublicIp;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// No description provided for @infoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Information not available.'**
  String get infoUnavailable;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get startTest;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @measuringPing.
  ///
  /// In en, this message translates to:
  /// **'Measuring ping…'**
  String get measuringPing;

  /// No description provided for @findingServer.
  ///
  /// In en, this message translates to:
  /// **'Finding server…'**
  String get findingServer;

  /// No description provided for @testingDownload.
  ///
  /// In en, this message translates to:
  /// **'Testing download…'**
  String get testingDownload;

  /// No description provided for @testingUpload.
  ///
  /// In en, this message translates to:
  /// **'Testing upload…'**
  String get testingUpload;

  /// No description provided for @viaCloudflare.
  ///
  /// In en, this message translates to:
  /// **'Via Cloudflare'**
  String get viaCloudflare;

  /// No description provided for @viaOokla.
  ///
  /// In en, this message translates to:
  /// **'Via Ookla'**
  String get viaOokla;

  /// No description provided for @aboutSpeedTestTip.
  ///
  /// In en, this message translates to:
  /// **'About the speed test'**
  String get aboutSpeedTestTip;

  /// No description provided for @speedTestInfo.
  ///
  /// In en, this message translates to:
  /// **'Speed Test Info'**
  String get speedTestInfo;

  /// No description provided for @previousMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Previous Measurements'**
  String get previousMeasurements;

  /// No description provided for @noMeasurements.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet.'**
  String get noMeasurements;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date / Time'**
  String get dateTime;

  /// No description provided for @switchToOokla.
  ///
  /// In en, this message translates to:
  /// **'Switch to Ookla?'**
  String get switchToOokla;

  /// No description provided for @ooklaConsentBody.
  ///
  /// In en, this message translates to:
  /// **'Switching to Ookla requires connecting to third-party servers. Ookla collects and shares your IP address, device identifiers, and location data.'**
  String get ooklaConsentBody;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @clearHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear History?'**
  String get clearHistoryTitle;

  /// No description provided for @clearHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all measurement records.'**
  String get clearHistoryBody;

  /// No description provided for @aboutThisScan.
  ///
  /// In en, this message translates to:
  /// **'About this scan'**
  String get aboutThisScan;

  /// No description provided for @scanInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Devices blocking ICMP (pings) will not appear here. Run the \'IoT Devices\' or \'IP Cameras\' scan to locate them via their open ports and services.\n\nIn Android 11+ devices, MAC addresses cannot be retrieved due to Google\'s privacy restrictions, so they are not displayed.'**
  String get scanInfoBody;

  /// No description provided for @stopScan.
  ///
  /// In en, this message translates to:
  /// **'Stop scan'**
  String get stopScan;

  /// No description provided for @reScan.
  ///
  /// In en, this message translates to:
  /// **'Re-scan'**
  String get reScan;

  /// No description provided for @hostsFound.
  ///
  /// In en, this message translates to:
  /// **'host(s) found'**
  String get hostsFound;

  /// No description provided for @hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// No description provided for @noSavedResults.
  ///
  /// In en, this message translates to:
  /// **'No saved results'**
  String get noSavedResults;

  /// No description provided for @noNetworkTarget.
  ///
  /// In en, this message translates to:
  /// **'No network target set'**
  String get noNetworkTarget;

  /// No description provided for @tapRefreshToScan.
  ///
  /// In en, this message translates to:
  /// **'Tap the refresh button to scan'**
  String get tapRefreshToScan;

  /// No description provided for @setTargetHome.
  ///
  /// In en, this message translates to:
  /// **'Set a target on the Home screen'**
  String get setTargetHome;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser (HTTP)'**
  String get openInBrowser;

  /// No description provided for @openSsh.
  ///
  /// In en, this message translates to:
  /// **'Open SSH'**
  String get openSsh;

  /// No description provided for @couldNotOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Could not open browser'**
  String get couldNotOpenBrowser;

  /// No description provided for @noSshApp.
  ///
  /// In en, this message translates to:
  /// **'No SSH app found. Install ConnectBot or Termius.'**
  String get noSshApp;

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @macAddress.
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// No description provided for @manufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturer;

  /// No description provided for @deviceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get deviceTypeLabel;

  /// No description provided for @openPorts.
  ///
  /// In en, this message translates to:
  /// **'Open Ports'**
  String get openPorts;

  /// No description provided for @stopPortScan.
  ///
  /// In en, this message translates to:
  /// **'Stop port scan'**
  String get stopPortScan;

  /// No description provided for @portScanSettings.
  ///
  /// In en, this message translates to:
  /// **'Port scan settings'**
  String get portScanSettings;

  /// No description provided for @reScanPorts.
  ///
  /// In en, this message translates to:
  /// **'Re-scan ports'**
  String get reScanPorts;

  /// No description provided for @noOpenPorts.
  ///
  /// In en, this message translates to:
  /// **'No open ports found.'**
  String get noOpenPorts;

  /// No description provided for @applyRescan.
  ///
  /// In en, this message translates to:
  /// **'Apply & Rescan'**
  String get applyRescan;

  /// No description provided for @diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnostics;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @deleteAllLogs.
  ///
  /// In en, this message translates to:
  /// **'Delete all logs'**
  String get deleteAllLogs;

  /// No description provided for @deleteAllLogsQ.
  ///
  /// In en, this message translates to:
  /// **'Delete all logs?'**
  String get deleteAllLogsQ;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get cannotBeUndone;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @deleteLogQ.
  ///
  /// In en, this message translates to:
  /// **'Delete log?'**
  String get deleteLogQ;

  /// No description provided for @noLogsYet.
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get noLogsYet;

  /// No description provided for @scanningEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanningEllipsis;

  /// No description provided for @iotDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'IoT device(s) found'**
  String get iotDevicesFound;

  /// No description provided for @iotNoSaved.
  ///
  /// In en, this message translates to:
  /// **'No saved results.\nTap refresh to scan.'**
  String get iotNoSaved;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @viaLabel.
  ///
  /// In en, this message translates to:
  /// **'via'**
  String get viaLabel;

  /// No description provided for @confDefinite.
  ///
  /// In en, this message translates to:
  /// **'definite'**
  String get confDefinite;

  /// No description provided for @confProbable.
  ///
  /// In en, this message translates to:
  /// **'probable'**
  String get confProbable;

  /// No description provided for @confPossible.
  ///
  /// In en, this message translates to:
  /// **'possible'**
  String get confPossible;

  /// No description provided for @ipCameraScan.
  ///
  /// In en, this message translates to:
  /// **'IP Camera Scan'**
  String get ipCameraScan;

  /// No description provided for @camMethodProtocolPort.
  ///
  /// In en, this message translates to:
  /// **'Protocol port'**
  String get camMethodProtocolPort;

  /// No description provided for @camMethodKnownVendor.
  ///
  /// In en, this message translates to:
  /// **'Known vendor'**
  String get camMethodKnownVendor;

  /// No description provided for @camMethodHttpFingerprint.
  ///
  /// In en, this message translates to:
  /// **'HTTP fingerprint'**
  String get camMethodHttpFingerprint;

  /// No description provided for @camMethodWsDiscovery.
  ///
  /// In en, this message translates to:
  /// **'WS-Discovery'**
  String get camMethodWsDiscovery;

  /// No description provided for @camScanningStatus.
  ///
  /// In en, this message translates to:
  /// **'Scanning… {done}/{total} hosts — {n} camera(s)'**
  String camScanningStatus(Object done, Object n, Object total);

  /// No description provided for @camNoSaved.
  ///
  /// In en, this message translates to:
  /// **'No saved results — tap refresh to scan {cidr}'**
  String camNoSaved(Object cidr);

  /// No description provided for @camFound.
  ///
  /// In en, this message translates to:
  /// **'{n} camera(s) found — {cidr}'**
  String camFound(Object cidr, Object n);

  /// No description provided for @noCamerasFound.
  ///
  /// In en, this message translates to:
  /// **'No cameras found.'**
  String get noCamerasFound;

  /// No description provided for @mqttSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'MQTT Settings'**
  String get mqttSettingsTitle;

  /// No description provided for @brokerIpFqdn.
  ///
  /// In en, this message translates to:
  /// **'Broker IP / FQDN'**
  String get brokerIpFqdn;

  /// No description provided for @searchingSubnet.
  ///
  /// In en, this message translates to:
  /// **'Searching subnet…'**
  String get searchingSubnet;

  /// No description provided for @brokerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 192.168.1.10 or broker.example.com'**
  String get brokerHint;

  /// No description provided for @portLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get portLabel;

  /// No description provided for @usernameOptional.
  ///
  /// In en, this message translates to:
  /// **'Username (optional)'**
  String get usernameOptional;

  /// No description provided for @leaveEmptyOptional.
  ///
  /// In en, this message translates to:
  /// **'leave empty if not required'**
  String get leaveEmptyOptional;

  /// No description provided for @passwordOptional.
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get passwordOptional;

  /// No description provided for @keepPassword.
  ///
  /// In en, this message translates to:
  /// **'Keep password (not recommended)'**
  String get keepPassword;

  /// No description provided for @keepPasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Password is stored in plain text in app storage.'**
  String get keepPasswordSub;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @screenStaysOn.
  ///
  /// In en, this message translates to:
  /// **'Screen stays on'**
  String get screenStaysOn;

  /// No description provided for @screenMaySleep.
  ///
  /// In en, this message translates to:
  /// **'Screen may sleep'**
  String get screenMaySleep;

  /// No description provided for @mqttSubscribe.
  ///
  /// In en, this message translates to:
  /// **'MQTT Subscribe'**
  String get mqttSubscribe;

  /// No description provided for @mqttPublish.
  ///
  /// In en, this message translates to:
  /// **'MQTT Publish'**
  String get mqttPublish;

  /// No description provided for @topicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topicLabel;

  /// No description provided for @topicSubHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. home/sensor/# or home/sensor/temp'**
  String get topicSubHint;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @humanReadableJson.
  ///
  /// In en, this message translates to:
  /// **'Human-readable JSON'**
  String get humanReadableJson;

  /// No description provided for @waitingForMessages.
  ///
  /// In en, this message translates to:
  /// **'Waiting for messages…'**
  String get waitingForMessages;

  /// No description provided for @enterTopicListen.
  ///
  /// In en, this message translates to:
  /// **'Enter a topic and tap Listen'**
  String get enterTopicListen;

  /// No description provided for @tapListenReceive.
  ///
  /// In en, this message translates to:
  /// **'Tap Listen to start receiving'**
  String get tapListenReceive;

  /// No description provided for @enterTopicTapListen.
  ///
  /// In en, this message translates to:
  /// **'Enter the topic and tap Listen'**
  String get enterTopicTapListen;

  /// No description provided for @enterTopicFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter a topic first.'**
  String get enterTopicFirst;

  /// No description provided for @stoppedStatus.
  ///
  /// In en, this message translates to:
  /// **'Stopped.'**
  String get stoppedStatus;

  /// No description provided for @connectingStatus.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connectingStatus;

  /// No description provided for @reconnectingStatus.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get reconnectingStatus;

  /// No description provided for @listeningOn.
  ///
  /// In en, this message translates to:
  /// **'Listening on \"{topic}\"'**
  String listeningOn(Object topic);

  /// No description provided for @connFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {e}'**
  String connFailed(Object e);

  /// No description provided for @topicPubHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. home/light/switch'**
  String get topicPubHint;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @enterPayload.
  ///
  /// In en, this message translates to:
  /// **'Enter payload…'**
  String get enterPayload;

  /// No description provided for @retain.
  ///
  /// In en, this message translates to:
  /// **'Retain'**
  String get retain;

  /// No description provided for @retainSub.
  ///
  /// In en, this message translates to:
  /// **'Broker keeps the last message for new subscribers.'**
  String get retainSub;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @connectedEnterTopic.
  ///
  /// In en, this message translates to:
  /// **'Connected — enter a topic below'**
  String get connectedEnterTopic;

  /// No description provided for @connectedTopic.
  ///
  /// In en, this message translates to:
  /// **'Connected — topic: \"{topic}\"'**
  String connectedTopic(Object topic);

  /// No description provided for @disconnectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnectedStatus;

  /// No description provided for @publishedTo.
  ///
  /// In en, this message translates to:
  /// **'Published to \"{topic}\"'**
  String publishedTo(Object topic);

  /// No description provided for @about5GhzChannels.
  ///
  /// In en, this message translates to:
  /// **'About 5 GHz channels'**
  String get about5GhzChannels;

  /// No description provided for @wifiBandInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Dual access point detection in 5 GHz network'**
  String get wifiBandInfoTitle;

  /// No description provided for @wifiBandInfoBody.
  ///
  /// In en, this message translates to:
  /// **'💡 Hold SSID to see full Access Point name.\n\nℹ️ On the 5 GHz band you will usually see each access point appear on two (or more) channels at once. That is normal.\n\nTo go faster, modern routers glue neighbouring 20 MHz channels together into one wider lane — 40, 80, or even 160 MHz. This is called \"channel bonding\". A wider lane carries more data, just like a wider road carries more cars.\n\nWith \"dynamic channel width\" the router picks the widest lane it can and narrows it automatically when the air gets busy or noisy, so it stays fast without stepping on the neighbours.\n\nSo a single 5 GHz network showing on channels 36 and 40, for example, is just one access point using an 40 MHz-wide bonded channel — not two separate networks.'**
  String get wifiBandInfoBody;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results.'**
  String get noResults;

  /// No description provided for @scanErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Scan error'**
  String get scanErrorPrefix;

  /// No description provided for @noBandNetworks.
  ///
  /// In en, this message translates to:
  /// **'No {band} networks detected.'**
  String noBandNetworks(Object band);

  /// No description provided for @securityLabel.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityLabel;

  /// No description provided for @qualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get qualityLabel;

  /// No description provided for @qExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get qExcellent;

  /// No description provided for @qGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get qGood;

  /// No description provided for @qFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get qFair;

  /// No description provided for @qWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get qWeak;

  /// No description provided for @qPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get qPoor;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @cellShowingDemo.
  ///
  /// In en, this message translates to:
  /// **'Showing demo data.'**
  String get cellShowingDemo;

  /// No description provided for @noDataReturned.
  ///
  /// In en, this message translates to:
  /// **'No data returned from device.'**
  String get noDataReturned;

  /// No description provided for @platformErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Platform error'**
  String get platformErrorPrefix;

  /// No description provided for @carrier.
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get carrier;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @roaming.
  ///
  /// In en, this message translates to:
  /// **'Roaming'**
  String get roaming;

  /// No description provided for @dataState.
  ///
  /// In en, this message translates to:
  /// **'Data state'**
  String get dataState;

  /// No description provided for @signalQuality.
  ///
  /// In en, this message translates to:
  /// **'Signal Quality'**
  String get signalQuality;

  /// No description provided for @cellTower.
  ///
  /// In en, this message translates to:
  /// **'Cell Tower'**
  String get cellTower;

  /// No description provided for @cellId.
  ///
  /// In en, this message translates to:
  /// **'Cell ID'**
  String get cellId;

  /// No description provided for @bandLabel.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get bandLabel;

  /// No description provided for @estDistance.
  ///
  /// In en, this message translates to:
  /// **'Est. distance'**
  String get estDistance;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locating;

  /// No description provided for @nearestPlace.
  ///
  /// In en, this message translates to:
  /// **'Nearest place'**
  String get nearestPlace;

  /// No description provided for @deniedByUser.
  ///
  /// In en, this message translates to:
  /// **'Denied by the user'**
  String get deniedByUser;

  /// No description provided for @unavailablePrefix.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailablePrefix;

  /// No description provided for @signalStrength.
  ///
  /// In en, this message translates to:
  /// **'Signal strength'**
  String get signalStrength;

  /// No description provided for @rsrpHint.
  ///
  /// In en, this message translates to:
  /// **'RSRP — Reference Signal Received Power.\n\nThe average power of the cell\'s reference signals, measured in dBm. It reflects raw signal strength.\n\nTypical range: about −80 dBm (excellent) down to −120 dBm (very weak). Higher (closer to zero) is better.'**
  String get rsrpHint;

  /// No description provided for @rsrqHint.
  ///
  /// In en, this message translates to:
  /// **'RSRQ — Reference Signal Received Quality.\n\nSignal quality in dB, factoring in interference and network load alongside strength.\n\nTypical range: about −3 dB (excellent) down to −20 dB (poor). Higher is better.'**
  String get rsrqHint;

  /// No description provided for @sinrHint.
  ///
  /// In en, this message translates to:
  /// **'SINR — Signal to Interference-plus-Noise Ratio.\n\nHow much the wanted signal exceeds interference plus background noise, in dB.\n\nHigher is better: above ~20 dB is excellent, around 0 dB or below is poor.'**
  String get sinrHint;

  /// No description provided for @pciHint.
  ///
  /// In en, this message translates to:
  /// **'PCI — Physical Cell ID.\n\nA number (0–503 on LTE) that identifies the serving cell on the radio interface. Neighbouring cells use different PCIs so the phone can tell them apart.'**
  String get pciHint;

  /// No description provided for @earfcnHint.
  ///
  /// In en, this message translates to:
  /// **'EARFCN — E-UTRA Absolute Radio Frequency Channel Number.\n\nIdentifies the exact carrier frequency the device is using; it maps to a specific LTE band and channel.'**
  String get earfcnHint;

  /// No description provided for @estDistHint.
  ///
  /// In en, this message translates to:
  /// **'Estimated distance to the cell tower.\n\nDerived from signal strength (RSRP) using a radio propagation model. It is a very rough, order-of-magnitude indication only — not a precise measurement.'**
  String get estDistHint;
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
