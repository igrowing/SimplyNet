// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsTitle => 'Definições';

  @override
  String get appearance => 'Aparência';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Tempo de ecrã ligado';

  @override
  String get timeoutSystem => 'Sistema';

  @override
  String get timeoutTriple => '3× Sistema';

  @override
  String get timeoutStayOn => 'Manter ligado';

  @override
  String get scanning => 'Análise';

  @override
  String get showMacAddress => 'Mostrar endereço MAC';

  @override
  String get showMacBlocked =>
      'Desativado no Android v.11 e superior devido a preocupações de privacidade da Google';

  @override
  String get showMacSubtitle =>
      'Mostrar a coluna MAC nos resultados da análise';

  @override
  String get resolveHostnames => 'Resolver nomes de host';

  @override
  String get resolveHostnamesSubtitle =>
      'Efetuar DNS inverso + mDNS durante a análise';

  @override
  String get enableLogging => 'Ativar registo';

  @override
  String get enableLoggingSubtitle =>
      'Guardar a saída de análises e ferramentas em ficheiros de registo';

  @override
  String get account => 'Conta';

  @override
  String get logIn => 'Iniciar sessão';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get settings => 'Definições';

  @override
  String get aboutSimplyNet => 'Sobre o SimplyNet';

  @override
  String get scan => 'Analisar';

  @override
  String get logs => 'Registos';

  @override
  String get networkTools => 'Ferramentas de rede';

  @override
  String get networkTarget => 'Alvo de rede';

  @override
  String get networkTargetHint => 'ex. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'CIDR inválido — use um formato como 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Detetar a minha rede';

  @override
  String get toolSpeedTest => 'Teste de velocidade';

  @override
  String get toolSpeedTestSub => 'Velocidade de download e upload';

  @override
  String get toolPublicIp => 'IP público';

  @override
  String get toolPublicIpSub => 'O seu IP, ISP e localização';

  @override
  String get toolIpCameras => 'Câmaras IP';

  @override
  String get toolIpCamerasSub => 'Encontrar câmaras na sua LAN';

  @override
  String get toolIotDevices => 'Dispositivos IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly e mais';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Subscrever um tópico MQTT';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publicar num tópico MQTT';

  @override
  String get toolPortScan => 'Análise de portas';

  @override
  String get toolPortScanSub => 'Portas TCP/UDP abertas em qualquer host';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping em tempo real com gráfico';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Caminho salto a salto até qualquer host';

  @override
  String get toolWhois => 'Quem é…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS e pesquisa inversa';

  @override
  String get toolWifiChannels => 'Canais Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Mapa de interferência 2,4 e 5 GHz';

  @override
  String get toolCellularInfo => 'Info móvel';

  @override
  String get toolCellularInfoSub => 'Sinal, ID da célula e dados da torre';

  @override
  String get about => 'Sobre';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Eliminar';

  @override
  String get retry => 'Tentar de novo';
}
