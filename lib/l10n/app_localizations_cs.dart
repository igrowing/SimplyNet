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

  @override
  String get stop => 'Zastavit';

  @override
  String get clear => 'Vymazat';

  @override
  String get copy => 'Kopírovat';

  @override
  String get copied => 'Zkopírováno';

  @override
  String get copyIp => 'Kopírovat IP';

  @override
  String get hostHint => 'IP adresa nebo název hostitele';

  @override
  String get domainHostHint => 'Doména, IP adresa nebo název hostitele';

  @override
  String get go => 'Spustit';

  @override
  String get trace => 'Sledovat';

  @override
  String get lookUp => 'Vyhledat';

  @override
  String get lookingUp => 'Vyhledávání…';

  @override
  String get enterHostGo => 'Zadejte hostitele a stiskněte Spustit';

  @override
  String get enterHostTrace => 'Zadejte hostitele a stiskněte Sledovat';

  @override
  String get enterHostScan => 'Zadejte hostitele a klepněte na Skenovat';

  @override
  String get enterDomainIp => 'Zadejte doménu, IP nebo název hostitele';

  @override
  String get aboutPing => 'O funkci Ping';

  @override
  String get aboutTraceroute => 'O funkci Traceroute';

  @override
  String get aboutWhois => 'O funkci Who Is';

  @override
  String get aboutPortScan => 'O skenování portů';

  @override
  String get hiddenNode => 'Skrytý uzel';

  @override
  String get destination => 'Cíl';

  @override
  String get yourRouter => 'Váš router';

  @override
  String get networkHop => 'Síťový skok';

  @override
  String get hop => 'Skok';

  @override
  String get noReply => 'žádná odpověď';

  @override
  String get probingNextHop => 'Zjišťování dalšího skoku…';

  @override
  String get hiddenNodeInfo =>
      'Tento router neodpověděl na naše dotazy. Mnoho poskytovatelů internetu, firewallů a bezpečnostních zařízení záměrně zahazuje nebo omezuje provoz ICMP (ping), takže skok zůstává anonymní, i když jím vaše data stále procházejí.\n\nTo je normální a neznamená to, že je trasa přerušena.';

  @override
  String get portsLabel => 'Porty:';

  @override
  String get wellKnown => 'Známé';

  @override
  String get rangeLabel => 'Rozsah';

  @override
  String get fromLabel => 'Od:';

  @override
  String get toLabel => 'Do:';

  @override
  String get protocolLabel => 'Protokol:';

  @override
  String get hideSettings => 'Skrýt nastavení';

  @override
  String get myPublicIp => 'Moje veřejná IP';

  @override
  String get errorLabel => 'Chyba';

  @override
  String get infoUnavailable => 'Informace nejsou dostupné.';

  @override
  String get startTest => 'Spustit test';

  @override
  String get download => 'Stahování';

  @override
  String get upload => 'Odesílání';

  @override
  String get statusReady => 'Připraveno';

  @override
  String get statusDone => 'Hotovo';

  @override
  String get measuringPing => 'Měření ping…';

  @override
  String get findingServer => 'Hledání serveru…';

  @override
  String get testingDownload => 'Test stahování…';

  @override
  String get testingUpload => 'Test odesílání…';

  @override
  String get viaCloudflare => 'Přes Cloudflare';

  @override
  String get viaOokla => 'Přes Ookla';

  @override
  String get aboutSpeedTestTip => 'O testu rychlosti';

  @override
  String get speedTestInfo => 'Informace o testu rychlosti';

  @override
  String get previousMeasurements => 'Předchozí měření';

  @override
  String get noMeasurements => 'Zatím žádná měření.';

  @override
  String get dateTime => 'Datum / Čas';

  @override
  String get switchToOokla => 'Přepnout na Ookla?';

  @override
  String get ooklaConsentBody =>
      'Přepnutí na Ookla vyžaduje připojení k serverům třetích stran. Ookla shromažďuje a sdílí vaši IP adresu, identifikátory zařízení a údaje o poloze.';

  @override
  String get decline => 'Odmítnout';

  @override
  String get accept => 'Přijmout';

  @override
  String get clearHistoryTitle => 'Vymazat historii?';

  @override
  String get clearHistoryBody =>
      'Tím se trvale odstraní všechny záznamy měření.';

  @override
  String get aboutThisScan => 'O tomto skenování';

  @override
  String get scanInfoBody =>
      'Zařízení blokující ICMP (ping) se zde nezobrazí. Spusťte skenování „Zařízení IoT“ nebo „IP kamery“, abyste je našli podle otevřených portů a služeb.\n\nNa zařízeních s Androidem 11+ nelze MAC adresy získat kvůli omezením soukromí od Googlu, proto se nezobrazují.';

  @override
  String get stopScan => 'Zastavit skenování';

  @override
  String get reScan => 'Znovu skenovat';

  @override
  String get hostsFound => 'nalezených hostitelů';

  @override
  String get hostname => 'Název hostitele';

  @override
  String get noSavedResults => 'Žádné uložené výsledky';

  @override
  String get noNetworkTarget => 'Není nastaven cíl sítě';

  @override
  String get tapRefreshToScan =>
      'Klepnutím na tlačítko obnovit spustíte skenování';

  @override
  String get setTargetHome => 'Nastavte cíl na domovské obrazovce';

  @override
  String get openInBrowser => 'Otevřít v prohlížeči (HTTP)';

  @override
  String get openSsh => 'Otevřít SSH';

  @override
  String get couldNotOpenBrowser => 'Nelze otevřít prohlížeč';

  @override
  String get noSshApp =>
      'Nenalezena žádná SSH aplikace. Nainstalujte ConnectBot nebo Termius.';

  @override
  String get deviceInfo => 'Informace o zařízení';

  @override
  String get ipAddress => 'IP adresa';

  @override
  String get macAddress => 'MAC adresa';

  @override
  String get manufacturer => 'Výrobce';

  @override
  String get deviceTypeLabel => 'Typ zařízení';

  @override
  String get openPorts => 'Otevřené porty';

  @override
  String get stopPortScan => 'Zastavit skenování portů';

  @override
  String get portScanSettings => 'Nastavení skenování portů';

  @override
  String get reScanPorts => 'Znovu skenovat porty';

  @override
  String get noOpenPorts => 'Nebyly nalezeny žádné otevřené porty.';

  @override
  String get applyRescan => 'Použít a znovu skenovat';

  @override
  String get diagnostics => 'Diagnostika';

  @override
  String get times => 'krát';

  @override
  String get deleteAllLogs => 'Smazat všechny protokoly';

  @override
  String get deleteAllLogsQ => 'Smazat všechny protokoly?';

  @override
  String get cannotBeUndone => 'Tuto akci nelze vrátit zpět.';

  @override
  String get deleteAll => 'Smazat vše';

  @override
  String get deleteLogQ => 'Smazat protokol?';

  @override
  String get noLogsYet => 'Zatím žádné protokoly';

  @override
  String get scanningEllipsis => 'Skenování…';

  @override
  String get iotDevicesFound => 'nalezených zařízení IoT';

  @override
  String get iotNoSaved =>
      'Žádné uložené výsledky.\nKlepnutím na obnovit spustíte skenování.';

  @override
  String get unknown => 'Neznámé';

  @override
  String get viaLabel => 'přes';

  @override
  String get confDefinite => 'jisté';

  @override
  String get confProbable => 'pravděpodobné';

  @override
  String get confPossible => 'možné';

  @override
  String get ipCameraScan => 'Skenování IP kamer';

  @override
  String get camMethodProtocolPort => 'Port protokolu';

  @override
  String get camMethodKnownVendor => 'Známý výrobce';

  @override
  String get camMethodHttpFingerprint => 'Otisk HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Skenování… $done/$total hostitelů — $n kamer';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Žádné uložené výsledky — klepnutím na obnovit prohledáte $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return 'Nalezeno $n kamer — $cidr';
  }

  @override
  String get noCamerasFound => 'Nebyly nalezeny žádné kamery.';

  @override
  String get mqttSettingsTitle => 'Nastavení MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN brokera';

  @override
  String get searchingSubnet => 'Prohledávání podsítě…';

  @override
  String get brokerHint => 'např. 192.168.1.10 nebo broker.example.com';

  @override
  String get portLabel => 'Port';

  @override
  String get usernameOptional => 'Uživatelské jméno (volitelné)';

  @override
  String get leaveEmptyOptional => 'ponechte prázdné, pokud není vyžadováno';

  @override
  String get passwordOptional => 'Heslo (volitelné)';

  @override
  String get keepPassword => 'Uchovat heslo (nedoporučeno)';

  @override
  String get keepPasswordSub =>
      'Heslo je uloženo jako prostý text v úložišti aplikace.';

  @override
  String get save => 'Uložit';

  @override
  String get screenStaysOn => 'Obrazovka zůstává zapnutá';

  @override
  String get screenMaySleep => 'Obrazovka může zhasnout';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Téma';

  @override
  String get topicSubHint => 'např. home/sensor/# nebo home/sensor/temp';

  @override
  String get listen => 'Naslouchat';

  @override
  String get humanReadableJson => 'Čitelný JSON';

  @override
  String get waitingForMessages => 'Čekání na zprávy…';

  @override
  String get enterTopicListen => 'Zadejte téma a klepněte na Naslouchat';

  @override
  String get tapListenReceive => 'Klepnutím na Naslouchat začnete přijímat';

  @override
  String get enterTopicTapListen => 'Zadejte téma a klepněte na Naslouchat';

  @override
  String get enterTopicFirst => 'Nejprve zadejte téma.';

  @override
  String get stoppedStatus => 'Zastaveno.';

  @override
  String get connectingStatus => 'Připojování…';

  @override
  String get reconnectingStatus => 'Opětovné připojování…';

  @override
  String listeningOn(Object topic) {
    return 'Naslouchání na \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Připojení selhalo: $e';
  }

  @override
  String get topicPubHint => 'např. home/light/switch';

  @override
  String get messageLabel => 'Zpráva';

  @override
  String get enterPayload => 'Zadejte data…';

  @override
  String get retain => 'Ponechat';

  @override
  String get retainSub => 'Broker uchová poslední zprávu pro nové odběratele.';

  @override
  String get publish => 'Publikovat';

  @override
  String get connectedEnterTopic => 'Připojeno — zadejte téma níže';

  @override
  String connectedTopic(Object topic) {
    return 'Připojeno — téma: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Odpojeno';

  @override
  String publishedTo(Object topic) {
    return 'Publikováno do \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'O kanálech 5 GHz';

  @override
  String get wifiBandInfoTitle =>
      'Detekce dvojitého přístupového bodu v síti 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 Podržte SSID pro zobrazení celého názvu přístupového bodu.\n\nℹ️ V pásmu 5 GHz obvykle uvidíte každý přístupový bod na dvou (nebo více) kanálech současně. To je normální.\n\nPro vyšší rychlost moderní routery spojují sousední kanály po 20 MHz do jednoho širšího pruhu — 40, 80 nebo dokonce 160 MHz. Tomu se říká \"spojování kanálů\". Širší pruh přenese více dat, stejně jako širší silnice pojme více aut.\n\nPři \"dynamické šířce kanálu\" router zvolí nejširší možný pruh a automaticky jej zúží, když je éter vytížený nebo zarušený, aby zůstal rychlý a nerušil sousedy.\n\nJedna síť 5 GHz zobrazená například na kanálech 36 a 40 je tedy jen jeden přístupový bod používající spojený kanál o šířce 40 MHz — nikoli dvě samostatné sítě.';

  @override
  String get noResults => 'Žádné výsledky.';

  @override
  String get scanErrorPrefix => 'Chyba skenování';

  @override
  String noBandNetworks(Object band) {
    return 'Nebyly zjištěny žádné sítě $band.';
  }

  @override
  String get securityLabel => 'Zabezpečení';

  @override
  String get qualityLabel => 'Kvalita';

  @override
  String get qExcellent => 'Vynikající';

  @override
  String get qGood => 'Dobrá';

  @override
  String get qFair => 'Průměrná';

  @override
  String get qWeak => 'Slabá';

  @override
  String get qPoor => 'Špatná';

  @override
  String get refresh => 'Obnovit';

  @override
  String get cellShowingDemo => 'Zobrazují se ukázková data.';

  @override
  String get noDataReturned => 'Zařízení nevrátilo žádná data.';

  @override
  String get platformErrorPrefix => 'Chyba platformy';

  @override
  String get carrier => 'Operátor';

  @override
  String get provider => 'Poskytovatel';

  @override
  String get technology => 'Technologie';

  @override
  String get roaming => 'Roaming';

  @override
  String get dataState => 'Stav dat';

  @override
  String get signalQuality => 'Kvalita signálu';

  @override
  String get cellTower => 'Buňková věž';

  @override
  String get cellId => 'ID buňky';

  @override
  String get bandLabel => 'Pásmo';

  @override
  String get estDistance => 'Odh. vzdálenost';

  @override
  String get location => 'Poloha';

  @override
  String get coordinates => 'Souřadnice';

  @override
  String get locating => 'Zjišťování polohy…';

  @override
  String get nearestPlace => 'Nejbližší místo';

  @override
  String get deniedByUser => 'Uživatelem zamítnuto';

  @override
  String get unavailablePrefix => 'Nedostupné';

  @override
  String get signalStrength => 'Síla signálu';

  @override
  String get rsrpHint =>
      'RSRP — přijatý výkon referenčního signálu.\n\nPrůměrný výkon referenčních signálů buňky, měřený v dBm. Odráží surovou sílu signálu.\n\nTypický rozsah: přibližně od −80 dBm (vynikající) po −120 dBm (velmi slabý). Vyšší (blíže nule) je lepší.';

  @override
  String get rsrqHint =>
      'RSRQ — přijatá kvalita referenčního signálu.\n\nKvalita signálu v dB, která kromě síly zohledňuje také rušení a zatížení sítě.\n\nTypický rozsah: přibližně od −3 dB (vynikající) po −20 dB (špatný). Vyšší je lepší.';

  @override
  String get sinrHint =>
      'SINR — poměr signálu k rušení a šumu.\n\nO kolik požadovaný signál převyšuje rušení plus šum pozadí, v dB.\n\nVyšší je lepší: nad ~20 dB je vynikající, kolem 0 dB nebo méně je špatné.';

  @override
  String get pciHint =>
      'PCI — fyzický identifikátor buňky.\n\nČíslo (0–503 v LTE) identifikující obsluhující buňku na rádiovém rozhraní. Sousední buňky používají různá PCI, aby je telefon mohl rozlišit.';

  @override
  String get earfcnHint =>
      'EARFCN — absolutní číslo rádiového frekvenčního kanálu E-UTRA.\n\nUrčuje přesnou nosnou frekvenci, kterou zařízení používá; odpovídá konkrétnímu pásmu a kanálu LTE.';

  @override
  String get estDistHint =>
      'Odhadovaná vzdálenost k buňkové věži.\n\nOdvozena ze síly signálu (RSRP) pomocí modelu šíření rádiových vln. Jde jen o velmi hrubý řádový odhad — nikoli přesné měření.';

  @override
  String get version => 'Verze';

  @override
  String get sendFeedback => 'Odeslat zpětnou vazbu / návrh na vylepšení';

  @override
  String get buyMeCoffee => 'Kup mi kávu';

  @override
  String get shareAction => 'Sdílet';
}
