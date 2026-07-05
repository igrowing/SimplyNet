// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get appearance => 'Оформление';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeAuto => 'Авто';

  @override
  String get screenOnTimeout => 'Тайм-аут экрана';

  @override
  String get timeoutSystem => 'Системный';

  @override
  String get timeoutTriple => '3× системный';

  @override
  String get timeoutStayOn => 'Не гаснет';

  @override
  String get scanning => 'Сканирование';

  @override
  String get showMacAddress => 'Показывать MAC-адрес';

  @override
  String get showMacBlocked =>
      'Отключено на Android v.11 и выше из-за политики конфиденциальности Google';

  @override
  String get showMacSubtitle =>
      'Показывать столбец MAC в результатах сканирования';

  @override
  String get resolveHostnames => 'Определять имена узлов';

  @override
  String get resolveHostnamesSubtitle =>
      'Выполнять обратный DNS + mDNS при сканировании';

  @override
  String get enableLogging => 'Включить журнал';

  @override
  String get enableLoggingSubtitle =>
      'Сохранять вывод сканирования и инструментов в файлы журнала';

  @override
  String get account => 'Аккаунт';

  @override
  String get logIn => 'Войти';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get settings => 'Настройки';

  @override
  String get aboutSimplyNet => 'О SimplyNet';

  @override
  String get scan => 'Сканировать';

  @override
  String get logs => 'Журналы';

  @override
  String get networkTools => 'Сетевые инструменты';

  @override
  String get networkTarget => 'Цель сети';

  @override
  String get networkTargetHint => 'напр. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'Неверный CIDR — используйте формат вида 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Определить мою сеть';

  @override
  String get toolSpeedTest => 'Тест скорости';

  @override
  String get toolSpeedTestSub => 'Скорость загрузки и отдачи';

  @override
  String get toolPublicIp => 'Публичный IP';

  @override
  String get toolPublicIpSub => 'Ваш IP, провайдер и местоположение';

  @override
  String get toolIpCameras => 'IP-камеры';

  @override
  String get toolIpCamerasSub => 'Найти камеры в вашей сети';

  @override
  String get toolIotDevices => 'Устройства IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly и другие';

  @override
  String get toolMqttSub => 'MQTT-подписка';

  @override
  String get toolMqttSubSub => 'Подписаться на топик MQTT';

  @override
  String get toolMqttPub => 'MQTT-публикация';

  @override
  String get toolMqttPubSub => 'Опубликовать в топик MQTT';

  @override
  String get toolPortScan => 'Скан портов';

  @override
  String get toolPortScanSub => 'Открытые порты TCP/UDP на любом узле';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping в реальном времени с графиком';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Пошаговый маршрут до любого узла';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS и обратный поиск';

  @override
  String get toolWifiChannels => 'Каналы Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Карта помех 2,4 и 5 ГГц';

  @override
  String get toolCellularInfo => 'Данные сотовой сети';

  @override
  String get toolCellularInfoSub => 'Сигнал, ID соты и данные вышки';

  @override
  String get about => 'О программе';

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get ok => 'ОК';

  @override
  String get delete => 'Удалить';

  @override
  String get retry => 'Повторить';
}
