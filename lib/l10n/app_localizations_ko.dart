// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Screen On Timeout';

  @override
  String get timeoutSystem => 'System';

  @override
  String get timeoutTriple => '3× System';

  @override
  String get timeoutStayOn => 'Stay On';

  @override
  String get scanning => 'Scanning';

  @override
  String get showMacAddress => 'Show MAC Address';

  @override
  String get showMacBlocked =>
      'Disabled on Android v.11 and up due to Google privacy concerns';

  @override
  String get showMacSubtitle => 'Display MAC column in scan results';

  @override
  String get resolveHostnames => 'Resolve Hostnames';

  @override
  String get resolveHostnamesSubtitle =>
      'Perform reverse-DNS + mDNS during scan';

  @override
  String get enableLogging => 'Enable Logging';

  @override
  String get enableLoggingSubtitle => 'Save scan and tool output to log files';

  @override
  String get account => 'Account';

  @override
  String get logIn => 'Log In';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get settings => 'Settings';

  @override
  String get aboutSimplyNet => 'About SimplyNet';

  @override
  String get scan => 'Scan';

  @override
  String get logs => 'Logs';

  @override
  String get networkTools => 'Network Tools';

  @override
  String get networkTarget => 'Network Target';

  @override
  String get networkTargetHint => 'e.g. 192.168.1.0/24';

  @override
  String get invalidCidr => 'Invalid CIDR — use format like 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Detect my network';

  @override
  String get toolSpeedTest => 'Speed Test';

  @override
  String get toolSpeedTestSub => 'Download & upload speed';

  @override
  String get toolPublicIp => 'Public IP';

  @override
  String get toolPublicIpSub => 'Your IP, ISP & location';

  @override
  String get toolIpCameras => 'IP Cameras';

  @override
  String get toolIpCamerasSub => 'Find cameras on your LAN';

  @override
  String get toolIotDevices => 'IoT Devices';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly & more';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Subscribe to an MQTT topic';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publish to an MQTT topic';

  @override
  String get toolPortScan => 'Port Scan';

  @override
  String get toolPortScanSub => 'Open TCP/UDP ports on any host';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Live ping with graph';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Hop-by-hop path to any host';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS & reverse lookup';

  @override
  String get toolWifiChannels => 'Wi-Fi Channels';

  @override
  String get toolWifiChannelsSub => '2.4 & 5 GHz interference map';

  @override
  String get toolCellularInfo => 'Cellular Info';

  @override
  String get toolCellularInfoSub => 'Signal, cell ID & tower data';

  @override
  String get about => 'About';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';
}
