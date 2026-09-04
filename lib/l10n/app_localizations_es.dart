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

  @override
  String get stop => 'Detener';

  @override
  String get clear => 'Borrar';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Copiado';

  @override
  String get copyIp => 'Copiar IP';

  @override
  String get hostHint => 'Dirección IP o nombre de host';

  @override
  String get domainHostHint => 'Dominio, dirección IP o nombre de host';

  @override
  String get go => 'Ir';

  @override
  String get trace => 'Trazar';

  @override
  String get lookUp => 'Buscar';

  @override
  String get lookingUp => 'Buscando…';

  @override
  String get enterHostGo => 'Introduce un host y pulsa Ir';

  @override
  String get enterHostTrace => 'Introduce un host y pulsa Trazar';

  @override
  String get enterHostScan => 'Introduce un host y toca Escanear';

  @override
  String get enterDomainIp => 'Introduce un dominio, IP o nombre de host';

  @override
  String get aboutPing => 'Acerca de Ping';

  @override
  String get aboutTraceroute => 'Acerca de Traceroute';

  @override
  String get aboutWhois => 'Acerca de Who Is';

  @override
  String get aboutPortScan => 'Acerca de Port Scan';

  @override
  String get hiddenNode => 'Nodo oculto';

  @override
  String get destination => 'Destino';

  @override
  String get yourRouter => 'Tu router';

  @override
  String get networkHop => 'Salto de red';

  @override
  String get hop => 'Salto';

  @override
  String get noReply => 'sin respuesta';

  @override
  String get probingNextHop => 'Sondeando siguiente salto…';

  @override
  String get hiddenNodeInfo =>
      'Este router no respondió a nuestros sondeos. Muchos ISP, firewalls y dispositivos de seguridad descartan o limitan deliberadamente el tráfico ICMP (ping), por lo que el salto permanece anónimo aunque tus datos sigan pasando por él.\n\nEs normal y no significa que la ruta esté rota.';

  @override
  String get portsLabel => 'Puertos:';

  @override
  String get wellKnown => 'Conocidos';

  @override
  String get rangeLabel => 'Rango';

  @override
  String get fromLabel => 'Desde:';

  @override
  String get toLabel => 'Hasta:';

  @override
  String get protocolLabel => 'Protocolo:';

  @override
  String get hideSettings => 'Ocultar ajustes';

  @override
  String get myPublicIp => 'Mi IP pública';

  @override
  String get errorLabel => 'Error';

  @override
  String get infoUnavailable => 'Información no disponible.';

  @override
  String get startTest => 'Iniciar prueba';

  @override
  String get download => 'Descarga';

  @override
  String get upload => 'Subida';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusDone => 'Hecho';

  @override
  String get measuringPing => 'Midiendo ping…';

  @override
  String get findingServer => 'Buscando servidor…';

  @override
  String get testingDownload => 'Probando descarga…';

  @override
  String get testingUpload => 'Probando subida…';

  @override
  String get viaCloudflare => 'Vía Cloudflare';

  @override
  String get viaOokla => 'Vía Ookla';

  @override
  String get aboutSpeedTestTip => 'Acerca de la prueba de velocidad';

  @override
  String get speedTestInfo => 'Info prueba de velocidad';

  @override
  String get previousMeasurements => 'Mediciones anteriores';

  @override
  String get noMeasurements => 'Aún no hay mediciones.';

  @override
  String get dateTime => 'Fecha / Hora';

  @override
  String get switchToOokla => '¿Cambiar a Ookla?';

  @override
  String get ooklaConsentBody =>
      'Cambiar a Ookla requiere conectarse a servidores de terceros. Ookla recopila y comparte tu dirección IP, los identificadores del dispositivo y los datos de ubicación.';

  @override
  String get decline => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get clearHistoryTitle => '¿Borrar historial?';

  @override
  String get clearHistoryBody =>
      'Esto eliminará permanentemente todos los registros de medición.';

  @override
  String get aboutThisScan => 'Acerca de este escaneo';

  @override
  String get scanInfoBody =>
      'Los dispositivos que bloquean ICMP (pings) no aparecerán aquí. Ejecuta el escaneo \'Dispositivos IoT\' o \'Cámaras IP\' para localizarlos mediante sus puertos y servicios abiertos.\n\nEn dispositivos Android 11+, las direcciones MAC no se pueden obtener debido a las restricciones de privacidad de Google, por lo que no se muestran.';

  @override
  String get stopScan => 'Detener escaneo';

  @override
  String get reScan => 'Reescanear';

  @override
  String get hostsFound => 'host encontrados';

  @override
  String get hostname => 'Nombre de host';

  @override
  String get noSavedResults => 'Sin resultados guardados';

  @override
  String get noNetworkTarget => 'Sin objetivo de red definido';

  @override
  String get tapRefreshToScan => 'Toca el botón de actualizar para escanear';

  @override
  String get setTargetHome => 'Define un objetivo en la pantalla de inicio';

  @override
  String get openInBrowser => 'Abrir en el navegador (HTTP)';

  @override
  String get openSsh => 'Abrir SSH';

  @override
  String get couldNotOpenBrowser => 'No se pudo abrir el navegador';

  @override
  String get noSshApp =>
      'No se encontró ninguna app SSH. Instala ConnectBot o Termius.';

  @override
  String get deviceInfo => 'Info del dispositivo';

  @override
  String get ipAddress => 'Dirección IP';

  @override
  String get macAddress => 'Dirección MAC';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get deviceTypeLabel => 'Tipo de dispositivo';

  @override
  String get openPorts => 'Puertos abiertos';

  @override
  String get stopPortScan => 'Detener escaneo de puertos';

  @override
  String get portScanSettings => 'Ajustes de escaneo de puertos';

  @override
  String get reScanPorts => 'Reescanear puertos';

  @override
  String get noOpenPorts => 'No se encontraron puertos abiertos.';

  @override
  String get applyRescan => 'Aplicar y reescanear';

  @override
  String get diagnostics => 'Diagnóstico';

  @override
  String get times => 'veces';

  @override
  String get deleteAllLogs => 'Eliminar todos los registros';

  @override
  String get deleteAllLogsQ => '¿Eliminar todos los registros?';

  @override
  String get cannotBeUndone => 'Esto no se puede deshacer.';

  @override
  String get deleteAll => 'Eliminar todos';

  @override
  String get deleteLogQ => '¿Eliminar registro?';

  @override
  String get noLogsYet => 'Aún no hay registros';

  @override
  String get scanningEllipsis => 'Escaneando…';

  @override
  String get iotDevicesFound => 'dispositivos IoT encontrados';

  @override
  String get iotNoSaved =>
      'Sin resultados guardados.\nToca actualizar para escanear.';

  @override
  String get unknown => 'Desconocido';

  @override
  String get viaLabel => 'vía';

  @override
  String get confDefinite => 'seguro';

  @override
  String get confProbable => 'probable';

  @override
  String get confPossible => 'posible';

  @override
  String get ipCameraScan => 'Escaneo de cámaras IP';

  @override
  String get camMethodProtocolPort => 'Puerto de protocolo';

  @override
  String get camMethodKnownVendor => 'Fabricante conocido';

  @override
  String get camMethodHttpFingerprint => 'Huella HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Escaneando… $done/$total hosts — $n cámara(s)';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Sin resultados guardados — toca actualizar para escanear $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n cámara(s) encontradas — $cidr';
  }

  @override
  String get noCamerasFound => 'No se encontraron cámaras.';

  @override
  String get mqttSettingsTitle => 'Ajustes MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN del broker';

  @override
  String get searchingSubnet => 'Buscando en la subred…';

  @override
  String get brokerHint => 'p. ej. 192.168.1.10 o broker.example.com';

  @override
  String get portLabel => 'Puerto';

  @override
  String get usernameOptional => 'Usuario (opcional)';

  @override
  String get leaveEmptyOptional => 'déjalo vacío si no es necesario';

  @override
  String get passwordOptional => 'Contraseña (opcional)';

  @override
  String get keepPassword => 'Guardar contraseña (no recomendado)';

  @override
  String get keepPasswordSub =>
      'La contraseña se guarda en texto plano en el almacenamiento de la app.';

  @override
  String get save => 'Guardar';

  @override
  String get screenStaysOn => 'La pantalla permanece encendida';

  @override
  String get screenMaySleep => 'La pantalla puede apagarse';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Tema';

  @override
  String get topicSubHint => 'p. ej. home/sensor/# o home/sensor/temp';

  @override
  String get listen => 'Escuchar';

  @override
  String get humanReadableJson => 'JSON legible';

  @override
  String get waitingForMessages => 'Esperando mensajes…';

  @override
  String get enterTopicListen => 'Introduce un tema y toca Escuchar';

  @override
  String get tapListenReceive => 'Toca Escuchar para empezar a recibir';

  @override
  String get enterTopicTapListen => 'Introduce el tema y toca Escuchar';

  @override
  String get enterTopicFirst => 'Primero introduce un tema.';

  @override
  String get stoppedStatus => 'Detenido.';

  @override
  String get connectingStatus => 'Conectando…';

  @override
  String get reconnectingStatus => 'Reconectando…';

  @override
  String listeningOn(Object topic) {
    return 'Escuchando en \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Conexión fallida: $e';
  }

  @override
  String get topicPubHint => 'p. ej. home/light/switch';

  @override
  String get messageLabel => 'Mensaje';

  @override
  String get enterPayload => 'Introduce el contenido…';

  @override
  String get retain => 'Retener';

  @override
  String get retainSub =>
      'El broker guarda el último mensaje para nuevos suscriptores.';

  @override
  String get publish => 'Publicar';

  @override
  String get connectedEnterTopic => 'Conectado — introduce un tema abajo';

  @override
  String connectedTopic(Object topic) {
    return 'Conectado — tema: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Desconectado';

  @override
  String publishedTo(Object topic) {
    return 'Publicado en \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'Acerca de los canales de 5 GHz';

  @override
  String get wifiBandInfoTitle =>
      'Detección de doble punto de acceso en la red de 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 Mantén pulsado el SSID para ver el nombre completo del punto de acceso.\n\nℹ️ En la banda de 5 GHz normalmente verás cada punto de acceso en dos (o más) canales a la vez. Es normal.\n\nPara ir más rápido, los routers modernos unen canales vecinos de 20 MHz en un carril más ancho — 40, 80 o incluso 160 MHz. Esto se llama \"channel bonding\". Un carril más ancho transporta más datos, igual que una carretera más ancha transporta más coches.\n\nCon el \"ancho de canal dinámico\" el router elige el carril más ancho posible y lo estrecha automáticamente cuando el aire está ocupado o con ruido, para seguir siendo rápido sin molestar a los vecinos.\n\nAsí que una sola red de 5 GHz que aparece en los canales 36 y 40, por ejemplo, es solo un punto de acceso usando un canal unido de 40 MHz — no dos redes separadas.';

  @override
  String get noResults => 'Sin resultados.';

  @override
  String get scanErrorPrefix => 'Error de escaneo';

  @override
  String noBandNetworks(Object band) {
    return 'No se detectaron redes de $band.';
  }

  @override
  String get securityLabel => 'Seguridad';

  @override
  String get qualityLabel => 'Calidad';

  @override
  String get qExcellent => 'Excelente';

  @override
  String get qGood => 'Bueno';

  @override
  String get qFair => 'Regular';

  @override
  String get qWeak => 'Débil';

  @override
  String get qPoor => 'Malo';

  @override
  String get refresh => 'Actualizar';

  @override
  String get cellShowingDemo => 'Mostrando datos de demostración.';

  @override
  String get noDataReturned => 'El dispositivo no devolvió datos.';

  @override
  String get platformErrorPrefix => 'Error de plataforma';

  @override
  String get carrier => 'Operador';

  @override
  String get provider => 'Proveedor';

  @override
  String get technology => 'Tecnología';

  @override
  String get roaming => 'Itinerancia';

  @override
  String get dataState => 'Estado de datos';

  @override
  String get signalQuality => 'Calidad de señal';

  @override
  String get cellTower => 'Torre de telefonía';

  @override
  String get cellId => 'ID de celda';

  @override
  String get bandLabel => 'Banda';

  @override
  String get estDistance => 'Distancia est.';

  @override
  String get location => 'Ubicación';

  @override
  String get coordinates => 'Coordenadas';

  @override
  String get locating => 'Localizando…';

  @override
  String get nearestPlace => 'Lugar más cercano';

  @override
  String get deniedByUser => 'Denegado por el usuario';

  @override
  String get unavailablePrefix => 'No disponible';

  @override
  String get signalStrength => 'Intensidad de señal';

  @override
  String get rsrpHint =>
      'RSRP — Potencia recibida de la señal de referencia.\n\nLa potencia media de las señales de referencia de la celda, medida en dBm. Refleja la intensidad bruta de la señal.\n\nRango típico: de unos −80 dBm (excelente) hasta −120 dBm (muy débil). Más alto (cercano a cero) es mejor.';

  @override
  String get rsrqHint =>
      'RSRQ — Calidad recibida de la señal de referencia.\n\nCalidad de señal en dB, teniendo en cuenta interferencias y carga de red además de la intensidad.\n\nRango típico: de unos −3 dB (excelente) hasta −20 dB (malo). Más alto es mejor.';

  @override
  String get sinrHint =>
      'SINR — relación señal/interferencia más ruido.\n\nCuánto supera la señal deseada a la interferencia más el ruido de fondo, en dB.\n\nMás alto es mejor: por encima de ~20 dB es excelente, alrededor de 0 dB o menos es malo.';

  @override
  String get pciHint =>
      'PCI — Identificador físico de celda.\n\nUn número (0–503 en LTE) que identifica la celda que da servicio en la interfaz de radio. Las celdas vecinas usan PCI diferentes para que el teléfono pueda distinguirlas.';

  @override
  String get earfcnHint =>
      'EARFCN — número absoluto de canal de radiofrecuencia E-UTRA.\n\nIdentifica la frecuencia portadora exacta que usa el dispositivo; corresponde a una banda y canal LTE específicos.';

  @override
  String get estDistHint =>
      'Distancia estimada a la torre de telefonía.\n\nDerivada de la intensidad de señal (RSRP) usando un modelo de propagación de radio. Es solo una indicación muy aproximada, de orden de magnitud — no una medición precisa.';

  @override
  String get version => 'Versión';

  @override
  String get sendFeedback => 'Enviar comentarios / idea de mejora';

  @override
  String get buyMeCoffee => 'Invítame a un café';

  @override
  String get shareAction => 'Compartir';
}
