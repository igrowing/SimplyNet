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

  @override
  String get stop => '停止';

  @override
  String get clear => 'クリア';

  @override
  String get copy => 'コピー';

  @override
  String get copied => 'コピーしました';

  @override
  String get copyIp => 'IP をコピー';

  @override
  String get hostHint => 'IP アドレスまたはホスト名';

  @override
  String get domainHostHint => 'ドメイン、IP アドレス、またはホスト名';

  @override
  String get go => '実行';

  @override
  String get trace => '追跡';

  @override
  String get lookUp => '検索';

  @override
  String get lookingUp => '検索中…';

  @override
  String get enterHostGo => 'ホストを入力して実行を押してください';

  @override
  String get enterHostTrace => 'ホストを入力して追跡を押してください';

  @override
  String get enterHostScan => 'ホストを入力してスキャンをタップ';

  @override
  String get enterDomainIp => 'ドメイン、IP、またはホスト名を入力';

  @override
  String get aboutPing => 'Ping について';

  @override
  String get aboutTraceroute => 'Traceroute について';

  @override
  String get aboutWhois => 'Who Is について';

  @override
  String get aboutPortScan => 'ポートスキャンについて';

  @override
  String get hiddenNode => '非表示ノード';

  @override
  String get destination => '宛先';

  @override
  String get yourRouter => 'あなたのルーター';

  @override
  String get networkHop => 'ネットワークホップ';

  @override
  String get hop => 'ホップ';

  @override
  String get noReply => '応答なし';

  @override
  String get probingNextHop => '次のホップを調査中…';

  @override
  String get hiddenNodeInfo =>
      'このルーターはプローブに応答しませんでした。多くの ISP、ファイアウォール、セキュリティ機器は ICMP（ping）トラフィックを意図的に破棄または制限するため、データが通過していてもホップは匿名のままになります。\n\nこれは正常であり、経路が壊れていることを意味しません。';

  @override
  String get portsLabel => 'ポート:';

  @override
  String get wellKnown => '既知';

  @override
  String get rangeLabel => '範囲';

  @override
  String get fromLabel => '開始:';

  @override
  String get toLabel => '終了:';

  @override
  String get protocolLabel => 'プロトコル:';

  @override
  String get hideSettings => '設定を隠す';

  @override
  String get myPublicIp => '自分のパブリック IP';

  @override
  String get errorLabel => 'エラー';

  @override
  String get infoUnavailable => '情報を利用できません。';

  @override
  String get startTest => 'テスト開始';

  @override
  String get download => 'ダウンロード';

  @override
  String get upload => 'アップロード';

  @override
  String get statusReady => '準備完了';

  @override
  String get statusDone => '完了';

  @override
  String get measuringPing => 'ping を測定中…';

  @override
  String get findingServer => 'サーバーを検索中…';

  @override
  String get testingDownload => 'ダウンロードをテスト中…';

  @override
  String get testingUpload => 'アップロードをテスト中…';

  @override
  String get viaCloudflare => 'Cloudflare 経由';

  @override
  String get viaOokla => 'Ookla 経由';

  @override
  String get aboutSpeedTestTip => '速度テストについて';

  @override
  String get speedTestInfo => '速度テスト情報';

  @override
  String get previousMeasurements => '過去の測定';

  @override
  String get noMeasurements => 'まだ測定がありません。';

  @override
  String get dateTime => '日付 / 時刻';

  @override
  String get switchToOokla => 'Ookla に切り替えますか？';

  @override
  String get ooklaConsentBody =>
      'Ookla に切り替えるにはサードパーティのサーバーへの接続が必要です。Ookla は あなたの IP アドレス、デバイス識別子、位置情報を収集・共有します。';

  @override
  String get decline => '拒否';

  @override
  String get accept => '同意';

  @override
  String get clearHistoryTitle => '履歴を消去しますか？';

  @override
  String get clearHistoryBody => 'すべての測定記録を完全に削除します。';

  @override
  String get aboutThisScan => 'このスキャンについて';

  @override
  String get scanInfoBody =>
      'ICMP（ping）をブロックするデバイスはここに表示されません。「IoT デバイス」または「IP カメラ」スキャンを実行して、開いているポートとサービスから検出してください。\n\nAndroid 11 以降のデバイスでは、Google のプライバシー制限により MAC アドレスを取得できないため表示されません。';

  @override
  String get stopScan => 'スキャンを停止';

  @override
  String get reScan => '再スキャン';

  @override
  String get hostsFound => '台のホストを検出';

  @override
  String get hostname => 'ホスト名';

  @override
  String get noSavedResults => '保存された結果はありません';

  @override
  String get noNetworkTarget => 'ネットワーク対象が未設定';

  @override
  String get tapRefreshToScan => '更新ボタンをタップしてスキャン';

  @override
  String get setTargetHome => 'ホーム画面で対象を設定してください';

  @override
  String get openInBrowser => 'ブラウザで開く (HTTP)';

  @override
  String get openSsh => 'SSH を開く';

  @override
  String get couldNotOpenBrowser => 'ブラウザを開けませんでした';

  @override
  String get noSshApp =>
      'SSH アプリが見つかりません。ConnectBot または Termius をインストールしてください。';

  @override
  String get deviceInfo => 'デバイス情報';

  @override
  String get ipAddress => 'IP アドレス';

  @override
  String get macAddress => 'MAC アドレス';

  @override
  String get manufacturer => 'メーカー';

  @override
  String get deviceTypeLabel => 'デバイスの種類';

  @override
  String get openPorts => '開いているポート';

  @override
  String get stopPortScan => 'ポートスキャンを停止';

  @override
  String get portScanSettings => 'ポートスキャン設定';

  @override
  String get reScanPorts => 'ポートを再スキャン';

  @override
  String get noOpenPorts => '開いているポートが見つかりません。';

  @override
  String get applyRescan => '適用して再スキャン';

  @override
  String get diagnostics => '診断';

  @override
  String get times => '回';

  @override
  String get deleteAllLogs => 'すべてのログを削除';

  @override
  String get deleteAllLogsQ => 'すべてのログを削除しますか？';

  @override
  String get cannotBeUndone => 'この操作は元に戻せません。';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get deleteLogQ => 'ログを削除しますか？';

  @override
  String get noLogsYet => 'ログはまだありません';

  @override
  String get scanningEllipsis => 'スキャン中…';

  @override
  String get iotDevicesFound => '台の IoT デバイスを検出';

  @override
  String get iotNoSaved => '保存された結果はありません。\n更新してスキャンしてください。';

  @override
  String get unknown => '不明';

  @override
  String get viaLabel => '経由';

  @override
  String get confDefinite => '確実';

  @override
  String get confProbable => 'たぶん';

  @override
  String get confPossible => '可能性あり';

  @override
  String get ipCameraScan => 'IP カメラスキャン';

  @override
  String get camMethodProtocolPort => 'プロトコルポート';

  @override
  String get camMethodKnownVendor => '既知のベンダー';

  @override
  String get camMethodHttpFingerprint => 'HTTP フィンガープリント';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'スキャン中… $done/$total ホスト — カメラ $n 台';
  }

  @override
  String camNoSaved(Object cidr) {
    return '保存された結果はありません — 更新して $cidr をスキャン';
  }

  @override
  String camFound(Object cidr, Object n) {
    return 'カメラ $n 台を検出 — $cidr';
  }

  @override
  String get noCamerasFound => 'カメラが見つかりません。';

  @override
  String get mqttSettingsTitle => 'MQTT 設定';

  @override
  String get brokerIpFqdn => 'ブローカー IP / FQDN';

  @override
  String get searchingSubnet => 'サブネットを検索中…';

  @override
  String get brokerHint => '例: 192.168.1.10 または broker.example.com';

  @override
  String get portLabel => 'ポート';

  @override
  String get usernameOptional => 'ユーザー名（任意）';

  @override
  String get leaveEmptyOptional => '不要な場合は空欄のまま';

  @override
  String get passwordOptional => 'パスワード（任意）';

  @override
  String get keepPassword => 'パスワードを保存（非推奨）';

  @override
  String get keepPasswordSub => 'パスワードはアプリのストレージに平文で保存されます。';

  @override
  String get save => '保存';

  @override
  String get screenStaysOn => '画面をオンのままにする';

  @override
  String get screenMaySleep => '画面がスリープする場合があります';

  @override
  String get mqttSubscribe => 'MQTT 購読';

  @override
  String get mqttPublish => 'MQTT 発行';

  @override
  String get topicLabel => 'トピック';

  @override
  String get topicSubHint => '例: home/sensor/# または home/sensor/temp';

  @override
  String get listen => '受信';

  @override
  String get humanReadableJson => '読みやすい JSON';

  @override
  String get waitingForMessages => 'メッセージを待機中…';

  @override
  String get enterTopicListen => 'トピックを入力して受信をタップ';

  @override
  String get tapListenReceive => '受信をタップして受信開始';

  @override
  String get enterTopicTapListen => 'トピックを入力して受信をタップ';

  @override
  String get enterTopicFirst => '先にトピックを入力してください。';

  @override
  String get stoppedStatus => '停止しました。';

  @override
  String get connectingStatus => '接続中…';

  @override
  String get reconnectingStatus => '再接続中…';

  @override
  String listeningOn(Object topic) {
    return '\"$topic\" を受信中';
  }

  @override
  String connFailed(Object e) {
    return '接続に失敗しました: $e';
  }

  @override
  String get topicPubHint => '例: home/light/switch';

  @override
  String get messageLabel => 'メッセージ';

  @override
  String get enterPayload => 'ペイロードを入力…';

  @override
  String get retain => '保持';

  @override
  String get retainSub => 'ブローカーは新しい購読者のために最後のメッセージを保持します。';

  @override
  String get publish => '発行';

  @override
  String get connectedEnterTopic => '接続済み — 下にトピックを入力';

  @override
  String connectedTopic(Object topic) {
    return '接続済み — トピック: \"$topic\"';
  }

  @override
  String get disconnectedStatus => '切断されました';

  @override
  String publishedTo(Object topic) {
    return '\"$topic\" に発行しました';
  }

  @override
  String get about5GhzChannels => '5 GHz チャンネルについて';

  @override
  String get wifiBandInfoTitle => '5 GHz ネットワークでのデュアルアクセスポイント検出';

  @override
  String get wifiBandInfoBody =>
      '💡 SSID を長押しすると、アクセスポイントの完全な名前が表示されます。\n\nℹ️ 5 GHz 帯では通常、各アクセスポイントが 2 つ（またはそれ以上）のチャンネルに同時に表示されます。これは正常です。\n\n高速化のため、最近のルーターは隣接する 20 MHz のチャンネルをつなげて、より広いレーン——40、80、さらには 160 MHz——にします。これを\"チャンネルボンディング\"と呼びます。広いレーンは、広い道路がより多くの車を通すように、より多くのデータを運びます。\n\n\"動的チャンネル幅\"では、ルーターは使える最も広いレーンを選び、電波が混雑したりノイズが増えたりすると自動的に狭めるので、近隣に干渉せずに高速を保ちます。\n\nつまり、たとえばチャンネル 36 と 40 に表示される 1 つの 5 GHz ネットワークは、40 MHz 幅の結合チャンネルを使う 1 台のアクセスポイントであり、2 つの別々のネットワークではありません。';

  @override
  String get noResults => '結果がありません。';

  @override
  String get scanErrorPrefix => 'スキャンエラー';

  @override
  String noBandNetworks(Object band) {
    return '$band ネットワークが検出されませんでした。';
  }

  @override
  String get securityLabel => 'セキュリティ';

  @override
  String get qualityLabel => '品質';

  @override
  String get qExcellent => '非常に良い';

  @override
  String get qGood => '良い';

  @override
  String get qFair => '普通';

  @override
  String get qWeak => '弱い';

  @override
  String get qPoor => '悪い';

  @override
  String get refresh => '更新';

  @override
  String get cellShowingDemo => 'デモデータを表示しています。';

  @override
  String get noDataReturned => 'デバイスからデータが返されませんでした。';

  @override
  String get platformErrorPrefix => 'プラットフォームエラー';

  @override
  String get carrier => '通信事業者';

  @override
  String get provider => 'プロバイダー';

  @override
  String get technology => '技術';

  @override
  String get roaming => 'ローミング';

  @override
  String get dataState => 'データの状態';

  @override
  String get signalQuality => '信号品質';

  @override
  String get cellTower => '基地局';

  @override
  String get cellId => 'セル ID';

  @override
  String get bandLabel => 'バンド';

  @override
  String get estDistance => '推定距離';

  @override
  String get location => '位置';

  @override
  String get coordinates => '座標';

  @override
  String get locating => '位置を取得中…';

  @override
  String get nearestPlace => '最寄りの場所';

  @override
  String get deniedByUser => 'ユーザーによって拒否されました';

  @override
  String get unavailablePrefix => '利用不可';

  @override
  String get signalStrength => '信号強度';

  @override
  String get rsrpHint =>
      'RSRP — リファレンス信号受信電力。\n\nセルのリファレンス信号の平均電力で、dBm 単位で測定されます。生の信号強度を表します。\n\n一般的な範囲: 約 −80 dBm（非常に良い）から −120 dBm（非常に弱い）まで。高い（ゼロに近い）ほど良好です。';

  @override
  String get rsrqHint =>
      'RSRQ — リファレンス信号受信品質。\n\ndB 単位の信号品質で、強度に加えて干渉やネットワーク負荷も考慮します。\n\n一般的な範囲: 約 −3 dB（非常に良い）から −20 dB（悪い）まで。高いほど良好です。';

  @override
  String get sinrHint =>
      'SINR — 信号対干渉雑音比。\n\n目的の信号が干渉と背景雑音をどれだけ上回るかを dB で示します。\n\n高いほど良好: 約 20 dB を超えると非常に良く、0 dB 前後以下は悪いです。';

  @override
  String get pciHint =>
      'PCI — 物理セル ID。\n\n無線インターフェース上でサービング セルを識別する番号（LTE では 0–503）。隣接セルは異なる PCI を使うため、端末はそれらを区別できます。';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA 絶対無線周波数チャンネル番号。\n\nデバイスが使用している正確なキャリア周波数を識別します。特定の LTE バンドとチャンネルに対応します。';

  @override
  String get estDistHint =>
      '基地局までの推定距離。\n\n電波伝搬モデルを用いて信号強度（RSRP）から算出しています。これは非常におおまかな桁数レベルの目安であり — 正確な測定値ではありません。';

  @override
  String get version => 'バージョン';

  @override
  String get sendFeedback => 'フィードバック / 改善案を送る';

  @override
  String get buyMeCoffee => 'コーヒーをおごる';

  @override
  String get shareAction => '共有';
}
