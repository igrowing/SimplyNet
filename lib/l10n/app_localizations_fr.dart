// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Délai d\'écran allumé';

  @override
  String get timeoutSystem => 'Système';

  @override
  String get timeoutTriple => '3× Système';

  @override
  String get timeoutStayOn => 'Rester allumé';

  @override
  String get scanning => 'Analyse';

  @override
  String get showMacAddress => 'Afficher l\'adresse MAC';

  @override
  String get showMacBlocked =>
      'Désactivé sur Android v.11 et plus pour des raisons de confidentialité de Google';

  @override
  String get showMacSubtitle =>
      'Afficher la colonne MAC dans les résultats d\'analyse';

  @override
  String get resolveHostnames => 'Résoudre les noms d\'hôte';

  @override
  String get resolveHostnamesSubtitle =>
      'Effectuer un DNS inversé + mDNS pendant l\'analyse';

  @override
  String get enableLogging => 'Activer la journalisation';

  @override
  String get enableLoggingSubtitle =>
      'Enregistrer la sortie des analyses et outils dans des fichiers journaux';

  @override
  String get account => 'Compte';

  @override
  String get logIn => 'Se connecter';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get settings => 'Paramètres';

  @override
  String get aboutSimplyNet => 'À propos de SimplyNet';

  @override
  String get scan => 'Analyser';

  @override
  String get logs => 'Journaux';

  @override
  String get networkTools => 'Outils réseau';

  @override
  String get networkTarget => 'Cible réseau';

  @override
  String get networkTargetHint => 'ex. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'CIDR non valide — utilisez un format comme 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Détecter mon réseau';

  @override
  String get toolSpeedTest => 'Test de débit';

  @override
  String get toolSpeedTestSub => 'Débit descendant et montant';

  @override
  String get toolPublicIp => 'IP publique';

  @override
  String get toolPublicIpSub => 'Votre IP, FAI et localisation';

  @override
  String get toolIpCameras => 'Caméras IP';

  @override
  String get toolIpCamerasSub => 'Trouver des caméras sur votre LAN';

  @override
  String get toolIotDevices => 'Appareils IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly et plus';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'S\'abonner à un topic MQTT';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publier sur un topic MQTT';

  @override
  String get toolPortScan => 'Scan de ports';

  @override
  String get toolPortScanSub =>
      'Ports TCP/UDP ouverts sur n\'importe quel hôte';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping en direct avec graphique';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub =>
      'Chemin saut par saut vers n\'importe quel hôte';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS et recherche inversée';

  @override
  String get toolWifiChannels => 'Canaux Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Carte des interférences 2,4 et 5 GHz';

  @override
  String get toolCellularInfo => 'Info cellulaire';

  @override
  String get toolCellularInfoSub =>
      'Signal, ID de cellule et données d\'antenne';

  @override
  String get about => 'À propos';

  @override
  String get close => 'Fermer';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Supprimer';

  @override
  String get retry => 'Réessayer';

  @override
  String get stop => 'Arrêter';

  @override
  String get clear => 'Effacer';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Copié';

  @override
  String get copyIp => 'Copier l\'IP';

  @override
  String get hostHint => 'Adresse IP ou nom d\'hôte';

  @override
  String get domainHostHint => 'Domaine, adresse IP ou nom d\'hôte';

  @override
  String get go => 'Go';

  @override
  String get trace => 'Tracer';

  @override
  String get lookUp => 'Rechercher';

  @override
  String get lookingUp => 'Recherche…';

  @override
  String get enterHostGo => 'Saisissez un hôte et appuyez sur Go';

  @override
  String get enterHostTrace => 'Saisissez un hôte et appuyez sur Tracer';

  @override
  String get enterHostScan => 'Saisissez un hôte et touchez Analyser';

  @override
  String get enterDomainIp => 'Saisissez un domaine, une IP ou un nom d\'hôte';

  @override
  String get aboutPing => 'À propos de Ping';

  @override
  String get aboutTraceroute => 'À propos de Traceroute';

  @override
  String get aboutWhois => 'À propos de Who Is';

  @override
  String get aboutPortScan => 'À propos de Port Scan';

  @override
  String get hiddenNode => 'Nœud caché';

  @override
  String get destination => 'Destination';

  @override
  String get yourRouter => 'Votre routeur';

  @override
  String get networkHop => 'Saut réseau';

  @override
  String get hop => 'Saut';

  @override
  String get noReply => 'aucune réponse';

  @override
  String get probingNextHop => 'Sondage du saut suivant…';

  @override
  String get hiddenNodeInfo =>
      'Ce routeur n\'a pas répondu à nos sondes. De nombreux FAI, pare-feu et équipements de sécurité rejettent ou limitent délibérément le trafic ICMP (ping), de sorte que le saut reste anonyme même si vos données y transitent toujours.\n\nC\'est normal et ne signifie pas que la route est rompue.';

  @override
  String get portsLabel => 'Ports :';

  @override
  String get wellKnown => 'Bien connus';

  @override
  String get rangeLabel => 'Plage';

  @override
  String get fromLabel => 'De :';

  @override
  String get toLabel => 'À :';

  @override
  String get protocolLabel => 'Protocole :';

  @override
  String get hideSettings => 'Masquer les paramètres';

  @override
  String get myPublicIp => 'Mon IP publique';

  @override
  String get errorLabel => 'Erreur';

  @override
  String get infoUnavailable => 'Informations indisponibles.';

  @override
  String get startTest => 'Démarrer le test';

  @override
  String get download => 'Téléchargement';

  @override
  String get upload => 'Téléversement';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusDone => 'Terminé';

  @override
  String get measuringPing => 'Mesure du ping…';

  @override
  String get findingServer => 'Recherche du serveur…';

  @override
  String get testingDownload => 'Test du téléchargement…';

  @override
  String get testingUpload => 'Test du téléversement…';

  @override
  String get viaCloudflare => 'Via Cloudflare';

  @override
  String get viaOokla => 'Via Ookla';

  @override
  String get aboutSpeedTestTip => 'À propos du test de débit';

  @override
  String get speedTestInfo => 'Info test de débit';

  @override
  String get previousMeasurements => 'Mesures précédentes';

  @override
  String get noMeasurements => 'Aucune mesure pour l\'instant.';

  @override
  String get dateTime => 'Date / Heure';

  @override
  String get switchToOokla => 'Passer à Ookla ?';

  @override
  String get ooklaConsentBody =>
      'Passer à Ookla nécessite de se connecter à des serveurs tiers. Ookla collecte et partage votre adresse IP, les identifiants de l\'appareil et les données de localisation.';

  @override
  String get decline => 'Refuser';

  @override
  String get accept => 'Accepter';

  @override
  String get clearHistoryTitle => 'Effacer l\'historique ?';

  @override
  String get clearHistoryBody =>
      'Cela supprimera définitivement tous les enregistrements de mesure.';

  @override
  String get aboutThisScan => 'À propos de cette analyse';

  @override
  String get scanInfoBody =>
      'Les appareils qui bloquent ICMP (pings) n\'apparaîtront pas ici. Lancez l\'analyse « Appareils IoT » ou « Caméras IP » pour les localiser via leurs ports et services ouverts.\n\nSur les appareils Android 11+, les adresses MAC ne peuvent pas être récupérées en raison des restrictions de confidentialité de Google, elles ne sont donc pas affichées.';

  @override
  String get stopScan => 'Arrêter l\'analyse';

  @override
  String get reScan => 'Relancer l\'analyse';

  @override
  String get hostsFound => 'hôte(s) trouvé(s)';

  @override
  String get hostname => 'Nom d\'hôte';

  @override
  String get noSavedResults => 'Aucun résultat enregistré';

  @override
  String get noNetworkTarget => 'Aucune cible réseau définie';

  @override
  String get tapRefreshToScan =>
      'Touchez le bouton d\'actualisation pour analyser';

  @override
  String get setTargetHome => 'Définissez une cible sur l\'écran d\'accueil';

  @override
  String get openInBrowser => 'Ouvrir dans le navigateur (HTTP)';

  @override
  String get openSsh => 'Ouvrir SSH';

  @override
  String get couldNotOpenBrowser => 'Impossible d\'ouvrir le navigateur';

  @override
  String get noSshApp =>
      'Aucune application SSH trouvée. Installez ConnectBot ou Termius.';

  @override
  String get deviceInfo => 'Infos appareil';

  @override
  String get ipAddress => 'Adresse IP';

  @override
  String get macAddress => 'Adresse MAC';

  @override
  String get manufacturer => 'Fabricant';

  @override
  String get deviceTypeLabel => 'Type d\'appareil';

  @override
  String get openPorts => 'Ports ouverts';

  @override
  String get stopPortScan => 'Arrêter l\'analyse des ports';

  @override
  String get portScanSettings => 'Paramètres de l\'analyse des ports';

  @override
  String get reScanPorts => 'Relancer l\'analyse des ports';

  @override
  String get noOpenPorts => 'Aucun port ouvert trouvé.';

  @override
  String get applyRescan => 'Appliquer et relancer';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get times => 'fois';

  @override
  String get deleteAllLogs => 'Supprimer tous les journaux';

  @override
  String get deleteAllLogsQ => 'Supprimer tous les journaux ?';

  @override
  String get cannotBeUndone => 'Cette action est irréversible.';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get deleteLogQ => 'Supprimer le journal ?';

  @override
  String get noLogsYet => 'Aucun journal pour l\'instant';

  @override
  String get scanningEllipsis => 'Analyse…';

  @override
  String get iotDevicesFound => 'appareil(s) IoT trouvé(s)';

  @override
  String get iotNoSaved =>
      'Aucun résultat enregistré.\nActualisez pour analyser.';

  @override
  String get unknown => 'Inconnu';

  @override
  String get viaLabel => 'via';

  @override
  String get confDefinite => 'certain';

  @override
  String get confProbable => 'probable';

  @override
  String get confPossible => 'possible';

  @override
  String get ipCameraScan => 'Analyse des caméras IP';

  @override
  String get camMethodProtocolPort => 'Port de protocole';

  @override
  String get camMethodKnownVendor => 'Fabricant connu';

  @override
  String get camMethodHttpFingerprint => 'Empreinte HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Analyse… $done/$total hôtes — $n caméra(s)';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Aucun résultat enregistré — actualisez pour analyser $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n caméra(s) trouvée(s) — $cidr';
  }

  @override
  String get noCamerasFound => 'Aucune caméra trouvée.';

  @override
  String get mqttSettingsTitle => 'Paramètres MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN du broker';

  @override
  String get searchingSubnet => 'Recherche du sous-réseau…';

  @override
  String get brokerHint => 'ex. 192.168.1.10 ou broker.example.com';

  @override
  String get portLabel => 'Port';

  @override
  String get usernameOptional => 'Nom d\'utilisateur (facultatif)';

  @override
  String get leaveEmptyOptional => 'laisser vide si non requis';

  @override
  String get passwordOptional => 'Mot de passe (facultatif)';

  @override
  String get keepPassword => 'Conserver le mot de passe (déconseillé)';

  @override
  String get keepPasswordSub =>
      'Le mot de passe est stocké en clair dans le stockage de l\'app.';

  @override
  String get save => 'Enregistrer';

  @override
  String get screenStaysOn => 'L\'écran reste allumé';

  @override
  String get screenMaySleep => 'L\'écran peut s\'éteindre';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Sujet';

  @override
  String get topicSubHint => 'ex. home/sensor/# ou home/sensor/temp';

  @override
  String get listen => 'Écouter';

  @override
  String get humanReadableJson => 'JSON lisible';

  @override
  String get waitingForMessages => 'En attente de messages…';

  @override
  String get enterTopicListen => 'Saisissez un sujet et touchez Écouter';

  @override
  String get tapListenReceive => 'Touchez Écouter pour commencer à recevoir';

  @override
  String get enterTopicTapListen => 'Saisissez le sujet et touchez Écouter';

  @override
  String get enterTopicFirst => 'Saisissez d\'abord un sujet.';

  @override
  String get stoppedStatus => 'Arrêté.';

  @override
  String get connectingStatus => 'Connexion…';

  @override
  String get reconnectingStatus => 'Reconnexion…';

  @override
  String listeningOn(Object topic) {
    return 'Écoute sur \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Échec de la connexion : $e';
  }

  @override
  String get topicPubHint => 'ex. home/light/switch';

  @override
  String get messageLabel => 'Message';

  @override
  String get enterPayload => 'Saisir la charge utile…';

  @override
  String get retain => 'Conserver';

  @override
  String get retainSub =>
      'Le broker conserve le dernier message pour les nouveaux abonnés.';

  @override
  String get publish => 'Publier';

  @override
  String get connectedEnterTopic => 'Connecté — saisissez un sujet ci-dessous';

  @override
  String connectedTopic(Object topic) {
    return 'Connecté — sujet : \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Déconnecté';

  @override
  String publishedTo(Object topic) {
    return 'Publié sur \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'À propos des canaux 5 GHz';

  @override
  String get wifiBandInfoTitle =>
      'Détection de point d\'accès double sur le réseau 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 Maintenez le SSID pour voir le nom complet du point d\'accès.\n\nℹ️ Sur la bande 5 GHz, vous verrez généralement chaque point d\'accès sur deux canaux (ou plus) à la fois. C\'est normal.\n\nPour aller plus vite, les routeurs modernes collent des canaux voisins de 20 MHz en une voie plus large — 40, 80 ou même 160 MHz. Cela s\'appelle le \"channel bonding\". Une voie plus large transporte plus de données, comme une route plus large accueille plus de voitures.\n\nAvec la \"largeur de canal dynamique\", le routeur choisit la voie la plus large possible et la rétrécit automatiquement quand l\'air devient chargé ou bruyant, pour rester rapide sans gêner les voisins.\n\nAinsi, un seul réseau 5 GHz apparaissant sur les canaux 36 et 40, par exemple, n\'est qu\'un point d\'accès utilisant un canal lié de 40 MHz — pas deux réseaux distincts.';

  @override
  String get noResults => 'Aucun résultat.';

  @override
  String get scanErrorPrefix => 'Erreur d\'analyse';

  @override
  String noBandNetworks(Object band) {
    return 'Aucun réseau $band détecté.';
  }

  @override
  String get securityLabel => 'Sécurité';

  @override
  String get qualityLabel => 'Qualité';

  @override
  String get qExcellent => 'Excellent';

  @override
  String get qGood => 'Bon';

  @override
  String get qFair => 'Moyen';

  @override
  String get qWeak => 'Faible';

  @override
  String get qPoor => 'Mauvais';

  @override
  String get refresh => 'Actualiser';

  @override
  String get cellShowingDemo => 'Affichage de données de démonstration.';

  @override
  String get noDataReturned => 'Aucune donnée renvoyée par l\'appareil.';

  @override
  String get platformErrorPrefix => 'Erreur de plateforme';

  @override
  String get carrier => 'Opérateur';

  @override
  String get provider => 'Fournisseur';

  @override
  String get technology => 'Technologie';

  @override
  String get roaming => 'Itinérance';

  @override
  String get dataState => 'État des données';

  @override
  String get signalQuality => 'Qualité du signal';

  @override
  String get cellTower => 'Antenne-relais';

  @override
  String get cellId => 'ID de cellule';

  @override
  String get bandLabel => 'Bande';

  @override
  String get estDistance => 'Distance est.';

  @override
  String get location => 'Emplacement';

  @override
  String get coordinates => 'Coordonnées';

  @override
  String get locating => 'Localisation…';

  @override
  String get nearestPlace => 'Lieu le plus proche';

  @override
  String get deniedByUser => 'Refusé par l\'utilisateur';

  @override
  String get unavailablePrefix => 'Indisponible';

  @override
  String get signalStrength => 'Force du signal';

  @override
  String get rsrpHint =>
      'RSRP — Puissance reçue du signal de référence.\n\nLa puissance moyenne des signaux de référence de la cellule, mesurée en dBm. Elle reflète la force brute du signal.\n\nPlage typique : d\'environ −80 dBm (excellent) jusqu\'à −120 dBm (très faible). Plus élevé (proche de zéro) est meilleur.';

  @override
  String get rsrqHint =>
      'RSRQ — Qualité reçue du signal de référence.\n\nQualité du signal en dB, prenant en compte les interférences et la charge du réseau en plus de la force.\n\nPlage typique : d\'environ −3 dB (excellent) jusqu\'à −20 dB (mauvais). Plus élevé est meilleur.';

  @override
  String get sinrHint =>
      'SINR — rapport signal sur interférence plus bruit.\n\nDe combien le signal utile dépasse l\'interférence plus le bruit de fond, en dB.\n\nPlus élevé est meilleur : au-dessus de ~20 dB est excellent, autour de 0 dB ou en dessous est mauvais.';

  @override
  String get pciHint =>
      'PCI — Identifiant physique de cellule.\n\nUn nombre (0–503 en LTE) qui identifie la cellule desservante sur l\'interface radio. Les cellules voisines utilisent des PCI différents pour que le téléphone puisse les distinguer.';

  @override
  String get earfcnHint =>
      'EARFCN — numéro absolu de canal de radiofréquence E-UTRA.\n\nIdentifie la fréquence porteuse exacte utilisée par l\'appareil ; il correspond à une bande et un canal LTE spécifiques.';

  @override
  String get estDistHint =>
      'Distance estimée jusqu\'à l\'antenne-relais.\n\nDérivée de la force du signal (RSRP) à l\'aide d\'un modèle de propagation radio. Ce n\'est qu\'une indication très approximative, d\'ordre de grandeur — pas une mesure précise.';
}
