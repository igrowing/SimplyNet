// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settingsTitle => '設定';

  @override
  String get appearance => '外観';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeAuto => '自動';

  @override
  String get screenOnTimeout => '画面点灯タイムアウト';

  @override
  String get timeoutSystem => 'システム';

  @override
  String get timeoutTriple => '3× システム';

  @override
  String get timeoutStayOn => '常時点灯';

  @override
  String get scanning => 'スキャン';

  @override
  String get showMacAddress => 'MAC アドレスを表示';

  @override
  String get showMacBlocked => 'Google のプライバシー上の理由により Android v.11 以降では無効です';

  @override
  String get showMacSubtitle => 'スキャン結果に MAC 列を表示';

  @override
  String get resolveHostnames => 'ホスト名を解決';

  @override
  String get resolveHostnamesSubtitle => 'スキャン中に逆引き DNS + mDNS を実行';

  @override
  String get enableLogging => 'ログを有効化';

  @override
  String get enableLoggingSubtitle => 'スキャンとツールの出力をログファイルに保存';

  @override
  String get account => 'アカウント';

  @override
  String get logIn => 'ログイン';

  @override
  String get comingSoon => '近日公開';

  @override
  String get settings => '設定';

  @override
  String get aboutSimplyNet => 'SimplyNet について';

  @override
  String get scan => 'スキャン';

  @override
  String get logs => 'ログ';

  @override
  String get networkTools => 'ネットワークツール';

  @override
  String get networkTarget => 'ネットワーク対象';

  @override
  String get networkTargetHint => '例: 192.168.1.0/24';

  @override
  String get invalidCidr => '無効な CIDR — 192.168.1.0/24 の形式を使用してください';

  @override
  String get detectMyNetwork => '自分のネットワークを検出';

  @override
  String get toolSpeedTest => '速度テスト';

  @override
  String get toolSpeedTestSub => 'ダウンロード・アップロード速度';

  @override
  String get toolPublicIp => 'パブリック IP';

  @override
  String get toolPublicIpSub => 'あなたの IP、ISP、位置';

  @override
  String get toolIpCameras => 'IP カメラ';

  @override
  String get toolIpCamerasSub => 'LAN 上のカメラを検索';

  @override
  String get toolIotDevices => 'IoT デバイス';

  @override
  String get toolIotDevicesSub => 'Matter、Tasmota、Shelly など';

  @override
  String get toolMqttSub => 'MQTT 購読';

  @override
  String get toolMqttSubSub => 'MQTT トピックを購読';

  @override
  String get toolMqttPub => 'MQTT 発行';

  @override
  String get toolMqttPubSub => 'MQTT トピックに発行';

  @override
  String get toolPortScan => 'ポートスキャン';

  @override
  String get toolPortScanSub => '任意のホストの開いている TCP/UDP ポート';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'グラフ付きライブ Ping';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => '任意のホストへのホップごとの経路';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS、DNS、逆引き';

  @override
  String get toolWifiChannels => 'Wi-Fi チャンネル';

  @override
  String get toolWifiChannelsSub => '2.4・5 GHz 干渉マップ';

  @override
  String get toolCellularInfo => 'セルラー情報';

  @override
  String get toolCellularInfoSub => '信号、セル ID、基地局データ';

  @override
  String get about => '情報';

  @override
  String get close => '閉じる';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get delete => '削除';

  @override
  String get retry => '再試行';
}
