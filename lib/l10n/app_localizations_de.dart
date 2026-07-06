// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get appearance => 'Darstellung';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Bildschirm-Timeout';

  @override
  String get timeoutSystem => 'System';

  @override
  String get timeoutTriple => '3× System';

  @override
  String get timeoutStayOn => 'An lassen';

  @override
  String get scanning => 'Scannen';

  @override
  String get showMacAddress => 'MAC-Adresse anzeigen';

  @override
  String get showMacBlocked =>
      'Auf Android v.11 und höher aufgrund von Googles Datenschutz deaktiviert';

  @override
  String get showMacSubtitle => 'MAC-Spalte in den Scanergebnissen anzeigen';

  @override
  String get resolveHostnames => 'Hostnamen auflösen';

  @override
  String get resolveHostnamesSubtitle =>
      'Reverse-DNS + mDNS während des Scans durchführen';

  @override
  String get enableLogging => 'Protokollierung aktivieren';

  @override
  String get enableLoggingSubtitle =>
      'Scan- und Tool-Ausgabe in Protokolldateien speichern';

  @override
  String get account => 'Konto';

  @override
  String get logIn => 'Anmelden';

  @override
  String get comingSoon => 'Demnächst';

  @override
  String get settings => 'Einstellungen';

  @override
  String get aboutSimplyNet => 'Über SimplyNet';

  @override
  String get scan => 'Scannen';

  @override
  String get logs => 'Protokolle';

  @override
  String get networkTools => 'Netzwerk-Tools';

  @override
  String get networkTarget => 'Netzwerkziel';

  @override
  String get networkTargetHint => 'z. B. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'Ungültiges CIDR — Format wie 192.168.1.0/24 verwenden';

  @override
  String get detectMyNetwork => 'Mein Netzwerk erkennen';

  @override
  String get toolSpeedTest => 'Geschwindigkeitstest';

  @override
  String get toolSpeedTestSub => 'Download- & Upload-Geschwindigkeit';

  @override
  String get toolPublicIp => 'Öffentliche IP';

  @override
  String get toolPublicIpSub => 'Deine IP, ISP & Standort';

  @override
  String get toolIpCameras => 'IP-Kameras';

  @override
  String get toolIpCamerasSub => 'Kameras im LAN finden';

  @override
  String get toolIotDevices => 'IoT-Geräte';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly & mehr';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Ein MQTT-Topic abonnieren';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'In ein MQTT-Topic veröffentlichen';

  @override
  String get toolPortScan => 'Port-Scan';

  @override
  String get toolPortScanSub => 'Offene TCP/UDP-Ports auf jedem Host';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Live-Ping mit Diagramm';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Hop-für-Hop-Pfad zu jedem Host';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS & Reverse-Lookup';

  @override
  String get toolWifiChannels => 'WLAN-Kanäle';

  @override
  String get toolWifiChannelsSub => 'Interferenzkarte für 2,4 & 5 GHz';

  @override
  String get toolCellularInfo => 'Mobilfunk-Info';

  @override
  String get toolCellularInfoSub => 'Signal, Zell-ID & Mastdaten';

  @override
  String get about => 'Über';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Löschen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get stop => 'Stopp';

  @override
  String get clear => 'Löschen';

  @override
  String get copy => 'Kopieren';

  @override
  String get copied => 'Kopiert';

  @override
  String get copyIp => 'IP kopieren';

  @override
  String get hostHint => 'IP-Adresse oder Hostname';

  @override
  String get domainHostHint => 'Domain, IP-Adresse oder Hostname';

  @override
  String get go => 'Los';

  @override
  String get trace => 'Verfolgen';

  @override
  String get lookUp => 'Suchen';

  @override
  String get lookingUp => 'Suche…';

  @override
  String get enterHostGo => 'Host eingeben und Los drücken';

  @override
  String get enterHostTrace => 'Host eingeben und Verfolgen drücken';

  @override
  String get enterHostScan => 'Host eingeben und auf Scannen tippen';

  @override
  String get enterDomainIp => 'Domain, IP oder Hostname eingeben';

  @override
  String get aboutPing => 'Über Ping';

  @override
  String get aboutTraceroute => 'Über Traceroute';

  @override
  String get aboutWhois => 'Über Who Is';

  @override
  String get aboutPortScan => 'Über Port Scan';

  @override
  String get hiddenNode => 'Verborgener Knoten';

  @override
  String get destination => 'Ziel';

  @override
  String get yourRouter => 'Dein Router';

  @override
  String get networkHop => 'Netzwerk-Hop';

  @override
  String get hop => 'Hop';

  @override
  String get noReply => 'keine Antwort';

  @override
  String get probingNextHop => 'Nächster Hop wird geprüft…';

  @override
  String get hiddenNodeInfo =>
      'Dieser Router hat auf unsere Anfragen nicht geantwortet. Viele ISPs, Firewalls und Sicherheitsgeräte verwerfen oder drosseln ICMP-(Ping-)Verkehr absichtlich, sodass der Hop anonym bleibt, obwohl deine Daten weiterhin darüber laufen.\n\nDas ist normal und bedeutet nicht, dass die Route unterbrochen ist.';

  @override
  String get portsLabel => 'Ports:';

  @override
  String get wellKnown => 'Bekannte';

  @override
  String get rangeLabel => 'Bereich';

  @override
  String get fromLabel => 'Von:';

  @override
  String get toLabel => 'Bis:';

  @override
  String get protocolLabel => 'Protokoll:';

  @override
  String get hideSettings => 'Einstellungen ausblenden';

  @override
  String get myPublicIp => 'Meine öffentliche IP';

  @override
  String get errorLabel => 'Fehler';

  @override
  String get infoUnavailable => 'Informationen nicht verfügbar.';

  @override
  String get startTest => 'Test starten';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusDone => 'Fertig';

  @override
  String get measuringPing => 'Ping wird gemessen…';

  @override
  String get findingServer => 'Server wird gesucht…';

  @override
  String get testingDownload => 'Download wird getestet…';

  @override
  String get testingUpload => 'Upload wird getestet…';

  @override
  String get viaCloudflare => 'Über Cloudflare';

  @override
  String get viaOokla => 'Über Ookla';

  @override
  String get aboutSpeedTestTip => 'Über den Geschwindigkeitstest';

  @override
  String get speedTestInfo => 'Geschwindigkeitstest-Info';

  @override
  String get previousMeasurements => 'Frühere Messungen';

  @override
  String get noMeasurements => 'Noch keine Messungen.';

  @override
  String get dateTime => 'Datum / Zeit';

  @override
  String get switchToOokla => 'Zu Ookla wechseln?';

  @override
  String get ooklaConsentBody =>
      'Der Wechsel zu Ookla erfordert eine Verbindung zu Drittanbieter-Servern. Ookla sammelt und teilt deine IP-Adresse, Gerätekennungen und Standortdaten.';

  @override
  String get decline => 'Ablehnen';

  @override
  String get accept => 'Akzeptieren';

  @override
  String get clearHistoryTitle => 'Verlauf löschen?';

  @override
  String get clearHistoryBody =>
      'Dadurch werden alle Messdatensätze dauerhaft gelöscht.';

  @override
  String get aboutThisScan => 'Über diesen Scan';

  @override
  String get scanInfoBody =>
      'Geräte, die ICMP (Pings) blockieren, erscheinen hier nicht. Führe den Scan \'IoT-Geräte\' oder \'IP-Kameras\' aus, um sie über ihre offenen Ports und Dienste zu finden.\n\nAuf Android-11+-Geräten können MAC-Adressen aufgrund von Googles Datenschutzbeschränkungen nicht abgerufen und daher nicht angezeigt werden.';

  @override
  String get stopScan => 'Scan stoppen';

  @override
  String get reScan => 'Erneut scannen';

  @override
  String get hostsFound => 'Host(s) gefunden';

  @override
  String get hostname => 'Hostname';

  @override
  String get noSavedResults => 'Keine gespeicherten Ergebnisse';

  @override
  String get noNetworkTarget => 'Kein Netzwerkziel festgelegt';

  @override
  String get tapRefreshToScan =>
      'Tippe auf die Aktualisieren-Schaltfläche, um zu scannen';

  @override
  String get setTargetHome => 'Lege ein Ziel auf dem Startbildschirm fest';

  @override
  String get openInBrowser => 'Im Browser öffnen (HTTP)';

  @override
  String get openSsh => 'SSH öffnen';

  @override
  String get couldNotOpenBrowser => 'Browser konnte nicht geöffnet werden';

  @override
  String get noSshApp =>
      'Keine SSH-App gefunden. Installiere ConnectBot oder Termius.';

  @override
  String get deviceInfo => 'Geräteinfo';

  @override
  String get ipAddress => 'IP-Adresse';

  @override
  String get macAddress => 'MAC-Adresse';

  @override
  String get manufacturer => 'Hersteller';

  @override
  String get deviceTypeLabel => 'Gerätetyp';

  @override
  String get openPorts => 'Offene Ports';

  @override
  String get stopPortScan => 'Port-Scan stoppen';

  @override
  String get portScanSettings => 'Port-Scan-Einstellungen';

  @override
  String get reScanPorts => 'Ports erneut scannen';

  @override
  String get noOpenPorts => 'Keine offenen Ports gefunden.';

  @override
  String get applyRescan => 'Anwenden & neu scannen';

  @override
  String get diagnostics => 'Diagnose';

  @override
  String get times => 'mal';

  @override
  String get deleteAllLogs => 'Alle Protokolle löschen';

  @override
  String get deleteAllLogsQ => 'Alle Protokolle löschen?';

  @override
  String get cannotBeUndone => 'Dies kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAll => 'Alle löschen';

  @override
  String get deleteLogQ => 'Protokoll löschen?';

  @override
  String get noLogsYet => 'Noch keine Protokolle';

  @override
  String get scanningEllipsis => 'Scannen…';

  @override
  String get iotDevicesFound => 'IoT-Gerät(e) gefunden';

  @override
  String get iotNoSaved =>
      'Keine gespeicherten Ergebnisse.\nZum Scannen aktualisieren.';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get viaLabel => 'über';

  @override
  String get confDefinite => 'sicher';

  @override
  String get confProbable => 'wahrscheinlich';

  @override
  String get confPossible => 'möglich';

  @override
  String get ipCameraScan => 'IP-Kamera-Scan';

  @override
  String get camMethodProtocolPort => 'Protokoll-Port';

  @override
  String get camMethodKnownVendor => 'Bekannter Hersteller';

  @override
  String get camMethodHttpFingerprint => 'HTTP-Fingerabdruck';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Scannen… $done/$total Hosts — $n Kamera(s)';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Keine gespeicherten Ergebnisse — zum Scannen von $cidr aktualisieren';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n Kamera(s) gefunden — $cidr';
  }

  @override
  String get noCamerasFound => 'Keine Kameras gefunden.';

  @override
  String get mqttSettingsTitle => 'MQTT-Einstellungen';

  @override
  String get brokerIpFqdn => 'Broker-IP / FQDN';

  @override
  String get searchingSubnet => 'Subnetz wird durchsucht…';

  @override
  String get brokerHint => 'z. B. 192.168.1.10 oder broker.example.com';

  @override
  String get portLabel => 'Port';

  @override
  String get usernameOptional => 'Benutzername (optional)';

  @override
  String get leaveEmptyOptional => 'leer lassen, falls nicht erforderlich';

  @override
  String get passwordOptional => 'Passwort (optional)';

  @override
  String get keepPassword => 'Passwort speichern (nicht empfohlen)';

  @override
  String get keepPasswordSub =>
      'Das Passwort wird im Klartext im App-Speicher abgelegt.';

  @override
  String get save => 'Speichern';

  @override
  String get screenStaysOn => 'Bildschirm bleibt an';

  @override
  String get screenMaySleep => 'Bildschirm kann sich abschalten';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Thema';

  @override
  String get topicSubHint => 'z. B. home/sensor/# oder home/sensor/temp';

  @override
  String get listen => 'Empfangen';

  @override
  String get humanReadableJson => 'Lesbares JSON';

  @override
  String get waitingForMessages => 'Warte auf Nachrichten…';

  @override
  String get enterTopicListen => 'Thema eingeben und auf Empfangen tippen';

  @override
  String get tapListenReceive => 'Auf Empfangen tippen, um zu empfangen';

  @override
  String get enterTopicTapListen => 'Thema eingeben und auf Empfangen tippen';

  @override
  String get enterTopicFirst => 'Bitte zuerst ein Thema eingeben.';

  @override
  String get stoppedStatus => 'Gestoppt.';

  @override
  String get connectingStatus => 'Verbinde…';

  @override
  String get reconnectingStatus => 'Verbinde erneut…';

  @override
  String listeningOn(Object topic) {
    return 'Empfange auf \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Verbindung fehlgeschlagen: $e';
  }

  @override
  String get topicPubHint => 'z. B. home/light/switch';

  @override
  String get messageLabel => 'Nachricht';

  @override
  String get enterPayload => 'Nutzdaten eingeben…';

  @override
  String get retain => 'Beibehalten';

  @override
  String get retainSub =>
      'Der Broker behält die letzte Nachricht für neue Abonnenten.';

  @override
  String get publish => 'Veröffentlichen';

  @override
  String get connectedEnterTopic => 'Verbunden — Thema unten eingeben';

  @override
  String connectedTopic(Object topic) {
    return 'Verbunden — Thema: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Getrennt';

  @override
  String publishedTo(Object topic) {
    return 'Veröffentlicht auf \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'Über 5-GHz-Kanäle';

  @override
  String get wifiBandInfoTitle =>
      'Erkennung doppelter Access Points im 5-GHz-Netz';

  @override
  String get wifiBandInfoBody =>
      '💡 SSID gedrückt halten, um den vollständigen Access-Point-Namen zu sehen.\n\nℹ️ Im 5-GHz-Band erscheint jeder Access Point üblicherweise auf zwei (oder mehr) Kanälen gleichzeitig. Das ist normal.\n\nUm schneller zu sein, koppeln moderne Router benachbarte 20-MHz-Kanäle zu einer breiteren Spur — 40, 80 oder sogar 160 MHz. Das nennt man \"Channel Bonding\". Eine breitere Spur transportiert mehr Daten, so wie eine breitere Straße mehr Autos aufnimmt.\n\nMit \"dynamischer Kanalbreite\" wählt der Router die breiteste mögliche Spur und verengt sie automatisch, wenn die Luft voll oder verrauscht wird, um schnell zu bleiben, ohne die Nachbarn zu stören.\n\nEin einzelnes 5-GHz-Netz, das z. B. auf den Kanälen 36 und 40 erscheint, ist also nur ein Access Point mit einem 40 MHz breiten gekoppelten Kanal — nicht zwei getrennte Netze.';

  @override
  String get noResults => 'Keine Ergebnisse.';

  @override
  String get scanErrorPrefix => 'Scan-Fehler';

  @override
  String noBandNetworks(Object band) {
    return 'Keine $band-Netzwerke erkannt.';
  }

  @override
  String get securityLabel => 'Sicherheit';

  @override
  String get qualityLabel => 'Qualität';

  @override
  String get qExcellent => 'Ausgezeichnet';

  @override
  String get qGood => 'Gut';

  @override
  String get qFair => 'Ausreichend';

  @override
  String get qWeak => 'Schwach';

  @override
  String get qPoor => 'Schlecht';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get cellShowingDemo => 'Zeige Demodaten.';

  @override
  String get noDataReturned => 'Keine Daten vom Gerät erhalten.';

  @override
  String get platformErrorPrefix => 'Plattformfehler';

  @override
  String get carrier => 'Anbieter';

  @override
  String get provider => 'Anbieter';

  @override
  String get technology => 'Technologie';

  @override
  String get roaming => 'Roaming';

  @override
  String get dataState => 'Datenstatus';

  @override
  String get signalQuality => 'Signalqualität';

  @override
  String get cellTower => 'Mobilfunkmast';

  @override
  String get cellId => 'Zellen-ID';

  @override
  String get bandLabel => 'Band';

  @override
  String get estDistance => 'Gesch. Entfernung';

  @override
  String get location => 'Standort';

  @override
  String get coordinates => 'Koordinaten';

  @override
  String get locating => 'Standort wird ermittelt…';

  @override
  String get nearestPlace => 'Nächster Ort';

  @override
  String get deniedByUser => 'Vom Benutzer abgelehnt';

  @override
  String get unavailablePrefix => 'Nicht verfügbar';

  @override
  String get signalStrength => 'Signalstärke';

  @override
  String get rsrpHint =>
      'RSRP — Reference Signal Received Power (empfangene Leistung des Referenzsignals).\n\nDie durchschnittliche Leistung der Referenzsignale der Zelle, gemessen in dBm. Sie spiegelt die reine Signalstärke wider.\n\nTypischer Bereich: etwa −80 dBm (ausgezeichnet) bis −120 dBm (sehr schwach). Höher (näher an null) ist besser.';

  @override
  String get rsrqHint =>
      'RSRQ — Reference Signal Received Quality (empfangene Qualität des Referenzsignals).\n\nSignalqualität in dB, die neben der Stärke auch Störungen und Netzlast berücksichtigt.\n\nTypischer Bereich: etwa −3 dB (ausgezeichnet) bis −20 dB (schlecht). Höher ist besser.';

  @override
  String get sinrHint =>
      'SINR — Signal-zu-Interferenz-plus-Rausch-Verhältnis.\n\nUm wie viel das Nutzsignal die Interferenz plus das Hintergrundrauschen übersteigt, in dB.\n\nHöher ist besser: über ~20 dB ist ausgezeichnet, um 0 dB oder darunter ist schlecht.';

  @override
  String get pciHint =>
      'PCI — Physical Cell ID (physische Zellkennung).\n\nEine Zahl (0–503 bei LTE), die die versorgende Zelle auf der Funkschnittstelle identifiziert. Benachbarte Zellen verwenden unterschiedliche PCIs, damit das Telefon sie unterscheiden kann.';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA Absolute Radio Frequency Channel Number.\n\nIdentifiziert die exakte Trägerfrequenz, die das Gerät verwendet; sie ordnet sich einem bestimmten LTE-Band und -Kanal zu.';

  @override
  String get estDistHint =>
      'Geschätzte Entfernung zum Mobilfunkmast.\n\nAbgeleitet aus der Signalstärke (RSRP) mit einem Funkausbreitungsmodell. Es ist nur ein sehr grober Anhaltspunkt in der Größenordnung — keine präzise Messung.';
}
