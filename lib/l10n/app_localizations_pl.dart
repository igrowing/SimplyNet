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

  @override
  String get stop => 'Zatrzymaj';

  @override
  String get clear => 'Wyczyść';

  @override
  String get copy => 'Kopiuj';

  @override
  String get copied => 'Skopiowano';

  @override
  String get copyIp => 'Kopiuj IP';

  @override
  String get hostHint => 'Adres IP lub nazwa hosta';

  @override
  String get domainHostHint => 'Domena, adres IP lub nazwa hosta';

  @override
  String get go => 'Start';

  @override
  String get trace => 'Śledź';

  @override
  String get lookUp => 'Wyszukaj';

  @override
  String get lookingUp => 'Wyszukiwanie…';

  @override
  String get enterHostGo => 'Wpisz hosta i naciśnij Start';

  @override
  String get enterHostTrace => 'Wpisz hosta i naciśnij Śledź';

  @override
  String get enterHostScan => 'Wpisz hosta i dotknij Skanuj';

  @override
  String get enterDomainIp => 'Wpisz domenę, IP lub nazwę hosta';

  @override
  String get aboutPing => 'O Ping';

  @override
  String get aboutTraceroute => 'O Traceroute';

  @override
  String get aboutWhois => 'O Who Is';

  @override
  String get aboutPortScan => 'O skanowaniu portów';

  @override
  String get hiddenNode => 'Ukryty węzeł';

  @override
  String get destination => 'Cel';

  @override
  String get yourRouter => 'Twój router';

  @override
  String get networkHop => 'Przeskok sieciowy';

  @override
  String get hop => 'Przeskok';

  @override
  String get noReply => 'brak odpowiedzi';

  @override
  String get probingNextHop => 'Sondowanie następnego przeskoku…';

  @override
  String get hiddenNodeInfo =>
      'Ten router nie odpowiedział na nasze sondy. Wielu dostawców internetu, zapór i urządzeń zabezpieczających celowo odrzuca lub ogranicza ruch ICMP (ping), więc przeskok pozostaje anonimowy, choć Twoje dane nadal przez niego przechodzą.\n\nTo normalne i nie oznacza, że trasa jest przerwana.';

  @override
  String get portsLabel => 'Porty:';

  @override
  String get wellKnown => 'Znane';

  @override
  String get rangeLabel => 'Zakres';

  @override
  String get fromLabel => 'Od:';

  @override
  String get toLabel => 'Do:';

  @override
  String get protocolLabel => 'Protokół:';

  @override
  String get hideSettings => 'Ukryj ustawienia';

  @override
  String get myPublicIp => 'Mój publiczny IP';

  @override
  String get errorLabel => 'Błąd';

  @override
  String get infoUnavailable => 'Informacje niedostępne.';

  @override
  String get startTest => 'Rozpocznij test';

  @override
  String get download => 'Pobieranie';

  @override
  String get upload => 'Wysyłanie';

  @override
  String get statusReady => 'Gotowe';

  @override
  String get statusDone => 'Gotowe';

  @override
  String get measuringPing => 'Pomiar ping…';

  @override
  String get findingServer => 'Wyszukiwanie serwera…';

  @override
  String get testingDownload => 'Test pobierania…';

  @override
  String get testingUpload => 'Test wysyłania…';

  @override
  String get viaCloudflare => 'Przez Cloudflare';

  @override
  String get viaOokla => 'Przez Ookla';

  @override
  String get aboutSpeedTestTip => 'O teście prędkości';

  @override
  String get speedTestInfo => 'Informacje o teście prędkości';

  @override
  String get previousMeasurements => 'Poprzednie pomiary';

  @override
  String get noMeasurements => 'Brak pomiarów.';

  @override
  String get dateTime => 'Data / Godzina';

  @override
  String get switchToOokla => 'Przełączyć na Ookla?';

  @override
  String get ooklaConsentBody =>
      'Przełączenie na Ookla wymaga połączenia z serwerami zewnętrznymi. Ookla zbiera i udostępnia Twój adres IP, identyfikatory urządzenia oraz dane o lokalizacji.';

  @override
  String get decline => 'Odrzuć';

  @override
  String get accept => 'Akceptuj';

  @override
  String get clearHistoryTitle => 'Wyczyścić historię?';

  @override
  String get clearHistoryBody =>
      'Spowoduje to trwałe usunięcie wszystkich zapisów pomiarów.';

  @override
  String get aboutThisScan => 'O tym skanowaniu';

  @override
  String get scanInfoBody =>
      'Urządzenia blokujące ICMP (ping) nie pojawią się tutaj. Uruchom skanowanie „Urządzenia IoT” lub „Kamery IP”, aby zlokalizować je poprzez ich otwarte porty i usługi.\n\nNa urządzeniach z Android 11+ adresy MAC nie mogą być pobrane ze względu na ograniczenia prywatności Google, więc nie są wyświetlane.';

  @override
  String get stopScan => 'Zatrzymaj skanowanie';

  @override
  String get reScan => 'Skanuj ponownie';

  @override
  String get hostsFound => 'znalezionych hostów';

  @override
  String get hostname => 'Nazwa hosta';

  @override
  String get noSavedResults => 'Brak zapisanych wyników';

  @override
  String get noNetworkTarget => 'Nie ustawiono celu sieci';

  @override
  String get tapRefreshToScan => 'Dotknij przycisku odświeżania, aby skanować';

  @override
  String get setTargetHome => 'Ustaw cel na ekranie głównym';

  @override
  String get openInBrowser => 'Otwórz w przeglądarce (HTTP)';

  @override
  String get openSsh => 'Otwórz SSH';

  @override
  String get couldNotOpenBrowser => 'Nie można otworzyć przeglądarki';

  @override
  String get noSshApp =>
      'Nie znaleziono aplikacji SSH. Zainstaluj ConnectBot lub Termius.';

  @override
  String get deviceInfo => 'Informacje o urządzeniu';

  @override
  String get ipAddress => 'Adres IP';

  @override
  String get macAddress => 'Adres MAC';

  @override
  String get manufacturer => 'Producent';

  @override
  String get deviceTypeLabel => 'Typ urządzenia';

  @override
  String get openPorts => 'Otwarte porty';

  @override
  String get stopPortScan => 'Zatrzymaj skanowanie portów';

  @override
  String get portScanSettings => 'Ustawienia skanowania portów';

  @override
  String get reScanPorts => 'Skanuj porty ponownie';

  @override
  String get noOpenPorts => 'Nie znaleziono otwartych portów.';

  @override
  String get applyRescan => 'Zastosuj i skanuj ponownie';

  @override
  String get diagnostics => 'Diagnostyka';

  @override
  String get times => 'razy';

  @override
  String get deleteAllLogs => 'Usuń wszystkie logi';

  @override
  String get deleteAllLogsQ => 'Usunąć wszystkie logi?';

  @override
  String get cannotBeUndone => 'Tej operacji nie można cofnąć.';

  @override
  String get deleteAll => 'Usuń wszystko';

  @override
  String get deleteLogQ => 'Usunąć log?';

  @override
  String get noLogsYet => 'Brak logów';

  @override
  String get scanningEllipsis => 'Skanowanie…';

  @override
  String get iotDevicesFound => 'znalezionych urządzeń IoT';

  @override
  String get iotNoSaved =>
      'Brak zapisanych wyników.\nDotknij odśwież, aby skanować.';

  @override
  String get unknown => 'Nieznany';

  @override
  String get viaLabel => 'przez';

  @override
  String get confDefinite => 'pewne';

  @override
  String get confProbable => 'prawdopodobne';

  @override
  String get confPossible => 'możliwe';

  @override
  String get ipCameraScan => 'Skanowanie kamer IP';

  @override
  String get camMethodProtocolPort => 'Port protokołu';

  @override
  String get camMethodKnownVendor => 'Znany producent';

  @override
  String get camMethodHttpFingerprint => 'Odcisk HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Skanowanie… $done/$total hostów — $n kamer';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Brak zapisanych wyników — dotknij odśwież, aby skanować $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return 'Znaleziono $n kamer — $cidr';
  }

  @override
  String get noCamerasFound => 'Nie znaleziono kamer.';

  @override
  String get mqttSettingsTitle => 'Ustawienia MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN brokera';

  @override
  String get searchingSubnet => 'Przeszukiwanie podsieci…';

  @override
  String get brokerHint => 'np. 192.168.1.10 lub broker.example.com';

  @override
  String get portLabel => 'Port';

  @override
  String get usernameOptional => 'Nazwa użytkownika (opcjonalnie)';

  @override
  String get leaveEmptyOptional => 'pozostaw puste, jeśli nie jest wymagane';

  @override
  String get passwordOptional => 'Hasło (opcjonalnie)';

  @override
  String get keepPassword => 'Zachowaj hasło (niezalecane)';

  @override
  String get keepPasswordSub =>
      'Hasło jest przechowywane jako zwykły tekst w pamięci aplikacji.';

  @override
  String get save => 'Zapisz';

  @override
  String get screenStaysOn => 'Ekran pozostaje włączony';

  @override
  String get screenMaySleep => 'Ekran może się wyłączyć';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Temat';

  @override
  String get topicSubHint => 'np. home/sensor/# lub home/sensor/temp';

  @override
  String get listen => 'Nasłuchuj';

  @override
  String get humanReadableJson => 'Czytelny JSON';

  @override
  String get waitingForMessages => 'Oczekiwanie na wiadomości…';

  @override
  String get enterTopicListen => 'Wpisz temat i dotknij Nasłuchuj';

  @override
  String get tapListenReceive => 'Dotknij Nasłuchuj, aby zacząć odbierać';

  @override
  String get enterTopicTapListen => 'Wpisz temat i dotknij Nasłuchuj';

  @override
  String get enterTopicFirst => 'Najpierw wpisz temat.';

  @override
  String get stoppedStatus => 'Zatrzymano.';

  @override
  String get connectingStatus => 'Łączenie…';

  @override
  String get reconnectingStatus => 'Ponowne łączenie…';

  @override
  String listeningOn(Object topic) {
    return 'Nasłuchiwanie na \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Połączenie nie powiodło się: $e';
  }

  @override
  String get topicPubHint => 'np. home/light/switch';

  @override
  String get messageLabel => 'Wiadomość';

  @override
  String get enterPayload => 'Wpisz ładunek…';

  @override
  String get retain => 'Zachowaj';

  @override
  String get retainSub =>
      'Broker zachowuje ostatnią wiadomość dla nowych subskrybentów.';

  @override
  String get publish => 'Opublikuj';

  @override
  String get connectedEnterTopic => 'Połączono — wpisz temat poniżej';

  @override
  String connectedTopic(Object topic) {
    return 'Połączono — temat: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Rozłączono';

  @override
  String publishedTo(Object topic) {
    return 'Opublikowano w \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'O kanałach 5 GHz';

  @override
  String get wifiBandInfoTitle =>
      'Wykrywanie podwójnego punktu dostępu w sieci 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 Przytrzymaj SSID, aby zobaczyć pełną nazwę punktu dostępu.\n\nℹ️ W paśmie 5 GHz zwykle zobaczysz każdy punkt dostępu jednocześnie na dwóch (lub więcej) kanałach. To normalne.\n\nAby przyspieszyć, nowoczesne routery łączą sąsiednie kanały 20 MHz w jeden szerszy pas — 40, 80 lub nawet 160 MHz. Nazywa się to \"łączeniem kanałów\". Szerszy pas przenosi więcej danych, tak jak szersza droga mieści więcej samochodów.\n\nPrzy \"dynamicznej szerokości kanału\" router wybiera najszerszy możliwy pas i automatycznie go zwęża, gdy eter jest zajęty lub zaszumiony, pozostając szybki bez przeszkadzania sąsiadom.\n\nZatem pojedyncza sieć 5 GHz pojawiająca się np. na kanałach 36 i 40 to tylko jeden punkt dostępu używający połączonego kanału o szerokości 40 MHz — a nie dwie osobne sieci.';

  @override
  String get noResults => 'Brak wyników.';

  @override
  String get scanErrorPrefix => 'Błąd skanowania';

  @override
  String noBandNetworks(Object band) {
    return 'Nie wykryto sieci $band.';
  }

  @override
  String get securityLabel => 'Zabezpieczenia';

  @override
  String get qualityLabel => 'Jakość';

  @override
  String get qExcellent => 'Doskonała';

  @override
  String get qGood => 'Dobra';

  @override
  String get qFair => 'Dostateczna';

  @override
  String get qWeak => 'Słaba';

  @override
  String get qPoor => 'Słaba';

  @override
  String get refresh => 'Odśwież';

  @override
  String get cellShowingDemo => 'Wyświetlanie danych demonstracyjnych.';

  @override
  String get noDataReturned => 'Urządzenie nie zwróciło żadnych danych.';

  @override
  String get platformErrorPrefix => 'Błąd platformy';

  @override
  String get carrier => 'Operator';

  @override
  String get provider => 'Dostawca';

  @override
  String get technology => 'Technologia';

  @override
  String get roaming => 'Roaming';

  @override
  String get dataState => 'Stan danych';

  @override
  String get signalQuality => 'Jakość sygnału';

  @override
  String get cellTower => 'Maszt komórkowy';

  @override
  String get cellId => 'ID komórki';

  @override
  String get bandLabel => 'Pasmo';

  @override
  String get estDistance => 'Szac. odległość';

  @override
  String get location => 'Lokalizacja';

  @override
  String get coordinates => 'Współrzędne';

  @override
  String get locating => 'Lokalizowanie…';

  @override
  String get nearestPlace => 'Najbliższe miejsce';

  @override
  String get deniedByUser => 'Odrzucone przez użytkownika';

  @override
  String get unavailablePrefix => 'Niedostępne';

  @override
  String get signalStrength => 'Siła sygnału';

  @override
  String get rsrpHint =>
      'RSRP — moc odebranego sygnału odniesienia.\n\nŚrednia moc sygnałów odniesienia komórki, mierzona w dBm. Odzwierciedla surową siłę sygnału.\n\nTypowy zakres: od około −80 dBm (doskonały) do −120 dBm (bardzo słaby). Wyżej (bliżej zera) jest lepiej.';

  @override
  String get rsrqHint =>
      'RSRQ — jakość odebranego sygnału odniesienia.\n\nJakość sygnału w dB, uwzględniająca poza siłą także zakłócenia i obciążenie sieci.\n\nTypowy zakres: od około −3 dB (doskonały) do −20 dB (słaby). Wyżej jest lepiej.';

  @override
  String get sinrHint =>
      'SINR — stosunek sygnału do interferencji i szumu.\n\nO ile pożądany sygnał przewyższa interferencję plus szum tła, w dB.\n\nWyżej jest lepiej: powyżej ~20 dB jest doskonale, około 0 dB lub poniżej jest słabo.';

  @override
  String get pciHint =>
      'PCI — fizyczny identyfikator komórki.\n\nLiczba (0–503 w LTE) identyfikująca komórkę obsługującą na interfejsie radiowym. Sąsiednie komórki używają różnych PCI, aby telefon mógł je rozróżnić.';

  @override
  String get earfcnHint =>
      'EARFCN — bezwzględny numer kanału częstotliwości radiowej E-UTRA.\n\nIdentyfikuje dokładną częstotliwość nośną używaną przez urządzenie; odpowiada konkretnemu pasmu i kanałowi LTE.';

  @override
  String get estDistHint =>
      'Szacowana odległość do masztu komórkowego.\n\nWyznaczona z siły sygnału (RSRP) za pomocą modelu propagacji radiowej. To tylko bardzo zgrubne wskazanie rzędu wielkości — nie precyzyjny pomiar.';

  @override
  String get version => 'Wersja';

  @override
  String get sendFeedback => 'Wyślij opinię / pomysł na ulepszenie';

  @override
  String get buyMeCoffee => 'Postaw mi kawę';

  @override
  String get shareAction => 'Udostępnij';
}
