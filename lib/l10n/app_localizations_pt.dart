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

  @override
  String get stop => 'Parar';

  @override
  String get clear => 'Limpar';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Copiado';

  @override
  String get copyIp => 'Copiar IP';

  @override
  String get hostHint => 'Endereço IP ou nome de host';

  @override
  String get domainHostHint => 'Domínio, endereço IP ou nome de host';

  @override
  String get go => 'Ir';

  @override
  String get trace => 'Traçar';

  @override
  String get lookUp => 'Procurar';

  @override
  String get lookingUp => 'A procurar…';

  @override
  String get enterHostGo => 'Introduza um host e prima Ir';

  @override
  String get enterHostTrace => 'Introduza um host e prima Traçar';

  @override
  String get enterHostScan => 'Introduza um host e toque em Analisar';

  @override
  String get enterDomainIp => 'Introduza um domínio, IP ou nome de host';

  @override
  String get aboutPing => 'Sobre o Ping';

  @override
  String get aboutTraceroute => 'Sobre o Traceroute';

  @override
  String get aboutWhois => 'Sobre o Who Is';

  @override
  String get aboutPortScan => 'Sobre o Port Scan';

  @override
  String get hiddenNode => 'Nó oculto';

  @override
  String get destination => 'Destino';

  @override
  String get yourRouter => 'O teu router';

  @override
  String get networkHop => 'Salto de rede';

  @override
  String get hop => 'Salto';

  @override
  String get noReply => 'sem resposta';

  @override
  String get probingNextHop => 'A sondar próximo salto…';

  @override
  String get hiddenNodeInfo =>
      'Este router não respondeu às nossas sondagens. Muitos ISPs, firewalls e dispositivos de segurança descartam ou limitam deliberadamente o tráfego ICMP (ping), por isso o salto permanece anónimo mesmo que os teus dados continuem a passar por ele.\n\nIsto é normal e não significa que a rota esteja quebrada.';

  @override
  String get portsLabel => 'Portas:';

  @override
  String get wellKnown => 'Conhecidas';

  @override
  String get rangeLabel => 'Intervalo';

  @override
  String get fromLabel => 'De:';

  @override
  String get toLabel => 'Até:';

  @override
  String get protocolLabel => 'Protocolo:';

  @override
  String get hideSettings => 'Ocultar definições';

  @override
  String get myPublicIp => 'O meu IP público';

  @override
  String get errorLabel => 'Erro';

  @override
  String get infoUnavailable => 'Informação não disponível.';

  @override
  String get startTest => 'Iniciar teste';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusDone => 'Concluído';

  @override
  String get measuringPing => 'A medir ping…';

  @override
  String get findingServer => 'A procurar servidor…';

  @override
  String get testingDownload => 'A testar download…';

  @override
  String get testingUpload => 'A testar upload…';

  @override
  String get viaCloudflare => 'Via Cloudflare';

  @override
  String get viaOokla => 'Via Ookla';

  @override
  String get aboutSpeedTestTip => 'Sobre o teste de velocidade';

  @override
  String get speedTestInfo => 'Info teste de velocidade';

  @override
  String get previousMeasurements => 'Medições anteriores';

  @override
  String get noMeasurements => 'Ainda sem medições.';

  @override
  String get dateTime => 'Data / Hora';

  @override
  String get switchToOokla => 'Mudar para Ookla?';

  @override
  String get ooklaConsentBody =>
      'Mudar para Ookla exige ligar-se a servidores de terceiros. A Ookla recolhe e partilha o teu endereço IP, identificadores do dispositivo e dados de localização.';

  @override
  String get decline => 'Recusar';

  @override
  String get accept => 'Aceitar';

  @override
  String get clearHistoryTitle => 'Limpar histórico?';

  @override
  String get clearHistoryBody =>
      'Isto eliminará permanentemente todos os registos de medição.';

  @override
  String get aboutThisScan => 'Sobre esta análise';

  @override
  String get scanInfoBody =>
      'Os dispositivos que bloqueiam ICMP (pings) não aparecerão aqui. Execute a análise \'Dispositivos IoT\' ou \'Câmaras IP\' para os localizar através das suas portas e serviços abertos.\n\nEm dispositivos Android 11+, os endereços MAC não podem ser obtidos devido às restrições de privacidade da Google, pelo que não são apresentados.';

  @override
  String get stopScan => 'Parar análise';

  @override
  String get reScan => 'Analisar de novo';

  @override
  String get hostsFound => 'host encontrados';

  @override
  String get hostname => 'Nome de host';

  @override
  String get noSavedResults => 'Sem resultados guardados';

  @override
  String get noNetworkTarget => 'Nenhum alvo de rede definido';

  @override
  String get tapRefreshToScan => 'Toque no botão de atualizar para analisar';

  @override
  String get setTargetHome => 'Defina um alvo no ecrã inicial';

  @override
  String get openInBrowser => 'Abrir no navegador (HTTP)';

  @override
  String get openSsh => 'Abrir SSH';

  @override
  String get couldNotOpenBrowser => 'Não foi possível abrir o navegador';

  @override
  String get noSshApp =>
      'Nenhuma app SSH encontrada. Instale o ConnectBot ou o Termius.';

  @override
  String get deviceInfo => 'Info do dispositivo';

  @override
  String get ipAddress => 'Endereço IP';

  @override
  String get macAddress => 'Endereço MAC';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get deviceTypeLabel => 'Tipo de dispositivo';

  @override
  String get openPorts => 'Portas abertas';

  @override
  String get stopPortScan => 'Parar análise de portas';

  @override
  String get portScanSettings => 'Definições da análise de portas';

  @override
  String get reScanPorts => 'Analisar portas de novo';

  @override
  String get noOpenPorts => 'Nenhuma porta aberta encontrada.';

  @override
  String get applyRescan => 'Aplicar e reanalisar';

  @override
  String get diagnostics => 'Diagnóstico';

  @override
  String get times => 'vezes';

  @override
  String get deleteAllLogs => 'Eliminar todos os registos';

  @override
  String get deleteAllLogsQ => 'Eliminar todos os registos?';

  @override
  String get cannotBeUndone => 'Isto não pode ser desfeito.';

  @override
  String get deleteAll => 'Eliminar tudo';

  @override
  String get deleteLogQ => 'Eliminar registo?';

  @override
  String get noLogsYet => 'Ainda sem registos';

  @override
  String get scanningEllipsis => 'A analisar…';

  @override
  String get iotDevicesFound => 'dispositivos IoT encontrados';

  @override
  String get iotNoSaved =>
      'Sem resultados guardados.\nToque em atualizar para analisar.';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get viaLabel => 'via';

  @override
  String get confDefinite => 'definido';

  @override
  String get confProbable => 'provável';

  @override
  String get confPossible => 'possível';

  @override
  String get ipCameraScan => 'Análise de câmaras IP';

  @override
  String get camMethodProtocolPort => 'Porta de protocolo';

  @override
  String get camMethodKnownVendor => 'Fabricante conhecido';

  @override
  String get camMethodHttpFingerprint => 'Impressão HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'A analisar… $done/$total hosts — $n câmara(s)';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'Sem resultados guardados — toque em atualizar para analisar $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n câmara(s) encontradas — $cidr';
  }

  @override
  String get noCamerasFound => 'Nenhuma câmara encontrada.';

  @override
  String get mqttSettingsTitle => 'Definições MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN do broker';

  @override
  String get searchingSubnet => 'A procurar na sub-rede…';

  @override
  String get brokerHint => 'ex. 192.168.1.10 ou broker.example.com';

  @override
  String get portLabel => 'Porta';

  @override
  String get usernameOptional => 'Nome de utilizador (opcional)';

  @override
  String get leaveEmptyOptional => 'deixe vazio se não for necessário';

  @override
  String get passwordOptional => 'Palavra-passe (opcional)';

  @override
  String get keepPassword => 'Guardar palavra-passe (não recomendado)';

  @override
  String get keepPasswordSub =>
      'A palavra-passe é guardada em texto simples no armazenamento da app.';

  @override
  String get save => 'Guardar';

  @override
  String get screenStaysOn => 'Ecrã permanece ligado';

  @override
  String get screenMaySleep => 'O ecrã pode desligar-se';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Tópico';

  @override
  String get topicSubHint => 'ex. home/sensor/# ou home/sensor/temp';

  @override
  String get listen => 'Ouvir';

  @override
  String get humanReadableJson => 'JSON legível';

  @override
  String get waitingForMessages => 'À espera de mensagens…';

  @override
  String get enterTopicListen => 'Introduza um tópico e toque em Ouvir';

  @override
  String get tapListenReceive => 'Toque em Ouvir para começar a receber';

  @override
  String get enterTopicTapListen => 'Introduza o tópico e toque em Ouvir';

  @override
  String get enterTopicFirst => 'Introduza primeiro um tópico.';

  @override
  String get stoppedStatus => 'Parado.';

  @override
  String get connectingStatus => 'A ligar…';

  @override
  String get reconnectingStatus => 'A religar…';

  @override
  String listeningOn(Object topic) {
    return 'A ouvir em \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Ligação falhou: $e';
  }

  @override
  String get topicPubHint => 'ex. home/light/switch';

  @override
  String get messageLabel => 'Mensagem';

  @override
  String get enterPayload => 'Introduza o conteúdo…';

  @override
  String get retain => 'Reter';

  @override
  String get retainSub =>
      'O broker mantém a última mensagem para novos subscritores.';

  @override
  String get publish => 'Publicar';

  @override
  String get connectedEnterTopic => 'Ligado — introduza um tópico abaixo';

  @override
  String connectedTopic(Object topic) {
    return 'Ligado — tópico: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Desligado';

  @override
  String publishedTo(Object topic) {
    return 'Publicado em \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'Sobre os canais de 5 GHz';

  @override
  String get wifiBandInfoTitle =>
      'Deteção de duplo ponto de acesso na rede 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 Mantenha o SSID premido para ver o nome completo do ponto de acesso.\n\nℹ️ Na banda 5 GHz verá normalmente cada ponto de acesso em dois (ou mais) canais ao mesmo tempo. Isso é normal.\n\nPara irem mais rápido, os routers modernos juntam canais vizinhos de 20 MHz numa faixa mais larga — 40, 80 ou até 160 MHz. Isto chama-se \"channel bonding\". Uma faixa mais larga transporta mais dados, tal como uma estrada mais larga transporta mais carros.\n\nCom a \"largura de canal dinâmica\" o router escolhe a faixa mais larga possível e estreita-a automaticamente quando o ar fica ocupado ou com ruído, mantendo-se rápido sem incomodar os vizinhos.\n\nPortanto, uma única rede 5 GHz que aparece nos canais 36 e 40, por exemplo, é apenas um ponto de acesso a usar um canal unido de 40 MHz — não duas redes separadas.';

  @override
  String get noResults => 'Sem resultados.';

  @override
  String get scanErrorPrefix => 'Erro de análise';

  @override
  String noBandNetworks(Object band) {
    return 'Nenhuma rede $band detetada.';
  }

  @override
  String get securityLabel => 'Segurança';

  @override
  String get qualityLabel => 'Qualidade';

  @override
  String get qExcellent => 'Excelente';

  @override
  String get qGood => 'Bom';

  @override
  String get qFair => 'Razoável';

  @override
  String get qWeak => 'Fraco';

  @override
  String get qPoor => 'Mau';

  @override
  String get refresh => 'Atualizar';

  @override
  String get cellShowingDemo => 'A mostrar dados de demonstração.';

  @override
  String get noDataReturned => 'O dispositivo não devolveu dados.';

  @override
  String get platformErrorPrefix => 'Erro de plataforma';

  @override
  String get carrier => 'Operadora';

  @override
  String get provider => 'Fornecedor';

  @override
  String get technology => 'Tecnologia';

  @override
  String get roaming => 'Roaming';

  @override
  String get dataState => 'Estado dos dados';

  @override
  String get signalQuality => 'Qualidade do sinal';

  @override
  String get cellTower => 'Torre de celular';

  @override
  String get cellId => 'ID da célula';

  @override
  String get bandLabel => 'Banda';

  @override
  String get estDistance => 'Distância est.';

  @override
  String get location => 'Localização';

  @override
  String get coordinates => 'Coordenadas';

  @override
  String get locating => 'A localizar…';

  @override
  String get nearestPlace => 'Local mais próximo';

  @override
  String get deniedByUser => 'Negado pelo utilizador';

  @override
  String get unavailablePrefix => 'Indisponível';

  @override
  String get signalStrength => 'Força do sinal';

  @override
  String get rsrpHint =>
      'RSRP — Potência recebida do sinal de referência.\n\nA potência média dos sinais de referência da célula, medida em dBm. Reflete a intensidade bruta do sinal.\n\nIntervalo típico: cerca de −80 dBm (excelente) até −120 dBm (muito fraco). Mais alto (próximo de zero) é melhor.';

  @override
  String get rsrqHint =>
      'RSRQ — Qualidade recebida do sinal de referência.\n\nQualidade do sinal em dB, tendo em conta interferências e carga da rede além da intensidade.\n\nIntervalo típico: cerca de −3 dB (excelente) até −20 dB (mau). Mais alto é melhor.';

  @override
  String get sinrHint =>
      'SINR — relação sinal/interferência mais ruído.\n\nQuanto o sinal desejado excede a interferência mais o ruído de fundo, em dB.\n\nMais alto é melhor: acima de ~20 dB é excelente, cerca de 0 dB ou abaixo é mau.';

  @override
  String get pciHint =>
      'PCI — Identificador físico da célula.\n\nUm número (0–503 em LTE) que identifica a célula de serviço na interface de rádio. As células vizinhas usam PCIs diferentes para que o telefone as possa distinguir.';

  @override
  String get earfcnHint =>
      'EARFCN — número absoluto de canal de radiofrequência E-UTRA.\n\nIdentifica a frequência portadora exata que o dispositivo usa; corresponde a uma banda e canal LTE específicos.';

  @override
  String get estDistHint =>
      'Distância estimada até à torre de celular.\n\nDerivada da força do sinal (RSRP) usando um modelo de propagação de rádio. É apenas uma indicação muito aproximada, da ordem de grandeza — não uma medição precisa.';

  @override
  String get version => 'Versão';

  @override
  String get sendFeedback => 'Enviar feedback / ideia de melhoria';

  @override
  String get buyMeCoffee => 'Paga-me um café';

  @override
  String get shareAction => 'Partilhar';
}
