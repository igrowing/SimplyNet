// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get settingsTitle => '설정';

  @override
  String get appearance => '화면';

  @override
  String get language => '언어';

  @override
  String get theme => '테마';

  @override
  String get themeLight => '밝게';

  @override
  String get themeDark => '어둡게';

  @override
  String get themeAuto => '자동';

  @override
  String get screenOnTimeout => '화면 켜짐 시간';

  @override
  String get timeoutSystem => '시스템';

  @override
  String get timeoutTriple => '3× 시스템';

  @override
  String get timeoutStayOn => '항상 켜짐';

  @override
  String get scanning => '스캔';

  @override
  String get showMacAddress => 'MAC 주소 표시';

  @override
  String get showMacBlocked => 'Google 개인정보 보호 정책으로 인해 Android v.11 이상에서 비활성화됨';

  @override
  String get showMacSubtitle => '스캔 결과에 MAC 열 표시';

  @override
  String get resolveHostnames => '호스트 이름 확인';

  @override
  String get resolveHostnamesSubtitle => '스캔 중 역방향 DNS + mDNS 수행';

  @override
  String get enableLogging => '로깅 사용';

  @override
  String get enableLoggingSubtitle => '스캔 및 도구 출력을 로그 파일에 저장';

  @override
  String get account => '계정';

  @override
  String get logIn => '로그인';

  @override
  String get comingSoon => '곧 제공 예정';

  @override
  String get settings => '설정';

  @override
  String get aboutSimplyNet => 'SimplyNet 정보';

  @override
  String get scan => '스캔';

  @override
  String get logs => '로그';

  @override
  String get networkTools => '네트워크 도구';

  @override
  String get networkTarget => '네트워크 대상';

  @override
  String get networkTargetHint => '예: 192.168.1.0/24';

  @override
  String get invalidCidr => '잘못된 CIDR — 192.168.1.0/24 형식을 사용하세요';

  @override
  String get detectMyNetwork => '내 네트워크 감지';

  @override
  String get toolSpeedTest => '속도 테스트';

  @override
  String get toolSpeedTestSub => '다운로드 및 업로드 속도';

  @override
  String get toolPublicIp => '공용 IP';

  @override
  String get toolPublicIpSub => '내 IP, ISP 및 위치';

  @override
  String get toolIpCameras => 'IP 카메라';

  @override
  String get toolIpCamerasSub => 'LAN에서 카메라 찾기';

  @override
  String get toolIotDevices => 'IoT 기기';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly 등';

  @override
  String get toolMqttSub => 'MQTT 구독';

  @override
  String get toolMqttSubSub => 'MQTT 토픽 구독';

  @override
  String get toolMqttPub => 'MQTT 발행';

  @override
  String get toolMqttPubSub => 'MQTT 토픽에 발행';

  @override
  String get toolPortScan => '포트 스캔';

  @override
  String get toolPortScanSub => '모든 호스트의 열린 TCP/UDP 포트';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => '그래프가 있는 실시간 Ping';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => '모든 호스트로의 홉별 경로';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS 및 역방향 조회';

  @override
  String get toolWifiChannels => 'Wi-Fi 채널';

  @override
  String get toolWifiChannelsSub => '2.4 및 5 GHz 간섭 지도';

  @override
  String get toolCellularInfo => '셀룰러 정보';

  @override
  String get toolCellularInfoSub => '신호, 셀 ID 및 기지국 데이터';

  @override
  String get about => '정보';

  @override
  String get close => '닫기';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get delete => '삭제';

  @override
  String get retry => '다시 시도';

  @override
  String get stop => '중지';

  @override
  String get clear => '지우기';

  @override
  String get copy => '복사';

  @override
  String get copied => '복사됨';

  @override
  String get copyIp => 'IP 복사';

  @override
  String get hostHint => 'IP 주소 또는 호스트 이름';

  @override
  String get domainHostHint => '도메인, IP 주소 또는 호스트 이름';

  @override
  String get go => '실행';

  @override
  String get trace => '추적';

  @override
  String get lookUp => '조회';

  @override
  String get lookingUp => '조회 중…';

  @override
  String get enterHostGo => '호스트를 입력하고 실행을 누르세요';

  @override
  String get enterHostTrace => '호스트를 입력하고 추적을 누르세요';

  @override
  String get enterHostScan => '호스트를 입력하고 스캔을 누르세요';

  @override
  String get enterDomainIp => '도메인, IP 또는 호스트 이름 입력';

  @override
  String get aboutPing => 'Ping 정보';

  @override
  String get aboutTraceroute => 'Traceroute 정보';

  @override
  String get aboutWhois => 'Who Is 정보';

  @override
  String get aboutPortScan => '포트 스캔 정보';

  @override
  String get hiddenNode => '숨겨진 노드';

  @override
  String get destination => '목적지';

  @override
  String get yourRouter => '내 라우터';

  @override
  String get networkHop => '네트워크 홉';

  @override
  String get hop => '홉';

  @override
  String get noReply => '응답 없음';

  @override
  String get probingNextHop => '다음 홉 조사 중…';

  @override
  String get hiddenNodeInfo =>
      '이 라우터는 프로브에 응답하지 않았습니다. 많은 ISP, 방화벽 및 보안 장비가 ICMP(ping) 트래픽을 의도적으로 폐기하거나 제한하므로, 데이터가 여전히 이 홉을 통과하더라도 익명으로 유지됩니다.\n\n이는 정상이며 경로가 끊어졌다는 뜻이 아닙니다.';

  @override
  String get portsLabel => '포트:';

  @override
  String get wellKnown => '잘 알려진';

  @override
  String get rangeLabel => '범위';

  @override
  String get fromLabel => '시작:';

  @override
  String get toLabel => '끝:';

  @override
  String get protocolLabel => '프로토콜:';

  @override
  String get hideSettings => '설정 숨기기';

  @override
  String get myPublicIp => '내 공용 IP';

  @override
  String get errorLabel => '오류';

  @override
  String get infoUnavailable => '정보를 사용할 수 없습니다.';

  @override
  String get startTest => '테스트 시작';

  @override
  String get download => '다운로드';

  @override
  String get upload => '업로드';

  @override
  String get statusReady => '준비됨';

  @override
  String get statusDone => '완료';

  @override
  String get measuringPing => 'ping 측정 중…';

  @override
  String get findingServer => '서버 찾는 중…';

  @override
  String get testingDownload => '다운로드 테스트 중…';

  @override
  String get testingUpload => '업로드 테스트 중…';

  @override
  String get viaCloudflare => 'Cloudflare 사용';

  @override
  String get viaOokla => 'Ookla 사용';

  @override
  String get aboutSpeedTestTip => '속도 테스트 정보';

  @override
  String get speedTestInfo => '속도 테스트 정보';

  @override
  String get previousMeasurements => '이전 측정';

  @override
  String get noMeasurements => '아직 측정이 없습니다.';

  @override
  String get dateTime => '날짜 / 시간';

  @override
  String get switchToOokla => 'Ookla로 전환?';

  @override
  String get ooklaConsentBody =>
      'Ookla로 전환하려면 타사 서버에 연결해야 합니다. Ookla는 사용자의 IP 주소, 기기 식별자 및 위치 데이터를 수집하고 공유합니다.';

  @override
  String get decline => '거부';

  @override
  String get accept => '동의';

  @override
  String get clearHistoryTitle => '기록을 지울까요?';

  @override
  String get clearHistoryBody => '모든 측정 기록이 영구적으로 삭제됩니다.';

  @override
  String get aboutThisScan => '이 스캔 정보';

  @override
  String get scanInfoBody =>
      'ICMP(ping)를 차단하는 기기는 여기에 표시되지 않습니다. \'IoT 기기\' 또는 \'IP 카메라\' 스캔을 실행하여 열린 포트와 서비스를 통해 찾으세요.\n\nAndroid 11 이상 기기에서는 Google의 개인정보 보호 제한으로 인해 MAC 주소를 가져올 수 없어 표시되지 않습니다.';

  @override
  String get stopScan => '스캔 중지';

  @override
  String get reScan => '다시 스캔';

  @override
  String get hostsFound => '개 호스트 발견';

  @override
  String get hostname => '호스트 이름';

  @override
  String get noSavedResults => '저장된 결과 없음';

  @override
  String get noNetworkTarget => '네트워크 대상이 설정되지 않음';

  @override
  String get tapRefreshToScan => '새로 고침 버튼을 눌러 스캔하세요';

  @override
  String get setTargetHome => '홈 화면에서 대상을 설정하세요';

  @override
  String get openInBrowser => '브라우저에서 열기 (HTTP)';

  @override
  String get openSsh => 'SSH 열기';

  @override
  String get couldNotOpenBrowser => '브라우저를 열 수 없습니다';

  @override
  String get noSshApp => 'SSH 앱을 찾을 수 없습니다. ConnectBot 또는 Termius를 설치하세요.';

  @override
  String get deviceInfo => '기기 정보';

  @override
  String get ipAddress => 'IP 주소';

  @override
  String get macAddress => 'MAC 주소';

  @override
  String get manufacturer => '제조사';

  @override
  String get deviceTypeLabel => '기기 유형';

  @override
  String get openPorts => '열린 포트';

  @override
  String get stopPortScan => '포트 스캔 중지';

  @override
  String get portScanSettings => '포트 스캔 설정';

  @override
  String get reScanPorts => '포트 다시 스캔';

  @override
  String get noOpenPorts => '열린 포트를 찾을 수 없습니다.';

  @override
  String get applyRescan => '적용 및 다시 스캔';

  @override
  String get diagnostics => '진단';

  @override
  String get times => '회';

  @override
  String get deleteAllLogs => '모든 로그 삭제';

  @override
  String get deleteAllLogsQ => '모든 로그를 삭제할까요?';

  @override
  String get cannotBeUndone => '이 작업은 취소할 수 없습니다.';

  @override
  String get deleteAll => '모두 삭제';

  @override
  String get deleteLogQ => '로그를 삭제할까요?';

  @override
  String get noLogsYet => '아직 로그가 없습니다';

  @override
  String get scanningEllipsis => '스캔 중…';

  @override
  String get iotDevicesFound => '개 IoT 기기 발견';

  @override
  String get iotNoSaved => '저장된 결과 없음.\n새로 고침을 눌러 스캔하세요.';

  @override
  String get unknown => '알 수 없음';

  @override
  String get viaLabel => '경유';

  @override
  String get confDefinite => '확실';

  @override
  String get confProbable => '가능성 높음';

  @override
  String get confPossible => '가능';

  @override
  String get ipCameraScan => 'IP 카메라 스캔';

  @override
  String get camMethodProtocolPort => '프로토콜 포트';

  @override
  String get camMethodKnownVendor => '알려진 제조사';

  @override
  String get camMethodHttpFingerprint => 'HTTP 지문';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return '스캔 중… $done/$total 호스트 — 카메라 $n대';
  }

  @override
  String camNoSaved(Object cidr) {
    return '저장된 결과 없음 — 새로 고침을 눌러 $cidr 스캔';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '카메라 $n대 발견 — $cidr';
  }

  @override
  String get noCamerasFound => '카메라를 찾을 수 없습니다.';

  @override
  String get mqttSettingsTitle => 'MQTT 설정';

  @override
  String get brokerIpFqdn => '브로커 IP / FQDN';

  @override
  String get searchingSubnet => '서브넷 검색 중…';

  @override
  String get brokerHint => '예: 192.168.1.10 또는 broker.example.com';

  @override
  String get portLabel => '포트';

  @override
  String get usernameOptional => '사용자 이름 (선택)';

  @override
  String get leaveEmptyOptional => '필요하지 않으면 비워 두세요';

  @override
  String get passwordOptional => '비밀번호 (선택)';

  @override
  String get keepPassword => '비밀번호 저장 (권장하지 않음)';

  @override
  String get keepPasswordSub => '비밀번호는 앱 저장소에 평문으로 저장됩니다.';

  @override
  String get save => '저장';

  @override
  String get screenStaysOn => '화면 켜짐 유지';

  @override
  String get screenMaySleep => '화면이 꺼질 수 있음';

  @override
  String get mqttSubscribe => 'MQTT 구독';

  @override
  String get mqttPublish => 'MQTT 게시';

  @override
  String get topicLabel => '토픽';

  @override
  String get topicSubHint => '예: home/sensor/# 또는 home/sensor/temp';

  @override
  String get listen => '수신';

  @override
  String get humanReadableJson => '읽기 쉬운 JSON';

  @override
  String get waitingForMessages => '메시지 대기 중…';

  @override
  String get enterTopicListen => '토픽을 입력하고 수신을 누르세요';

  @override
  String get tapListenReceive => '수신을 눌러 수신을 시작하세요';

  @override
  String get enterTopicTapListen => '토픽을 입력하고 수신을 누르세요';

  @override
  String get enterTopicFirst => '먼저 토픽을 입력하세요.';

  @override
  String get stoppedStatus => '중지됨.';

  @override
  String get connectingStatus => '연결 중…';

  @override
  String get reconnectingStatus => '재연결 중…';

  @override
  String listeningOn(Object topic) {
    return '\"$topic\" 수신 중';
  }

  @override
  String connFailed(Object e) {
    return '연결 실패: $e';
  }

  @override
  String get topicPubHint => '예: home/light/switch';

  @override
  String get messageLabel => '메시지';

  @override
  String get enterPayload => '페이로드 입력…';

  @override
  String get retain => '유지';

  @override
  String get retainSub => '브로커가 새 구독자를 위해 마지막 메시지를 유지합니다.';

  @override
  String get publish => '게시';

  @override
  String get connectedEnterTopic => '연결됨 — 아래에 토픽을 입력하세요';

  @override
  String connectedTopic(Object topic) {
    return '연결됨 — 토픽: \"$topic\"';
  }

  @override
  String get disconnectedStatus => '연결 끊김';

  @override
  String publishedTo(Object topic) {
    return '\"$topic\"에 게시됨';
  }

  @override
  String get about5GhzChannels => '5 GHz 채널 정보';

  @override
  String get wifiBandInfoTitle => '5 GHz 네트워크의 이중 액세스 포인트 감지';

  @override
  String get wifiBandInfoBody =>
      '💡 SSID를 길게 누르면 액세스 포인트의 전체 이름을 볼 수 있습니다.\n\nℹ️ 5 GHz 대역에서는 보통 각 액세스 포인트가 두 개(또는 그 이상)의 채널에 동시에 나타납니다. 이는 정상입니다.\n\n더 빠르게 하기 위해 최신 라우터는 인접한 20 MHz 채널을 하나의 더 넓은 차선 — 40, 80, 심지어 160 MHz — 으로 붙입니다. 이를 \"채널 본딩\"이라고 합니다. 더 넓은 도로가 더 많은 차를 수용하듯, 더 넓은 차선은 더 많은 데이터를 전달합니다.\n\n\"동적 채널 폭\"을 사용하면 라우터는 가능한 가장 넓은 차선을 선택하고 전파가 혼잡하거나 잡음이 많아지면 자동으로 좁혀서, 이웃을 방해하지 않으면서 빠른 속도를 유지합니다.\n\n따라서 예를 들어 채널 36과 40에 표시되는 하나의 5 GHz 네트워크는 40 MHz 폭의 결합 채널을 사용하는 하나의 액세스 포인트일 뿐이며, 두 개의 별도 네트워크가 아닙니다.';

  @override
  String get noResults => '결과 없음.';

  @override
  String get scanErrorPrefix => '스캔 오류';

  @override
  String noBandNetworks(Object band) {
    return '$band 네트워크가 감지되지 않았습니다.';
  }

  @override
  String get securityLabel => '보안';

  @override
  String get qualityLabel => '품질';

  @override
  String get qExcellent => '매우 좋음';

  @override
  String get qGood => '좋음';

  @override
  String get qFair => '보통';

  @override
  String get qWeak => '약함';

  @override
  String get qPoor => '나쁨';

  @override
  String get refresh => '새로 고침';

  @override
  String get cellShowingDemo => '데모 데이터를 표시하고 있습니다.';

  @override
  String get noDataReturned => '기기에서 데이터를 반환하지 않았습니다.';

  @override
  String get platformErrorPrefix => '플랫폼 오류';

  @override
  String get carrier => '통신사';

  @override
  String get provider => '제공업체';

  @override
  String get technology => '기술';

  @override
  String get roaming => '로밍';

  @override
  String get dataState => '데이터 상태';

  @override
  String get signalQuality => '신호 품질';

  @override
  String get cellTower => '기지국';

  @override
  String get cellId => '셀 ID';

  @override
  String get bandLabel => '밴드';

  @override
  String get estDistance => '예상 거리';

  @override
  String get location => '위치';

  @override
  String get coordinates => '좌표';

  @override
  String get locating => '위치 확인 중…';

  @override
  String get nearestPlace => '가장 가까운 장소';

  @override
  String get deniedByUser => '사용자가 거부함';

  @override
  String get unavailablePrefix => '사용 불가';

  @override
  String get signalStrength => '신호 강도';

  @override
  String get rsrpHint =>
      'RSRP — 기준 신호 수신 전력.\n\ndBm으로 측정되는 셀 기준 신호의 평균 전력입니다. 순수 신호 강도를 나타냅니다.\n\n일반적인 범위: 약 −80 dBm(매우 좋음)에서 −120 dBm(매우 약함)까지. 높을수록(0에 가까울수록) 좋습니다.';

  @override
  String get rsrqHint =>
      'RSRQ — 기준 신호 수신 품질.\n\n강도 외에 간섭과 네트워크 부하도 고려한 dB 단위의 신호 품질입니다.\n\n일반적인 범위: 약 −3 dB(매우 좋음)에서 −20 dB(나쁨)까지. 높을수록 좋습니다.';

  @override
  String get sinrHint =>
      'SINR — 신호 대 간섭 및 잡음 비.\n\n원하는 신호가 간섭과 배경 잡음을 얼마나 초과하는지를 dB로 나타냅니다.\n\n높을수록 좋습니다: 약 20 dB 이상이면 매우 좋고, 0 dB 부근이나 그 이하는 나쁩니다.';

  @override
  String get pciHint =>
      'PCI — 물리적 셀 ID.\n\n무선 인터페이스에서 서비스 셀을 식별하는 번호(LTE에서 0–503)입니다. 인접 셀은 서로 다른 PCI를 사용하여 휴대폰이 구분할 수 있습니다.';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA 절대 무선 주파수 채널 번호.\n\n기기가 사용 중인 정확한 반송 주파수를 식별합니다. 특정 LTE 밴드 및 채널에 매핑됩니다.';

  @override
  String get estDistHint =>
      '기지국까지의 예상 거리.\n\n전파 전파 모델을 사용해 신호 강도(RSRP)에서 산출됩니다. 이는 매우 대략적인 자릿수 수준의 참고일 뿐이며 — 정밀한 측정값이 아닙니다.';
}
