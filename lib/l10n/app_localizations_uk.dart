// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get appearance => 'Оформлення';

  @override
  String get language => 'Мова';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeAuto => 'Авто';

  @override
  String get screenOnTimeout => 'Тайм-аут екрана';

  @override
  String get timeoutSystem => 'Системний';

  @override
  String get timeoutTriple => '3× системний';

  @override
  String get timeoutStayOn => 'Не гасне';

  @override
  String get scanning => 'Сканування';

  @override
  String get showMacAddress => 'Показувати MAC-адресу';

  @override
  String get showMacBlocked =>
      'Вимкнено на Android v.11 і вище через політику конфіденційності Google';

  @override
  String get showMacSubtitle =>
      'Показувати стовпець MAC у результатах сканування';

  @override
  String get resolveHostnames => 'Визначати імена вузлів';

  @override
  String get resolveHostnamesSubtitle =>
      'Виконувати зворотний DNS + mDNS під час сканування';

  @override
  String get enableLogging => 'Увімкнути журнал';

  @override
  String get enableLoggingSubtitle =>
      'Зберігати вивід сканування та інструментів у файли журналу';

  @override
  String get account => 'Обліковий запис';

  @override
  String get logIn => 'Увійти';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get settings => 'Налаштування';

  @override
  String get aboutSimplyNet => 'Про SimplyNet';

  @override
  String get scan => 'Сканувати';

  @override
  String get logs => 'Журнали';

  @override
  String get networkTools => 'Мережеві інструменти';

  @override
  String get networkTarget => 'Ціль мережі';

  @override
  String get networkTargetHint => 'напр. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'Недійсний CIDR — використовуйте формат на кшталт 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Визначити мою мережу';

  @override
  String get toolSpeedTest => 'Тест швидкості';

  @override
  String get toolSpeedTestSub => 'Швидкість завантаження й віддачі';

  @override
  String get toolPublicIp => 'Публічний IP';

  @override
  String get toolPublicIpSub => 'Ваш IP, провайдер і місцезнаходження';

  @override
  String get toolIpCameras => 'IP-камери';

  @override
  String get toolIpCamerasSub => 'Знайти камери у вашій мережі';

  @override
  String get toolIotDevices => 'Пристрої IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly та інші';

  @override
  String get toolMqttSub => 'MQTT-підписка';

  @override
  String get toolMqttSubSub => 'Підписатися на топік MQTT';

  @override
  String get toolMqttPub => 'MQTT-публікація';

  @override
  String get toolMqttPubSub => 'Опублікувати в топік MQTT';

  @override
  String get toolPortScan => 'Сканування портів';

  @override
  String get toolPortScanSub => 'Відкриті порти TCP/UDP на будь-якому вузлі';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping у реальному часі з графіком';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Покроковий маршрут до будь-якого вузла';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS та зворотний пошук';

  @override
  String get toolWifiChannels => 'Канали Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Карта завад 2,4 і 5 ГГц';

  @override
  String get toolCellularInfo => 'Дані стільникової мережі';

  @override
  String get toolCellularInfoSub => 'Сигнал, ID соти та дані вежі';

  @override
  String get about => 'Про програму';

  @override
  String get close => 'Закрити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get ok => 'Гаразд';

  @override
  String get delete => 'Видалити';

  @override
  String get retry => 'Повторити';
}
