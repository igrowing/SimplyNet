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

  @override
  String get stop => 'Стоп';

  @override
  String get clear => 'Очистити';

  @override
  String get copy => 'Копіювати';

  @override
  String get copied => 'Скопійовано';

  @override
  String get copyIp => 'Копіювати IP';

  @override
  String get hostHint => 'IP-адреса або ім\'я хоста';

  @override
  String get domainHostHint => 'Домен, IP-адреса або ім\'я хоста';

  @override
  String get go => 'Пуск';

  @override
  String get trace => 'Трасувати';

  @override
  String get lookUp => 'Знайти';

  @override
  String get lookingUp => 'Пошук…';

  @override
  String get enterHostGo => 'Введіть хост і натисніть Пуск';

  @override
  String get enterHostTrace => 'Введіть хост і натисніть Трасувати';

  @override
  String get enterHostScan => 'Введіть хост і натисніть Сканувати';

  @override
  String get enterDomainIp => 'Введіть домен, IP або ім\'я хоста';

  @override
  String get aboutPing => 'Про Ping';

  @override
  String get aboutTraceroute => 'Про Traceroute';

  @override
  String get aboutWhois => 'Про Who Is';

  @override
  String get aboutPortScan => 'Про сканування портів';

  @override
  String get hiddenNode => 'Прихований вузол';

  @override
  String get destination => 'Призначення';

  @override
  String get yourRouter => 'Ваш маршрутизатор';

  @override
  String get networkHop => 'Мережевий вузол';

  @override
  String get hop => 'Вузол';

  @override
  String get noReply => 'немає відповіді';

  @override
  String get probingNextHop => 'Перевірка наступного вузла…';

  @override
  String get hiddenNodeInfo =>
      'Цей маршрутизатор не відповів на наші запити. Багато інтернет-провайдерів, брандмауерів і пристроїв безпеки навмисно відкидають або обмежують трафік ICMP (ping), тож вузол залишається анонімним, хоча ваші дані все одно проходять через нього.\n\nЦе нормально й не означає, що маршрут порушено.';

  @override
  String get portsLabel => 'Порти:';

  @override
  String get wellKnown => 'Відомі';

  @override
  String get rangeLabel => 'Діапазон';

  @override
  String get fromLabel => 'Від:';

  @override
  String get toLabel => 'До:';

  @override
  String get protocolLabel => 'Протокол:';

  @override
  String get hideSettings => 'Сховати налаштування';

  @override
  String get myPublicIp => 'Мій публічний IP';

  @override
  String get errorLabel => 'Помилка';

  @override
  String get infoUnavailable => 'Інформація недоступна.';

  @override
  String get startTest => 'Почати тест';

  @override
  String get download => 'Завантаження';

  @override
  String get upload => 'Віддача';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusDone => 'Готово';

  @override
  String get measuringPing => 'Вимірювання ping…';

  @override
  String get findingServer => 'Пошук сервера…';

  @override
  String get testingDownload => 'Тест завантаження…';

  @override
  String get testingUpload => 'Тест віддачі…';

  @override
  String get viaCloudflare => 'Через Cloudflare';

  @override
  String get viaOokla => 'Через Ookla';

  @override
  String get aboutSpeedTestTip => 'Про тест швидкості';

  @override
  String get speedTestInfo => 'Про тест швидкості';

  @override
  String get previousMeasurements => 'Попередні вимірювання';

  @override
  String get noMeasurements => 'Вимірювань поки немає.';

  @override
  String get dateTime => 'Дата / Час';

  @override
  String get switchToOokla => 'Перейти на Ookla?';

  @override
  String get ooklaConsentBody =>
      'Перехід на Ookla потребує підключення до сторонніх серверів. Ookla збирає та передає вашу IP-адресу, ідентифікатори пристрою й дані про місцезнаходження.';

  @override
  String get decline => 'Відхилити';

  @override
  String get accept => 'Прийняти';

  @override
  String get clearHistoryTitle => 'Очистити історію?';

  @override
  String get clearHistoryBody => 'Це назавжди видалить усі записи вимірювань.';

  @override
  String get aboutThisScan => 'Про це сканування';

  @override
  String get scanInfoBody =>
      'Пристрої, що блокують ICMP (ping), тут не відображаються. Запустіть сканування «IoT-пристрої» або «IP-камери», щоб знайти їх за відкритими портами та службами.\n\nНа пристроях Android 11+ MAC-адреси не можна отримати через обмеження приватності Google, тож вони не відображаються.';

  @override
  String get stopScan => 'Зупинити сканування';

  @override
  String get reScan => 'Пересканувати';

  @override
  String get hostsFound => 'хостів знайдено';

  @override
  String get hostname => 'Ім\'я хоста';

  @override
  String get noSavedResults => 'Немає збережених результатів';

  @override
  String get noNetworkTarget => 'Ціль мережі не задано';

  @override
  String get tapRefreshToScan => 'Натисніть кнопку оновлення для сканування';

  @override
  String get setTargetHome => 'Задайте ціль на головному екрані';

  @override
  String get openInBrowser => 'Відкрити у браузері (HTTP)';

  @override
  String get openSsh => 'Відкрити SSH';

  @override
  String get couldNotOpenBrowser => 'Не вдалося відкрити браузер';

  @override
  String get noSshApp =>
      'Застосунок SSH не знайдено. Встановіть ConnectBot або Termius.';

  @override
  String get deviceInfo => 'Відомості про пристрій';

  @override
  String get ipAddress => 'IP-адреса';

  @override
  String get macAddress => 'MAC-адреса';

  @override
  String get manufacturer => 'Виробник';

  @override
  String get deviceTypeLabel => 'Тип пристрою';

  @override
  String get openPorts => 'Відкриті порти';

  @override
  String get stopPortScan => 'Зупинити сканування портів';

  @override
  String get portScanSettings => 'Налаштування сканування портів';

  @override
  String get reScanPorts => 'Пересканувати порти';

  @override
  String get noOpenPorts => 'Відкритих портів не знайдено.';

  @override
  String get applyRescan => 'Застосувати й пересканувати';

  @override
  String get diagnostics => 'Діагностика';

  @override
  String get times => 'разів';

  @override
  String get deleteAllLogs => 'Видалити всі журнали';

  @override
  String get deleteAllLogsQ => 'Видалити всі журнали?';

  @override
  String get cannotBeUndone => 'Цю дію не можна скасувати.';

  @override
  String get deleteAll => 'Видалити всі';

  @override
  String get deleteLogQ => 'Видалити журнал?';

  @override
  String get noLogsYet => 'Ще немає журналів';

  @override
  String get scanningEllipsis => 'Сканування…';

  @override
  String get iotDevicesFound => 'пристроїв IoT знайдено';

  @override
  String get iotNoSaved =>
      'Немає збережених результатів.\nНатисніть оновити для сканування.';

  @override
  String get unknown => 'Невідомо';

  @override
  String get viaLabel => 'через';

  @override
  String get confDefinite => 'точно';

  @override
  String get confProbable => 'ймовірно';

  @override
  String get confPossible => 'можливо';

  @override
  String get ipCameraScan => 'Сканування IP-камер';

  @override
  String get camMethodProtocolPort => 'Порт протоколу';

  @override
  String get camMethodKnownVendor => 'Відомий виробник';

  @override
  String get camMethodHttpFingerprint => 'HTTP-відбиток';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Сканування… $done/$total хостів — $n камер';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Немає збережених результатів — натисніть оновити для сканування $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return 'Знайдено камер: $n — $cidr';
  }

  @override
  String get noCamerasFound => 'Камер не знайдено.';

  @override
  String get mqttSettingsTitle => 'Налаштування MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN брокера';

  @override
  String get searchingSubnet => 'Пошук у підмережі…';

  @override
  String get brokerHint => 'напр. 192.168.1.10 або broker.example.com';

  @override
  String get portLabel => 'Порт';

  @override
  String get usernameOptional => 'Ім\'я користувача (необов\'язково)';

  @override
  String get leaveEmptyOptional => 'залиште порожнім, якщо не потрібно';

  @override
  String get passwordOptional => 'Пароль (необов\'язково)';

  @override
  String get keepPassword => 'Зберігати пароль (не рекомендовано)';

  @override
  String get keepPasswordSub =>
      'Пароль зберігається у відкритому вигляді в сховищі застосунку.';

  @override
  String get save => 'Зберегти';

  @override
  String get screenStaysOn => 'Екран не гасне';

  @override
  String get screenMaySleep => 'Екран може згаснути';

  @override
  String get mqttSubscribe => 'MQTT Підписка';

  @override
  String get mqttPublish => 'MQTT Публікація';

  @override
  String get topicLabel => 'Тема';

  @override
  String get topicSubHint => 'напр. home/sensor/# або home/sensor/temp';

  @override
  String get listen => 'Слухати';

  @override
  String get humanReadableJson => 'Читабельний JSON';

  @override
  String get waitingForMessages => 'Очікування повідомлень…';

  @override
  String get enterTopicListen => 'Введіть тему й натисніть Слухати';

  @override
  String get tapListenReceive => 'Натисніть Слухати, щоб почати отримання';

  @override
  String get enterTopicTapListen => 'Введіть тему й натисніть Слухати';

  @override
  String get enterTopicFirst => 'Спершу введіть тему.';

  @override
  String get stoppedStatus => 'Зупинено.';

  @override
  String get connectingStatus => 'Підключення…';

  @override
  String get reconnectingStatus => 'Перепідключення…';

  @override
  String listeningOn(Object topic) {
    return 'Прослуховування \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Помилка підключення: $e';
  }

  @override
  String get topicPubHint => 'напр. home/light/switch';

  @override
  String get messageLabel => 'Повідомлення';

  @override
  String get enterPayload => 'Введіть дані…';

  @override
  String get retain => 'Утримувати';

  @override
  String get retainSub =>
      'Брокер зберігає останнє повідомлення для нових підписників.';

  @override
  String get publish => 'Опублікувати';

  @override
  String get connectedEnterTopic => 'Підключено — введіть тему нижче';

  @override
  String connectedTopic(Object topic) {
    return 'Підключено — тема: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Відключено';

  @override
  String publishedTo(Object topic) {
    return 'Опубліковано в \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'Про канали 5 ГГц';

  @override
  String get wifiBandInfoTitle =>
      'Виявлення подвійної точки доступу в мережі 5 ГГц';

  @override
  String get wifiBandInfoBody =>
      '💡 Утримуйте SSID, щоб побачити повне ім\'я точки доступу.\n\nℹ️ У діапазоні 5 ГГц ви зазвичай побачите кожну точку доступу одразу на двох (або більше) каналах. Це нормально.\n\nЩоб працювати швидше, сучасні роутери об\'єднують сусідні канали по 20 МГц в одну ширшу смугу — 40, 80 або навіть 160 МГц. Це називається \"об\'єднанням каналів\". Ширша смуга несе більше даних, як ширша дорога вміщує більше машин.\n\nЗа \"динамічної ширини каналу\" роутер обирає найширшу доступну смугу і автоматично звужує її, коли ефір завантажений чи зашумлений, залишаючись швидким і не заважаючи сусідам.\n\nОтже, одна мережа 5 ГГц, що відображається, наприклад, на каналах 36 і 40, — це лише одна точка доступу, яка використовує об\'єднаний канал шириною 40 МГц, а не дві окремі мережі.';

  @override
  String get noResults => 'Немає результатів.';

  @override
  String get scanErrorPrefix => 'Помилка сканування';

  @override
  String noBandNetworks(Object band) {
    return 'Мережі $band не виявлено.';
  }

  @override
  String get securityLabel => 'Захист';

  @override
  String get qualityLabel => 'Якість';

  @override
  String get qExcellent => 'Відмінно';

  @override
  String get qGood => 'Добре';

  @override
  String get qFair => 'Задовільно';

  @override
  String get qWeak => 'Слабко';

  @override
  String get qPoor => 'Погано';

  @override
  String get refresh => 'Оновити';

  @override
  String get cellShowingDemo => 'Показано демонстраційні дані.';

  @override
  String get noDataReturned => 'Пристрій не повернув даних.';

  @override
  String get platformErrorPrefix => 'Помилка платформи';

  @override
  String get carrier => 'Оператор';

  @override
  String get provider => 'Провайдер';

  @override
  String get technology => 'Технологія';

  @override
  String get roaming => 'Роумінг';

  @override
  String get dataState => 'Стан даних';

  @override
  String get signalQuality => 'Якість сигналу';

  @override
  String get cellTower => 'Стільникова вежа';

  @override
  String get cellId => 'ID соти';

  @override
  String get bandLabel => 'Діапазон';

  @override
  String get estDistance => 'Відстань (оцінка)';

  @override
  String get location => 'Місцезнаходження';

  @override
  String get coordinates => 'Координати';

  @override
  String get locating => 'Визначення розташування…';

  @override
  String get nearestPlace => 'Найближче місце';

  @override
  String get deniedByUser => 'Відхилено користувачем';

  @override
  String get unavailablePrefix => 'Недоступно';

  @override
  String get signalStrength => 'Рівень сигналу';

  @override
  String get rsrpHint =>
      'RSRP — потужність прийнятого опорного сигналу.\n\nСередня потужність опорних сигналів соти, вимірюється в дБм. Відображає вихідний рівень сигналу.\n\nТиповий діапазон: приблизно від −80 дБм (відмінно) до −120 дБм (дуже слабко). Вище (ближче до нуля) — краще.';

  @override
  String get rsrqHint =>
      'RSRQ — якість прийнятого опорного сигналу.\n\nЯкість сигналу в дБ, що враховує окрім сили також завади та навантаження мережі.\n\nТиповий діапазон: приблизно від −3 дБ (відмінно) до −20 дБ (погано). Вище — краще.';

  @override
  String get sinrHint =>
      'SINR — відношення сигнал/(завада+шум).\n\nНаскільки корисний сигнал перевищує завади плюс фоновий шум, у дБ.\n\nВище — краще: вище ~20 дБ — відмінно, близько 0 дБ або нижче — погано.';

  @override
  String get pciHint =>
      'PCI — фізичний ідентифікатор соти.\n\nЧисло (0–503 у LTE), що ідентифікує обслуговуючу соту на радіоінтерфейсі. Сусідні соти використовують різні PCI, щоб телефон міг їх розрізняти.';

  @override
  String get earfcnHint =>
      'EARFCN — абсолютний номер радіочастотного каналу E-UTRA.\n\nВизначає точну несучу частоту, яку використовує пристрій; відповідає конкретному діапазону та каналу LTE.';

  @override
  String get estDistHint =>
      'Оцінена відстань до стільникової вежі.\n\nОбчислено з рівня сигналу (RSRP) за допомогою моделі поширення радіохвиль. Це лише дуже груба оцінка порядку величини — не точне вимірювання.';
}
