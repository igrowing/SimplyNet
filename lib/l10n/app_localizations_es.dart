// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Tiempo de pantalla encendida';

  @override
  String get timeoutSystem => 'Sistema';

  @override
  String get timeoutTriple => '3× Sistema';

  @override
  String get timeoutStayOn => 'Siempre encendida';

  @override
  String get scanning => 'Escaneo';

  @override
  String get showMacAddress => 'Mostrar dirección MAC';

  @override
  String get showMacBlocked =>
      'Desactivado en Android v.11 y superior por motivos de privacidad de Google';

  @override
  String get showMacSubtitle =>
      'Mostrar la columna MAC en los resultados del escaneo';

  @override
  String get resolveHostnames => 'Resolver nombres de host';

  @override
  String get resolveHostnamesSubtitle =>
      'Realizar DNS inverso + mDNS durante el escaneo';

  @override
  String get enableLogging => 'Activar registro';

  @override
  String get enableLoggingSubtitle =>
      'Guardar la salida de escaneos y herramientas en archivos de registro';

  @override
  String get account => 'Cuenta';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get settings => 'Ajustes';

  @override
  String get aboutSimplyNet => 'Acerca de SimplyNet';

  @override
  String get scan => 'Escanear';

  @override
  String get logs => 'Registros';

  @override
  String get networkTools => 'Herramientas de red';

  @override
  String get networkTarget => 'Objetivo de red';

  @override
  String get networkTargetHint => 'p. ej. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'CIDR no válido — usa un formato como 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Detectar mi red';

  @override
  String get toolSpeedTest => 'Prueba de velocidad';

  @override
  String get toolSpeedTestSub => 'Velocidad de bajada y subida';

  @override
  String get toolPublicIp => 'IP pública';

  @override
  String get toolPublicIpSub => 'Tu IP, ISP y ubicación';

  @override
  String get toolIpCameras => 'Cámaras IP';

  @override
  String get toolIpCamerasSub => 'Encuentra cámaras en tu LAN';

  @override
  String get toolIotDevices => 'Dispositivos IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly y más';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Suscribirse a un topic MQTT';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publicar en un topic MQTT';

  @override
  String get toolPortScan => 'Escaneo de puertos';

  @override
  String get toolPortScanSub => 'Puertos TCP/UDP abiertos en cualquier host';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping en vivo con gráfico';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Ruta salto a salto a cualquier host';

  @override
  String get toolWhois => 'Quién es…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS y búsqueda inversa';

  @override
  String get toolWifiChannels => 'Canales Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'Mapa de interferencias 2,4 y 5 GHz';

  @override
  String get toolCellularInfo => 'Info móvil';

  @override
  String get toolCellularInfoSub => 'Señal, ID de celda y datos de torre';

  @override
  String get about => 'Acerca de';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Eliminar';

  @override
  String get retry => 'Reintentar';
}
