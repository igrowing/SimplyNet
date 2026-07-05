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
}
