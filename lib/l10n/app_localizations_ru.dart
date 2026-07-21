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

  @override
  String get stop => 'Стоп';

  @override
  String get clear => 'Очистить';

  @override
  String get copy => 'Копировать';

  @override
  String get copied => 'Скопировано';

  @override
  String get copyIp => 'Копировать IP';

  @override
  String get hostHint => 'IP-адрес или имя хоста';

  @override
  String get domainHostHint => 'Домен, IP-адрес или имя хоста';

  @override
  String get go => 'Пуск';

  @override
  String get trace => 'Трассировать';

  @override
  String get lookUp => 'Найти';

  @override
  String get lookingUp => 'Поиск…';

  @override
  String get enterHostGo => 'Введите хост и нажмите Пуск';

  @override
  String get enterHostTrace => 'Введите хост и нажмите Трассировать';

  @override
  String get enterHostScan => 'Введите хост и нажмите Сканировать';

  @override
  String get enterDomainIp => 'Введите домен, IP или имя хоста';

  @override
  String get aboutPing => 'О Ping';

  @override
  String get aboutTraceroute => 'О Traceroute';

  @override
  String get aboutWhois => 'О Who Is';

  @override
  String get aboutPortScan => 'О сканировании портов';

  @override
  String get hiddenNode => 'Скрытый узел';

  @override
  String get destination => 'Назначение';

  @override
  String get yourRouter => 'Ваш маршрутизатор';

  @override
  String get networkHop => 'Сетевой узел';

  @override
  String get hop => 'Узел';

  @override
  String get noReply => 'нет ответа';

  @override
  String get probingNextHop => 'Проверка следующего узла…';

  @override
  String get hiddenNodeInfo =>
      'Этот маршрутизатор не ответил на наши запросы. Многие интернет-провайдеры, брандмауэры и устройства безопасности намеренно отбрасывают или ограничивают трафик ICMP (ping), поэтому узел остаётся анонимным, хотя ваши данные всё равно проходят через него.\n\nЭто нормально и не означает, что маршрут нарушен.';

  @override
  String get portsLabel => 'Порты:';

  @override
  String get wellKnown => 'Известные';

  @override
  String get rangeLabel => 'Диапазон';

  @override
  String get fromLabel => 'От:';

  @override
  String get toLabel => 'До:';

  @override
  String get protocolLabel => 'Протокол:';

  @override
  String get hideSettings => 'Скрыть настройки';

  @override
  String get myPublicIp => 'Мой публичный IP';

  @override
  String get errorLabel => 'Ошибка';

  @override
  String get infoUnavailable => 'Информация недоступна.';

  @override
  String get startTest => 'Начать тест';

  @override
  String get download => 'Загрузка';

  @override
  String get upload => 'Отдача';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusDone => 'Готово';

  @override
  String get measuringPing => 'Измерение ping…';

  @override
  String get findingServer => 'Поиск сервера…';

  @override
  String get testingDownload => 'Тест загрузки…';

  @override
  String get testingUpload => 'Тест отдачи…';

  @override
  String get viaCloudflare => 'Через Cloudflare';

  @override
  String get viaOokla => 'Через Ookla';

  @override
  String get aboutSpeedTestTip => 'О тесте скорости';

  @override
  String get speedTestInfo => 'О тесте скорости';

  @override
  String get previousMeasurements => 'Предыдущие измерения';

  @override
  String get noMeasurements => 'Измерений пока нет.';

  @override
  String get dateTime => 'Дата / Время';

  @override
  String get switchToOokla => 'Переключиться на Ookla?';

  @override
  String get ooklaConsentBody =>
      'Переключение на Ookla требует подключения к сторонним серверам. Ookla собирает и передаёт ваш IP-адрес, идентификаторы устройства и данные о местоположении.';

  @override
  String get decline => 'Отклонить';

  @override
  String get accept => 'Принять';

  @override
  String get clearHistoryTitle => 'Очистить историю?';

  @override
  String get clearHistoryBody => 'Это навсегда удалит все записи измерений.';

  @override
  String get aboutThisScan => 'Об этом сканировании';

  @override
  String get scanInfoBody =>
      'Устройства, блокирующие ICMP (ping), здесь не отображаются. Запустите сканирование «IoT-устройства» или «IP-камеры», чтобы найти их по открытым портам и службам.\n\nНа устройствах Android 11+ MAC-адреса не могут быть получены из-за ограничений конфиденциальности Google, поэтому они не отображаются.';

  @override
  String get stopScan => 'Остановить сканирование';

  @override
  String get reScan => 'Пересканировать';

  @override
  String get hostsFound => 'хостов найдено';

  @override
  String get hostname => 'Имя хоста';

  @override
  String get noSavedResults => 'Нет сохранённых результатов';

  @override
  String get noNetworkTarget => 'Цель сети не задана';

  @override
  String get tapRefreshToScan => 'Нажмите кнопку обновления для сканирования';

  @override
  String get setTargetHome => 'Задайте цель на главном экране';

  @override
  String get openInBrowser => 'Открыть в браузере (HTTP)';

  @override
  String get openSsh => 'Открыть SSH';

  @override
  String get couldNotOpenBrowser => 'Не удалось открыть браузер';

  @override
  String get noSshApp =>
      'Приложение SSH не найдено. Установите ConnectBot или Termius.';

  @override
  String get deviceInfo => 'Сведения об устройстве';

  @override
  String get ipAddress => 'IP-адрес';

  @override
  String get macAddress => 'MAC-адрес';

  @override
  String get manufacturer => 'Производитель';

  @override
  String get deviceTypeLabel => 'Тип устройства';

  @override
  String get openPorts => 'Открытые порты';

  @override
  String get stopPortScan => 'Остановить сканирование портов';

  @override
  String get portScanSettings => 'Настройки сканирования портов';

  @override
  String get reScanPorts => 'Пересканировать порты';

  @override
  String get noOpenPorts => 'Открытые порты не найдены.';

  @override
  String get applyRescan => 'Применить и пересканировать';

  @override
  String get diagnostics => 'Диагностика';

  @override
  String get times => 'раз';

  @override
  String get deleteAllLogs => 'Удалить все журналы';

  @override
  String get deleteAllLogsQ => 'Удалить все журналы?';

  @override
  String get cannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get deleteLogQ => 'Удалить журнал?';

  @override
  String get noLogsYet => 'Пока нет журналов';

  @override
  String get scanningEllipsis => 'Сканирование…';

  @override
  String get iotDevicesFound => 'устройств IoT найдено';

  @override
  String get iotNoSaved =>
      'Нет сохранённых результатов.\nНажмите обновить для сканирования.';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get viaLabel => 'через';

  @override
  String get confDefinite => 'точно';

  @override
  String get confProbable => 'вероятно';

  @override
  String get confPossible => 'возможно';

  @override
  String get ipCameraScan => 'Сканирование IP-камер';

  @override
  String get camMethodProtocolPort => 'Порт протокола';

  @override
  String get camMethodKnownVendor => 'Известный производитель';

  @override
  String get camMethodHttpFingerprint => 'HTTP-отпечаток';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Сканирование… $done/$total хостов — $n камер';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Нет сохранённых результатов — нажмите обновить для сканирования $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return 'Найдено камер: $n — $cidr';
  }

  @override
  String get noCamerasFound => 'Камеры не найдены.';

  @override
  String get mqttSettingsTitle => 'Настройки MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN брокера';

  @override
  String get searchingSubnet => 'Поиск в подсети…';

  @override
  String get brokerHint => 'напр. 192.168.1.10 или broker.example.com';

  @override
  String get portLabel => 'Порт';

  @override
  String get usernameOptional => 'Имя пользователя (необязательно)';

  @override
  String get leaveEmptyOptional => 'оставьте пустым, если не требуется';

  @override
  String get passwordOptional => 'Пароль (необязательно)';

  @override
  String get keepPassword => 'Сохранять пароль (не рекомендуется)';

  @override
  String get keepPasswordSub =>
      'Пароль хранится в открытом виде в хранилище приложения.';

  @override
  String get save => 'Сохранить';

  @override
  String get screenStaysOn => 'Экран не гаснет';

  @override
  String get screenMaySleep => 'Экран может погаснуть';

  @override
  String get mqttSubscribe => 'MQTT Подписка';

  @override
  String get mqttPublish => 'MQTT Публикация';

  @override
  String get topicLabel => 'Топик';

  @override
  String get topicSubHint => 'напр. home/sensor/# или home/sensor/temp';

  @override
  String get listen => 'Слушать';

  @override
  String get humanReadableJson => 'Читаемый JSON';

  @override
  String get waitingForMessages => 'Ожидание сообщений…';

  @override
  String get enterTopicListen => 'Введите топик и нажмите Слушать';

  @override
  String get tapListenReceive => 'Нажмите Слушать, чтобы начать приём';

  @override
  String get enterTopicTapListen => 'Введите топик и нажмите Слушать';

  @override
  String get enterTopicFirst => 'Сначала введите топик.';

  @override
  String get stoppedStatus => 'Остановлено.';

  @override
  String get connectingStatus => 'Подключение…';

  @override
  String get reconnectingStatus => 'Переподключение…';

  @override
  String listeningOn(Object topic) {
    return 'Прослушивание \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Ошибка подключения: $e';
  }

  @override
  String get topicPubHint => 'напр. home/light/switch';

  @override
  String get messageLabel => 'Сообщение';

  @override
  String get enterPayload => 'Введите данные…';

  @override
  String get retain => 'Сохранять';

  @override
  String get retainSub =>
      'Брокер хранит последнее сообщение для новых подписчиков.';

  @override
  String get publish => 'Опубликовать';

  @override
  String get connectedEnterTopic => 'Подключено — введите топик ниже';

  @override
  String connectedTopic(Object topic) {
    return 'Подключено — топик: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Отключено';

  @override
  String publishedTo(Object topic) {
    return 'Опубликовано в \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'О каналах 5 ГГц';

  @override
  String get wifiBandInfoTitle =>
      'Обнаружение двойной точки доступа в сети 5 ГГц';

  @override
  String get wifiBandInfoBody =>
      '💡 Удерживайте SSID, чтобы увидеть полное имя точки доступа.\n\nℹ️ В диапазоне 5 ГГц вы обычно увидите каждую точку доступа сразу на двух (или более) каналах. Это нормально.\n\nЧтобы работать быстрее, современные роутеры объединяют соседние каналы по 20 МГц в одну более широкую полосу — 40, 80 или даже 160 МГц. Это называется \"объединением каналов\". Более широкая полоса несёт больше данных, как более широкая дорога вмещает больше машин.\n\nПри \"динамической ширине канала\" роутер выбирает самую широкую доступную полосу и автоматически сужает её, когда эфир загружен или зашумлён, оставаясь быстрым и не мешая соседям.\n\nТак что одна сеть 5 ГГц, отображаемая, например, на каналах 36 и 40, — это просто одна точка доступа, использующая объединённый канал шириной 40 МГц, а не две отдельные сети.';

  @override
  String get noResults => 'Нет результатов.';

  @override
  String get scanErrorPrefix => 'Ошибка сканирования';

  @override
  String noBandNetworks(Object band) {
    return 'Сети $band не обнаружены.';
  }

  @override
  String get securityLabel => 'Защита';

  @override
  String get qualityLabel => 'Качество';

  @override
  String get qExcellent => 'Отлично';

  @override
  String get qGood => 'Хорошо';

  @override
  String get qFair => 'Средне';

  @override
  String get qWeak => 'Слабо';

  @override
  String get qPoor => 'Плохо';

  @override
  String get refresh => 'Обновить';

  @override
  String get cellShowingDemo => 'Показаны демонстрационные данные.';

  @override
  String get noDataReturned => 'Устройство не вернуло данные.';

  @override
  String get platformErrorPrefix => 'Ошибка платформы';

  @override
  String get carrier => 'Оператор';

  @override
  String get provider => 'Провайдер';

  @override
  String get technology => 'Технология';

  @override
  String get roaming => 'Роуминг';

  @override
  String get dataState => 'Состояние данных';

  @override
  String get signalQuality => 'Качество сигнала';

  @override
  String get cellTower => 'Сотовая вышка';

  @override
  String get cellId => 'ID соты';

  @override
  String get bandLabel => 'Диапазон';

  @override
  String get estDistance => 'Расст. (оценка)';

  @override
  String get location => 'Местоположение';

  @override
  String get coordinates => 'Координаты';

  @override
  String get locating => 'Определение местоположения…';

  @override
  String get nearestPlace => 'Ближайшее место';

  @override
  String get deniedByUser => 'Отклонено пользователем';

  @override
  String get unavailablePrefix => 'Недоступно';

  @override
  String get signalStrength => 'Уровень сигнала';

  @override
  String get rsrpHint =>
      'RSRP — мощность принятого опорного сигнала.\n\nСредняя мощность опорных сигналов соты, измеряется в дБм. Отражает исходный уровень сигнала.\n\nТипичный диапазон: примерно от −80 дБм (отлично) до −120 дБм (очень слабо). Выше (ближе к нулю) — лучше.';

  @override
  String get rsrqHint =>
      'RSRQ — качество принятого опорного сигнала.\n\nКачество сигнала в дБ, учитывающее помимо силы также помехи и нагрузку сети.\n\nТипичный диапазон: примерно от −3 дБ (отлично) до −20 дБ (плохо). Выше — лучше.';

  @override
  String get sinrHint =>
      'SINR — отношение сигнал/(помеха+шум).\n\nНасколько полезный сигнал превышает помехи плюс фоновый шум, в дБ.\n\nВыше — лучше: выше ~20 дБ — отлично, около 0 дБ или ниже — плохо.';

  @override
  String get pciHint =>
      'PCI — физический идентификатор соты.\n\nЧисло (0–503 в LTE), которое идентифицирует обслуживающую соту на радиоинтерфейсе. Соседние соты используют разные PCI, чтобы телефон мог их различать.';

  @override
  String get earfcnHint =>
      'EARFCN — абсолютный номер радиочастотного канала E-UTRA.\n\nОпределяет точную несущую частоту, используемую устройством; соответствует конкретному диапазону и каналу LTE.';

  @override
  String get estDistHint =>
      'Оценочное расстояние до сотовой вышки.\n\nВычислено из уровня сигнала (RSRP) с помощью модели распространения радиоволн. Это лишь очень грубая оценка порядка величины — не точное измерение.';
}
