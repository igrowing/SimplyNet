// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get appearance => 'Wygląd';

  @override
  String get language => 'Język';

  @override
  String get theme => 'Motyw';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Limit czasu ekranu';

  @override
  String get timeoutSystem => 'Systemowy';

  @override
  String get timeoutTriple => '3× systemowy';

  @override
  String get timeoutStayOn => 'Zawsze wł.';

  @override
  String get scanning => 'Skanowanie';

  @override
  String get showMacAddress => 'Pokaż adres MAC';

  @override
  String get showMacBlocked =>
      'Wyłączone w Androidzie v.11 i nowszym ze względu na prywatność Google';

  @override
  String get showMacSubtitle => 'Pokaż kolumnę MAC w wynikach skanowania';

  @override
  String get resolveHostnames => 'Rozwiązuj nazwy hostów';

  @override
  String get resolveHostnamesSubtitle =>
      'Wykonaj odwrotny DNS + mDNS podczas skanowania';

  @override
  String get enableLogging => 'Włącz dziennik';

  @override
  String get enableLoggingSubtitle =>
      'Zapisuj wynik skanowania i narzędzi do plików dziennika';

  @override
  String get account => 'Konto';

  @override
  String get logIn => 'Zaloguj się';

  @override
  String get comingSoon => 'Wkrótce';

  @override
  String get settings => 'Ustawienia';

  @override
  String get aboutSimplyNet => 'O SimplyNet';

  @override
  String get scan => 'Skanuj';

  @override
  String get logs => 'Dzienniki';

  @override
  String get networkTools => 'Narzędzia sieciowe';

  @override
  String get networkTarget => 'Cel sieci';

  @override
  String get networkTargetHint => 'np. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'Nieprawidłowy CIDR — użyj formatu takiego jak 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Wykryj moją sieć';

  @override
  String get toolSpeedTest => 'Test prędkości';

  @override
  String get toolSpeedTestSub => 'Prędkość pobierania i wysyłania';

  @override
  String get toolPublicIp => 'Publiczny IP';

  @override
  String get toolPublicIpSub => 'Twój IP, ISP i lokalizacja';

  @override
  String get toolIpCameras => 'Kamery IP';

  @override
  String get toolIpCamerasSub => 'Znajdź kamery w sieci LAN';

  @override
  String get toolIotDevices => 'Urządzenia IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly i inne';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Subskrybuj temat MQTT';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publikuj w temacie MQTT';

  @override
  String get toolPortScan => 'Skan portów';

  @override
  String get toolPortScanSub => 'Otwarte porty TCP/UDP na dowolnym hoście';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping na żywo z wykresem';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Ścieżka skok po skoku do dowolnego hosta';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS i wyszukiwanie wsteczne';

  @override
  String get toolWifiChannels => 'Kanały Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Mapa zakłóceń 2,4 i 5 GHz';

  @override
  String get toolCellularInfo => 'Informacje o sieci komórkowej';

  @override
  String get toolCellularInfoSub => 'Sygnał, ID komórki i dane masztu';

  @override
  String get about => 'O aplikacji';

  @override
  String get close => 'Zamknij';

  @override
  String get cancel => 'Anuluj';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Usuń';

  @override
  String get retry => 'Ponów';
}
