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
}
