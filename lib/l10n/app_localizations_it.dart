// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get appearance => 'Aspetto';

  @override
  String get language => 'Lingua';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Timeout schermo acceso';

  @override
  String get timeoutSystem => 'Sistema';

  @override
  String get timeoutTriple => '3× Sistema';

  @override
  String get timeoutStayOn => 'Sempre acceso';

  @override
  String get scanning => 'Scansione';

  @override
  String get showMacAddress => 'Mostra indirizzo MAC';

  @override
  String get showMacBlocked =>
      'Disabilitato su Android v.11 e successivi per motivi di privacy di Google';

  @override
  String get showMacSubtitle =>
      'Mostra la colonna MAC nei risultati della scansione';

  @override
  String get resolveHostnames => 'Risolvi nomi host';

  @override
  String get resolveHostnamesSubtitle =>
      'Esegui DNS inverso + mDNS durante la scansione';

  @override
  String get enableLogging => 'Abilita registro';

  @override
  String get enableLoggingSubtitle =>
      'Salva l\'output di scansioni e strumenti su file di log';

  @override
  String get account => 'Account';

  @override
  String get logIn => 'Accedi';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String get settings => 'Impostazioni';

  @override
  String get aboutSimplyNet => 'Informazioni su SimplyNet';

  @override
  String get scan => 'Scansione';

  @override
  String get logs => 'Registri';

  @override
  String get networkTools => 'Strumenti di rete';

  @override
  String get networkTarget => 'Destinazione di rete';

  @override
  String get networkTargetHint => 'es. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'CIDR non valido — usa un formato come 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Rileva la mia rete';

  @override
  String get toolSpeedTest => 'Test velocità';

  @override
  String get toolSpeedTestSub => 'Velocità di download e upload';

  @override
  String get toolPublicIp => 'IP pubblico';

  @override
  String get toolPublicIpSub => 'Il tuo IP, ISP e posizione';

  @override
  String get toolIpCameras => 'Telecamere IP';

  @override
  String get toolIpCamerasSub => 'Trova telecamere nella tua LAN';

  @override
  String get toolIotDevices => 'Dispositivi IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly e altri';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Iscriviti a un topic MQTT';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Pubblica su un topic MQTT';

  @override
  String get toolPortScan => 'Scansione porte';

  @override
  String get toolPortScanSub => 'Porte TCP/UDP aperte su qualsiasi host';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping in tempo reale con grafico';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Percorso salto per salto verso un host';

  @override
  String get toolWhois => 'Chi è…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS e ricerca inversa';

  @override
  String get toolWifiChannels => 'Canali Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Mappa interferenze 2,4 e 5 GHz';

  @override
  String get toolCellularInfo => 'Info cellulare';

  @override
  String get toolCellularInfoSub => 'Segnale, ID cella e dati torre';

  @override
  String get about => 'Informazioni';

  @override
  String get close => 'Chiudi';

  @override
  String get cancel => 'Annulla';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Elimina';

  @override
  String get retry => 'Riprova';

  @override
  String get stop => 'Ferma';

  @override
  String get clear => 'Cancella';

  @override
  String get copy => 'Copia';

  @override
  String get copied => 'Copiato';

  @override
  String get copyIp => 'Copia IP';

  @override
  String get hostHint => 'Indirizzo IP o hostname';

  @override
  String get domainHostHint => 'Dominio, indirizzo IP o hostname';

  @override
  String get go => 'Vai';

  @override
  String get trace => 'Traccia';

  @override
  String get lookUp => 'Cerca';

  @override
  String get lookingUp => 'Ricerca…';

  @override
  String get enterHostGo => 'Inserisci un host e premi Vai';

  @override
  String get enterHostTrace => 'Inserisci un host e premi Traccia';

  @override
  String get enterHostScan => 'Inserisci un host e tocca Scansione';

  @override
  String get enterDomainIp => 'Inserisci un dominio, IP o hostname';

  @override
  String get aboutPing => 'Informazioni su Ping';

  @override
  String get aboutTraceroute => 'Informazioni su Traceroute';

  @override
  String get aboutWhois => 'Informazioni su Who Is';

  @override
  String get aboutPortScan => 'Informazioni su Port Scan';

  @override
  String get hiddenNode => 'Nodo nascosto';

  @override
  String get destination => 'Destinazione';

  @override
  String get yourRouter => 'Il tuo router';

  @override
  String get networkHop => 'Salto di rete';

  @override
  String get hop => 'Salto';

  @override
  String get noReply => 'nessuna risposta';

  @override
  String get probingNextHop => 'Sondaggio salto successivo…';

  @override
  String get hiddenNodeInfo =>
      'Questo router non ha risposto ai nostri probe. Molti ISP, firewall e apparati di sicurezza scartano o limitano deliberatamente il traffico ICMP (ping), quindi il salto resta anonimo anche se i tuoi dati continuano a passarci.\n\nÈ normale e non significa che il percorso sia interrotto.';

  @override
  String get portsLabel => 'Porte:';

  @override
  String get wellKnown => 'Ben note';

  @override
  String get rangeLabel => 'Intervallo';

  @override
  String get fromLabel => 'Da:';

  @override
  String get toLabel => 'A:';

  @override
  String get protocolLabel => 'Protocollo:';

  @override
  String get hideSettings => 'Nascondi impostazioni';

  @override
  String get myPublicIp => 'Il mio IP pubblico';

  @override
  String get errorLabel => 'Errore';

  @override
  String get infoUnavailable => 'Informazioni non disponibili.';

  @override
  String get startTest => 'Avvia test';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusDone => 'Fatto';

  @override
  String get measuringPing => 'Misurazione ping…';

  @override
  String get findingServer => 'Ricerca server…';

  @override
  String get testingDownload => 'Test download…';

  @override
  String get testingUpload => 'Test upload…';

  @override
  String get viaCloudflare => 'Tramite Cloudflare';

  @override
  String get viaOokla => 'Tramite Ookla';

  @override
  String get aboutSpeedTestTip => 'Informazioni sul test di velocità';

  @override
  String get speedTestInfo => 'Info test velocità';

  @override
  String get previousMeasurements => 'Misurazioni precedenti';

  @override
  String get noMeasurements => 'Nessuna misurazione ancora.';

  @override
  String get dateTime => 'Data / Ora';

  @override
  String get switchToOokla => 'Passare a Ookla?';

  @override
  String get ooklaConsentBody =>
      'Passare a Ookla richiede la connessione a server di terze parti. Ookla raccoglie e condivide il tuo indirizzo IP, gli identificatori del dispositivo e i dati di posizione.';

  @override
  String get decline => 'Rifiuta';

  @override
  String get accept => 'Accetta';

  @override
  String get clearHistoryTitle => 'Cancellare la cronologia?';

  @override
  String get clearHistoryBody =>
      'Questo eliminerà definitivamente tutti i record di misurazione.';

  @override
  String get aboutThisScan => 'Informazioni su questa scansione';

  @override
  String get scanInfoBody =>
      'I dispositivi che bloccano ICMP (ping) non appariranno qui. Esegui la scansione \'Dispositivi IoT\' o \'Telecamere IP\' per individuarli tramite le loro porte e servizi aperti.\n\nSui dispositivi Android 11+, gli indirizzi MAC non possono essere recuperati a causa delle restrizioni sulla privacy di Google, quindi non vengono mostrati.';

  @override
  String get stopScan => 'Ferma scansione';

  @override
  String get reScan => 'Ripeti scansione';

  @override
  String get hostsFound => 'host trovati';

  @override
  String get hostname => 'Hostname';

  @override
  String get noSavedResults => 'Nessun risultato salvato';

  @override
  String get noNetworkTarget => 'Nessuna destinazione di rete impostata';

  @override
  String get tapRefreshToScan =>
      'Tocca il pulsante di aggiornamento per scansionare';

  @override
  String get setTargetHome => 'Imposta una destinazione nella schermata Home';

  @override
  String get openInBrowser => 'Apri nel browser (HTTP)';

  @override
  String get openSsh => 'Apri SSH';

  @override
  String get couldNotOpenBrowser => 'Impossibile aprire il browser';

  @override
  String get noSshApp =>
      'Nessuna app SSH trovata. Installa ConnectBot o Termius.';

  @override
  String get deviceInfo => 'Info dispositivo';

  @override
  String get ipAddress => 'Indirizzo IP';

  @override
  String get macAddress => 'Indirizzo MAC';

  @override
  String get manufacturer => 'Produttore';

  @override
  String get deviceTypeLabel => 'Tipo di dispositivo';

  @override
  String get openPorts => 'Porte aperte';

  @override
  String get stopPortScan => 'Ferma scansione porte';

  @override
  String get portScanSettings => 'Impostazioni scansione porte';

  @override
  String get reScanPorts => 'Riscansiona porte';

  @override
  String get noOpenPorts => 'Nessuna porta aperta trovata.';

  @override
  String get applyRescan => 'Applica e riscansiona';

  @override
  String get diagnostics => 'Diagnostica';

  @override
  String get times => 'volte';

  @override
  String get deleteAllLogs => 'Elimina tutti i log';

  @override
  String get deleteAllLogsQ => 'Eliminare tutti i log?';

  @override
  String get cannotBeUndone => 'Questa azione non può essere annullata.';

  @override
  String get deleteAll => 'Elimina tutti';

  @override
  String get deleteLogQ => 'Eliminare il log?';

  @override
  String get noLogsYet => 'Nessun log ancora';

  @override
  String get scanningEllipsis => 'Scansione…';

  @override
  String get iotDevicesFound => 'dispositivi IoT trovati';

  @override
  String get iotNoSaved =>
      'Nessun risultato salvato.\nTocca aggiorna per scansionare.';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get viaLabel => 'tramite';

  @override
  String get confDefinite => 'certo';

  @override
  String get confProbable => 'probabile';

  @override
  String get confPossible => 'possibile';

  @override
  String get ipCameraScan => 'Scansione telecamere IP';

  @override
  String get camMethodProtocolPort => 'Porta protocollo';

  @override
  String get camMethodKnownVendor => 'Produttore noto';

  @override
  String get camMethodHttpFingerprint => 'Impronta HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Scansione… $done/$total host — $n telecamere';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Nessun risultato salvato — tocca aggiorna per scansionare $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n telecamere trovate — $cidr';
  }

  @override
  String get noCamerasFound => 'Nessuna telecamera trovata.';

  @override
  String get mqttSettingsTitle => 'Impostazioni MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN del broker';

  @override
  String get searchingSubnet => 'Ricerca nella subnet…';

  @override
  String get brokerHint => 'es. 192.168.1.10 o broker.example.com';

  @override
  String get portLabel => 'Porta';

  @override
  String get usernameOptional => 'Nome utente (opzionale)';

  @override
  String get leaveEmptyOptional => 'lascia vuoto se non richiesto';

  @override
  String get passwordOptional => 'Password (opzionale)';

  @override
  String get keepPassword => 'Conserva password (sconsigliato)';

  @override
  String get keepPasswordSub =>
      'La password è salvata in chiaro nella memoria dell\'app.';

  @override
  String get save => 'Salva';

  @override
  String get screenStaysOn => 'Schermo sempre acceso';

  @override
  String get screenMaySleep => 'Lo schermo può spegnersi';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Argomento';

  @override
  String get topicSubHint => 'es. home/sensor/# o home/sensor/temp';

  @override
  String get listen => 'Ascolta';

  @override
  String get humanReadableJson => 'JSON leggibile';

  @override
  String get waitingForMessages => 'In attesa di messaggi…';

  @override
  String get enterTopicListen => 'Inserisci un argomento e tocca Ascolta';

  @override
  String get tapListenReceive => 'Tocca Ascolta per iniziare a ricevere';

  @override
  String get enterTopicTapListen => 'Inserisci l\'argomento e tocca Ascolta';

  @override
  String get enterTopicFirst => 'Inserisci prima un argomento.';

  @override
  String get stoppedStatus => 'Fermato.';

  @override
  String get connectingStatus => 'Connessione…';

  @override
  String get reconnectingStatus => 'Riconnessione…';

  @override
  String listeningOn(Object topic) {
    return 'In ascolto su \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Connessione fallita: $e';
  }

  @override
  String get topicPubHint => 'es. home/light/switch';

  @override
  String get messageLabel => 'Messaggio';

  @override
  String get enterPayload => 'Inserisci il payload…';

  @override
  String get retain => 'Mantieni';

  @override
  String get retainSub =>
      'Il broker mantiene l\'ultimo messaggio per i nuovi iscritti.';

  @override
  String get publish => 'Pubblica';

  @override
  String get connectedEnterTopic => 'Connesso — inserisci un argomento sotto';

  @override
  String connectedTopic(Object topic) {
    return 'Connesso — argomento: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Disconnesso';

  @override
  String publishedTo(Object topic) {
    return 'Pubblicato su \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'Informazioni sui canali 5 GHz';

  @override
  String get wifiBandInfoTitle =>
      'Rilevamento di doppio access point nella rete 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 Tieni premuto l\'SSID per vedere il nome completo dell\'access point.\n\nℹ️ Sulla banda 5 GHz di solito vedrai ogni access point apparire su due (o più) canali contemporaneamente. È normale.\n\nPer andare più veloci, i router moderni uniscono canali vicini da 20 MHz in una corsia più ampia — 40, 80 o persino 160 MHz. Questo si chiama \"channel bonding\". Una corsia più ampia trasporta più dati, proprio come una strada più larga trasporta più auto.\n\nCon la \"larghezza di canale dinamica\" il router sceglie la corsia più ampia possibile e la restringe automaticamente quando l\'etere è affollato o rumoroso, per restare veloce senza disturbare i vicini.\n\nQuindi una singola rete 5 GHz che appare sui canali 36 e 40, ad esempio, è solo un access point che usa un canale unito ampio 40 MHz — non due reti separate.';

  @override
  String get noResults => 'Nessun risultato.';

  @override
  String get scanErrorPrefix => 'Errore di scansione';

  @override
  String noBandNetworks(Object band) {
    return 'Nessuna rete $band rilevata.';
  }

  @override
  String get securityLabel => 'Sicurezza';

  @override
  String get qualityLabel => 'Qualità';

  @override
  String get qExcellent => 'Eccellente';

  @override
  String get qGood => 'Buono';

  @override
  String get qFair => 'Discreto';

  @override
  String get qWeak => 'Debole';

  @override
  String get qPoor => 'Scarso';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get cellShowingDemo => 'Visualizzazione dati dimostrativi.';

  @override
  String get noDataReturned => 'Nessun dato restituito dal dispositivo.';

  @override
  String get platformErrorPrefix => 'Errore di piattaforma';

  @override
  String get carrier => 'Operatore';

  @override
  String get provider => 'Operatore';

  @override
  String get technology => 'Tecnologia';

  @override
  String get roaming => 'Roaming';

  @override
  String get dataState => 'Stato dati';

  @override
  String get signalQuality => 'Qualità del segnale';

  @override
  String get cellTower => 'Cella';

  @override
  String get cellId => 'ID cella';

  @override
  String get bandLabel => 'Banda';

  @override
  String get estDistance => 'Distanza stim.';

  @override
  String get location => 'Posizione';

  @override
  String get coordinates => 'Coordinate';

  @override
  String get locating => 'Localizzazione…';

  @override
  String get nearestPlace => 'Luogo più vicino';

  @override
  String get deniedByUser => 'Negato dall\'utente';

  @override
  String get unavailablePrefix => 'Non disponibile';

  @override
  String get signalStrength => 'Intensità del segnale';

  @override
  String get rsrpHint =>
      'RSRP — Reference Signal Received Power (potenza ricevuta del segnale di riferimento).\n\nLa potenza media dei segnali di riferimento della cella, misurata in dBm. Riflette l\'intensità grezza del segnale.\n\nIntervallo tipico: da circa −80 dBm (eccellente) fino a −120 dBm (molto debole). Più alto (vicino a zero) è meglio.';

  @override
  String get rsrqHint =>
      'RSRQ — Reference Signal Received Quality (qualità ricevuta del segnale di riferimento).\n\nQualità del segnale in dB, che tiene conto di interferenze e carico di rete oltre all\'intensità.\n\nIntervallo tipico: da circa −3 dB (eccellente) fino a −20 dB (scarso). Più alto è meglio.';

  @override
  String get sinrHint =>
      'SINR — rapporto segnale/interferenza+rumore.\n\nDi quanto il segnale desiderato supera l\'interferenza più il rumore di fondo, in dB.\n\nPiù alto è meglio: sopra ~20 dB è eccellente, intorno a 0 dB o meno è scarso.';

  @override
  String get pciHint =>
      'PCI — Physical Cell ID (identificatore fisico della cella).\n\nUn numero (0–503 su LTE) che identifica la cella servente sull\'interfaccia radio. Le celle vicine usano PCI diversi così il telefono può distinguerle.';

  @override
  String get earfcnHint =>
      'EARFCN — numero assoluto di canale in radiofrequenza E-UTRA.\n\nIdentifica la frequenza portante esatta usata dal dispositivo; corrisponde a una specifica banda e canale LTE.';

  @override
  String get estDistHint =>
      'Distanza stimata dalla cella.\n\nDerivata dall\'intensità del segnale (RSRP) usando un modello di propagazione radio. È solo un\'indicazione molto approssimativa, dell\'ordine di grandezza — non una misura precisa.';

  @override
  String get version => 'Versione';

  @override
  String get sendFeedback => 'Invia un feedback / idea di miglioramento';

  @override
  String get buyMeCoffee => 'Offrimi un caffè';

  @override
  String get shareAction => 'Condividi';
}
