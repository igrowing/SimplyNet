// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get appearance => 'Vzhled';

  @override
  String get language => 'Jazyk';

  @override
  String get theme => 'Motiv';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Časový limit obrazovky';

  @override
  String get timeoutSystem => 'Systém';

  @override
  String get timeoutTriple => '3× systém';

  @override
  String get timeoutStayOn => 'Nechat zapnuté';

  @override
  String get scanning => 'Skenování';

  @override
  String get showMacAddress => 'Zobrazit adresu MAC';

  @override
  String get showMacBlocked =>
      'Zakázáno na Androidu v.11 a novějším kvůli ochraně soukromí Google';

  @override
  String get showMacSubtitle => 'Zobrazit sloupec MAC ve výsledcích skenování';

  @override
  String get resolveHostnames => 'Překládat názvy hostitelů';

  @override
  String get resolveHostnamesSubtitle =>
      'Provádět reverzní DNS + mDNS během skenování';

  @override
  String get enableLogging => 'Povolit protokolování';

  @override
  String get enableLoggingSubtitle =>
      'Ukládat výstup skenování a nástrojů do souborů protokolu';

  @override
  String get account => 'Účet';

  @override
  String get logIn => 'Přihlásit se';

  @override
  String get comingSoon => 'Již brzy';

  @override
  String get settings => 'Nastavení';

  @override
  String get aboutSimplyNet => 'O aplikaci SimplyNet';

  @override
  String get scan => 'Skenovat';

  @override
  String get logs => 'Protokoly';

  @override
  String get networkTools => 'Síťové nástroje';

  @override
  String get networkTarget => 'Cíl sítě';

  @override
  String get networkTargetHint => 'např. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'Neplatný CIDR — použijte formát jako 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Zjistit moji síť';

  @override
  String get toolSpeedTest => 'Test rychlosti';

  @override
  String get toolSpeedTestSub => 'Rychlost stahování a odesílání';

  @override
  String get toolPublicIp => 'Veřejná IP';

  @override
  String get toolPublicIpSub => 'Vaše IP, ISP a poloha';

  @override
  String get toolIpCameras => 'IP kamery';

  @override
  String get toolIpCamerasSub => 'Najít kamery v síti LAN';

  @override
  String get toolIotDevices => 'Zařízení IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly a další';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Přihlásit odběr tématu MQTT';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publikovat do tématu MQTT';

  @override
  String get toolPortScan => 'Sken portů';

  @override
  String get toolPortScanSub =>
      'Otevřené porty TCP/UDP na libovolném hostiteli';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Živý ping s grafem';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Cesta skok po skoku k libovolnému hostiteli';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS a zpětné vyhledávání';

  @override
  String get toolWifiChannels => 'Kanály Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Mapa rušení 2,4 a 5 GHz';

  @override
  String get toolCellularInfo => 'Informace o mobilní síti';

  @override
  String get toolCellularInfoSub => 'Signál, ID buňky a data vysílače';

  @override
  String get about => 'O aplikaci';

  @override
  String get close => 'Zavřít';

  @override
  String get cancel => 'Zrušit';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Smazat';

  @override
  String get retry => 'Zkusit znovu';
}
