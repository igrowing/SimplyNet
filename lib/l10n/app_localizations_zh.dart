// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsTitle => '设置';

  @override
  String get appearance => '外观';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeAuto => '自动';

  @override
  String get screenOnTimeout => '屏幕常亮超时';

  @override
  String get timeoutSystem => '系统';

  @override
  String get timeoutTriple => '3× 系统';

  @override
  String get timeoutStayOn => '保持常亮';

  @override
  String get scanning => '扫描';

  @override
  String get showMacAddress => '显示 MAC 地址';

  @override
  String get showMacBlocked => '由于 Google 隐私限制，在 Android v.11 及以上版本停用';

  @override
  String get showMacSubtitle => '在扫描结果中显示 MAC 列';

  @override
  String get resolveHostnames => '解析主机名';

  @override
  String get resolveHostnamesSubtitle => '扫描时执行反向 DNS + mDNS';

  @override
  String get enableLogging => '启用日志';

  @override
  String get enableLoggingSubtitle => '将扫描和工具输出保存到日志文件';

  @override
  String get account => '账户';

  @override
  String get logIn => '登录';

  @override
  String get comingSoon => '即将推出';

  @override
  String get settings => '设置';

  @override
  String get aboutSimplyNet => '关于 SimplyNet';

  @override
  String get scan => '扫描';

  @override
  String get logs => '日志';

  @override
  String get networkTools => '网络工具';

  @override
  String get networkTarget => '网络目标';

  @override
  String get networkTargetHint => '例如 192.168.1.0/24';

  @override
  String get invalidCidr => '无效的 CIDR — 请使用如 192.168.1.0/24 的格式';

  @override
  String get detectMyNetwork => '检测我的网络';

  @override
  String get toolSpeedTest => '速度测试';

  @override
  String get toolSpeedTestSub => '下载和上传速度';

  @override
  String get toolPublicIp => '公网 IP';

  @override
  String get toolPublicIpSub => '您的 IP、ISP 和位置';

  @override
  String get toolIpCameras => 'IP 摄像头';

  @override
  String get toolIpCamerasSub => '查找局域网中的摄像头';

  @override
  String get toolIotDevices => 'IoT 设备';

  @override
  String get toolIotDevicesSub => 'Matter、Tasmota、Shelly 等';

  @override
  String get toolMqttSub => 'MQTT 订阅';

  @override
  String get toolMqttSubSub => '订阅 MQTT 主题';

  @override
  String get toolMqttPub => 'MQTT 发布';

  @override
  String get toolMqttPubSub => '发布到 MQTT 主题';

  @override
  String get toolPortScan => '端口扫描';

  @override
  String get toolPortScanSub => '任意主机的开放 TCP/UDP 端口';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => '带图表的实时 Ping';

  @override
  String get toolTraceroute => '路由跟踪';

  @override
  String get toolTracerouteSub => '到任意主机的逐跳路径';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS、DNS 和反向查询';

  @override
  String get toolWifiChannels => 'Wi-Fi 信道';

  @override
  String get toolWifiChannelsSub => '2.4 与 5 GHz 干扰图';

  @override
  String get toolCellularInfo => '蜂窝信息';

  @override
  String get toolCellularInfoSub => '信号、小区 ID 和基站数据';

  @override
  String get about => '关于';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get ok => '确定';

  @override
  String get delete => '删除';

  @override
  String get retry => '重试';

  @override
  String get stop => '停止';

  @override
  String get clear => '清除';

  @override
  String get copy => '复制';

  @override
  String get copied => '已复制';

  @override
  String get copyIp => '复制 IP';

  @override
  String get hostHint => 'IP 地址或主机名';

  @override
  String get domainHostHint => '域名、IP 地址或主机名';

  @override
  String get go => '开始';

  @override
  String get trace => '追踪';

  @override
  String get lookUp => '查询';

  @override
  String get lookingUp => '查询中…';

  @override
  String get enterHostGo => '输入主机并点击开始';

  @override
  String get enterHostTrace => '输入主机并点击追踪';

  @override
  String get enterHostScan => '输入主机并点击扫描';

  @override
  String get enterDomainIp => '输入域名、IP 或主机名';

  @override
  String get aboutPing => '关于 Ping';

  @override
  String get aboutTraceroute => '关于 Traceroute';

  @override
  String get aboutWhois => '关于 Who Is';

  @override
  String get aboutPortScan => '关于端口扫描';

  @override
  String get hiddenNode => '隐藏节点';

  @override
  String get destination => '目标';

  @override
  String get yourRouter => '你的路由器';

  @override
  String get networkHop => '网络跳转';

  @override
  String get hop => '跳';

  @override
  String get noReply => '无响应';

  @override
  String get probingNextHop => '正在探测下一跳…';

  @override
  String get hiddenNodeInfo =>
      '该路由器未回应我们的探测。许多 ISP、防火墙和安全设备会故意丢弃或限制 ICMP（ping）流量，因此即使数据仍经过该跳，它也保持匿名。\n\n这是正常现象，并不意味着路由中断。';

  @override
  String get portsLabel => '端口：';

  @override
  String get wellKnown => '常用';

  @override
  String get rangeLabel => '范围';

  @override
  String get fromLabel => '从：';

  @override
  String get toLabel => '到：';

  @override
  String get protocolLabel => '协议：';

  @override
  String get hideSettings => '隐藏设置';

  @override
  String get myPublicIp => '我的公网 IP';

  @override
  String get errorLabel => '错误';

  @override
  String get infoUnavailable => '信息不可用。';

  @override
  String get startTest => '开始测试';

  @override
  String get download => '下载';

  @override
  String get upload => '上传';

  @override
  String get statusReady => '就绪';

  @override
  String get statusDone => '完成';

  @override
  String get measuringPing => '正在测量 ping…';

  @override
  String get findingServer => '正在查找服务器…';

  @override
  String get testingDownload => '正在测试下载…';

  @override
  String get testingUpload => '正在测试上传…';

  @override
  String get viaCloudflare => '通过 Cloudflare';

  @override
  String get viaOokla => '通过 Ookla';

  @override
  String get aboutSpeedTestTip => '关于速度测试';

  @override
  String get speedTestInfo => '速度测试信息';

  @override
  String get previousMeasurements => '历史测量';

  @override
  String get noMeasurements => '暂无测量。';

  @override
  String get dateTime => '日期 / 时间';

  @override
  String get switchToOokla => '切换到 Ookla？';

  @override
  String get ooklaConsentBody =>
      '切换到 Ookla 需要连接第三方服务器。Ookla 会收集并共享你的 IP 地址、设备标识符和位置信息。';

  @override
  String get decline => '拒绝';

  @override
  String get accept => '接受';

  @override
  String get clearHistoryTitle => '清除历史记录？';

  @override
  String get clearHistoryBody => '这将永久删除所有测量记录。';

  @override
  String get aboutThisScan => '关于此扫描';

  @override
  String get scanInfoBody =>
      '屏蔽 ICMP（ping）的设备不会显示在此处。运行“IoT 设备”或“IP 摄像头”扫描，通过其开放端口和服务来定位它们。\n\n在 Android 11+ 设备上，由于 Google 的隐私限制，无法获取 MAC 地址，因此不予显示。';

  @override
  String get stopScan => '停止扫描';

  @override
  String get reScan => '重新扫描';

  @override
  String get hostsFound => '个主机';

  @override
  String get hostname => '主机名';

  @override
  String get noSavedResults => '无保存的结果';

  @override
  String get noNetworkTarget => '未设置网络目标';

  @override
  String get tapRefreshToScan => '点击刷新按钮进行扫描';

  @override
  String get setTargetHome => '在主屏幕上设置目标';

  @override
  String get openInBrowser => '在浏览器中打开 (HTTP)';

  @override
  String get openSsh => '打开 SSH';

  @override
  String get couldNotOpenBrowser => '无法打开浏览器';

  @override
  String get noSshApp => '未找到 SSH 应用。请安装 ConnectBot 或 Termius。';

  @override
  String get deviceInfo => '设备信息';

  @override
  String get ipAddress => 'IP 地址';

  @override
  String get macAddress => 'MAC 地址';

  @override
  String get manufacturer => '制造商';

  @override
  String get deviceTypeLabel => '设备类型';

  @override
  String get openPorts => '开放端口';

  @override
  String get stopPortScan => '停止端口扫描';

  @override
  String get portScanSettings => '端口扫描设置';

  @override
  String get reScanPorts => '重新扫描端口';

  @override
  String get noOpenPorts => '未找到开放端口。';

  @override
  String get applyRescan => '应用并重新扫描';

  @override
  String get diagnostics => '诊断';

  @override
  String get times => '次';

  @override
  String get deleteAllLogs => '删除所有日志';

  @override
  String get deleteAllLogsQ => '删除所有日志？';

  @override
  String get cannotBeUndone => '此操作无法撤销。';

  @override
  String get deleteAll => '全部删除';

  @override
  String get deleteLogQ => '删除日志？';

  @override
  String get noLogsYet => '暂无日志';

  @override
  String get scanningEllipsis => '扫描中…';

  @override
  String get iotDevicesFound => '个 IoT 设备';

  @override
  String get iotNoSaved => '无保存的结果。\n点击刷新进行扫描。';

  @override
  String get unknown => '未知';

  @override
  String get viaLabel => '通过';

  @override
  String get confDefinite => '确定';

  @override
  String get confProbable => '可能';

  @override
  String get confPossible => '或许';

  @override
  String get ipCameraScan => 'IP 摄像头扫描';

  @override
  String get camMethodProtocolPort => '协议端口';

  @override
  String get camMethodKnownVendor => '已知厂商';

  @override
  String get camMethodHttpFingerprint => 'HTTP 指纹';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return '扫描中… $done/$total 主机 — $n 个摄像头';
  }

  @override
  String camNoSaved(Object cidr) {
    return '无保存的结果 — 点击刷新以扫描 $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '找到 $n 个摄像头 — $cidr';
  }

  @override
  String get noCamerasFound => '未找到摄像头。';

  @override
  String get mqttSettingsTitle => 'MQTT 设置';

  @override
  String get brokerIpFqdn => '代理 IP / FQDN';

  @override
  String get searchingSubnet => '正在搜索子网…';

  @override
  String get brokerHint => '例如 192.168.1.10 或 broker.example.com';

  @override
  String get portLabel => '端口';

  @override
  String get usernameOptional => '用户名（可选）';

  @override
  String get leaveEmptyOptional => '如不需要请留空';

  @override
  String get passwordOptional => '密码（可选）';

  @override
  String get keepPassword => '保存密码（不推荐）';

  @override
  String get keepPasswordSub => '密码以明文形式存储在应用存储中。';

  @override
  String get save => '保存';

  @override
  String get screenStaysOn => '屏幕保持常亮';

  @override
  String get screenMaySleep => '屏幕可能休眠';

  @override
  String get mqttSubscribe => 'MQTT 订阅';

  @override
  String get mqttPublish => 'MQTT 发布';

  @override
  String get topicLabel => '主题';

  @override
  String get topicSubHint => '例如 home/sensor/# 或 home/sensor/temp';

  @override
  String get listen => '监听';

  @override
  String get humanReadableJson => '易读 JSON';

  @override
  String get waitingForMessages => '正在等待消息…';

  @override
  String get enterTopicListen => '输入主题并点击监听';

  @override
  String get tapListenReceive => '点击监听开始接收';

  @override
  String get enterTopicTapListen => '输入主题并点击监听';

  @override
  String get enterTopicFirst => '请先输入主题。';

  @override
  String get stoppedStatus => '已停止。';

  @override
  String get connectingStatus => '连接中…';

  @override
  String get reconnectingStatus => '重新连接中…';

  @override
  String listeningOn(Object topic) {
    return '正在监听 \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return '连接失败：$e';
  }

  @override
  String get topicPubHint => '例如 home/light/switch';

  @override
  String get messageLabel => '消息';

  @override
  String get enterPayload => '输入负载…';

  @override
  String get retain => '保留';

  @override
  String get retainSub => '代理为新订阅者保留最后一条消息。';

  @override
  String get publish => '发布';

  @override
  String get connectedEnterTopic => '已连接 — 在下方输入主题';

  @override
  String connectedTopic(Object topic) {
    return '已连接 — 主题：\"$topic\"';
  }

  @override
  String get disconnectedStatus => '已断开连接';

  @override
  String publishedTo(Object topic) {
    return '已发布到 \"$topic\"';
  }

  @override
  String get about5GhzChannels => '关于 5 GHz 信道';

  @override
  String get wifiBandInfoTitle => '5 GHz 网络中的双接入点检测';

  @override
  String get wifiBandInfoBody =>
      '💡 长按 SSID 查看完整的接入点名称。\n\nℹ️ 在 5 GHz 频段上，你通常会看到每个接入点同时出现在两个（或更多）信道上。这是正常的。\n\n为了更快，现代路由器会把相邻的 20 MHz 信道粘合成一条更宽的车道——40、80 甚至 160 MHz。这称为\"信道绑定\"。更宽的车道能承载更多数据，就像更宽的道路能容纳更多汽车一样。\n\n通过\"动态信道宽度\"，路由器会选择它能用的最宽车道，并在空中变得繁忙或嘈杂时自动收窄，从而在不打扰邻居的情况下保持高速。\n\n所以，例如一个同时出现在信道 36 和 40 上的 5 GHz 网络，只是一个使用 40 MHz 宽绑定信道的接入点——而不是两个独立的网络。';

  @override
  String get noResults => '无结果。';

  @override
  String get scanErrorPrefix => '扫描错误';

  @override
  String noBandNetworks(Object band) {
    return '未检测到 $band 网络。';
  }

  @override
  String get securityLabel => '安全';

  @override
  String get qualityLabel => '质量';

  @override
  String get qExcellent => '极佳';

  @override
  String get qGood => '良好';

  @override
  String get qFair => '一般';

  @override
  String get qWeak => '较弱';

  @override
  String get qPoor => '很差';

  @override
  String get refresh => '刷新';

  @override
  String get cellShowingDemo => '正在显示演示数据。';

  @override
  String get noDataReturned => '设备未返回任何数据。';

  @override
  String get platformErrorPrefix => '平台错误';

  @override
  String get carrier => '运营商';

  @override
  String get provider => '提供商';

  @override
  String get technology => '技术';

  @override
  String get roaming => '漫游';

  @override
  String get dataState => '数据状态';

  @override
  String get signalQuality => '信号质量';

  @override
  String get cellTower => '基站';

  @override
  String get cellId => '小区 ID';

  @override
  String get bandLabel => '频段';

  @override
  String get estDistance => '估计距离';

  @override
  String get location => '位置';

  @override
  String get coordinates => '坐标';

  @override
  String get locating => '正在定位…';

  @override
  String get nearestPlace => '最近的地点';

  @override
  String get deniedByUser => '已被用户拒绝';

  @override
  String get unavailablePrefix => '不可用';

  @override
  String get signalStrength => '信号强度';

  @override
  String get rsrpHint =>
      'RSRP — 参考信号接收功率。\n\n小区参考信号的平均功率，以 dBm 为单位。它反映原始信号强度。\n\n典型范围：约 −80 dBm（极佳）到 −120 dBm（非常弱）。数值越高（越接近零）越好。';

  @override
  String get rsrqHint =>
      'RSRQ — 参考信号接收质量。\n\n以 dB 表示的信号质量，除强度外还考虑干扰和网络负载。\n\n典型范围：约 −3 dB（极佳）到 −20 dB（差）。数值越高越好。';

  @override
  String get sinrHint =>
      'SINR — 信号与干扰加噪声比。\n\n有用信号比干扰加背景噪声高出多少，以 dB 表示。\n\n数值越高越好：高于约 20 dB 为极佳，约 0 dB 或以下为差。';

  @override
  String get pciHint =>
      'PCI — 物理小区标识。\n\n一个数字（LTE 上为 0–503），用于在无线接口上标识服务小区。相邻小区使用不同的 PCI，以便手机能够区分它们。';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA 绝对射频信道号。\n\n标识设备正在使用的确切载波频率；它对应到特定的 LTE 频段和信道。';

  @override
  String get estDistHint =>
      '到基站的估计距离。\n\n通过无线传播模型从信号强度（RSRP）推算而来。这只是一个非常粗略的数量级参考 — 并非精确测量。';

  @override
  String get version => '版本';

  @override
  String get sendFeedback => '发送反馈 / 改进建议';

  @override
  String get buyMeCoffee => '请我喝杯咖啡';

  @override
  String get shareAction => '分享';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get settingsTitle => '设置';

  @override
  String get appearance => '外观';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeAuto => '自动';

  @override
  String get screenOnTimeout => '屏幕常亮超时';

  @override
  String get timeoutSystem => '系统';

  @override
  String get timeoutTriple => '3× 系统';

  @override
  String get timeoutStayOn => '保持常亮';

  @override
  String get scanning => '扫描';

  @override
  String get showMacAddress => '显示 MAC 地址';

  @override
  String get showMacBlocked => '由于 Google 隐私限制，在 Android v.11 及以上版本停用';

  @override
  String get showMacSubtitle => '在扫描结果中显示 MAC 列';

  @override
  String get resolveHostnames => '解析主机名';

  @override
  String get resolveHostnamesSubtitle => '扫描时执行反向 DNS + mDNS';

  @override
  String get enableLogging => '启用日志';

  @override
  String get enableLoggingSubtitle => '将扫描和工具输出保存到日志文件';

  @override
  String get account => '账户';

  @override
  String get logIn => '登录';

  @override
  String get comingSoon => '即将推出';

  @override
  String get settings => '设置';

  @override
  String get aboutSimplyNet => '关于 SimplyNet';

  @override
  String get scan => '扫描';

  @override
  String get logs => '日志';

  @override
  String get networkTools => '网络工具';

  @override
  String get networkTarget => '网络目标';

  @override
  String get networkTargetHint => '例如 192.168.1.0/24';

  @override
  String get invalidCidr => '无效的 CIDR — 请使用如 192.168.1.0/24 的格式';

  @override
  String get detectMyNetwork => '检测我的网络';

  @override
  String get toolSpeedTest => '速度测试';

  @override
  String get toolSpeedTestSub => '下载和上传速度';

  @override
  String get toolPublicIp => '公网 IP';

  @override
  String get toolPublicIpSub => '您的 IP、ISP 和位置';

  @override
  String get toolIpCameras => 'IP 摄像头';

  @override
  String get toolIpCamerasSub => '查找局域网中的摄像头';

  @override
  String get toolIotDevices => 'IoT 设备';

  @override
  String get toolIotDevicesSub => 'Matter、Tasmota、Shelly 等';

  @override
  String get toolMqttSub => 'MQTT 订阅';

  @override
  String get toolMqttSubSub => '订阅 MQTT 主题';

  @override
  String get toolMqttPub => 'MQTT 发布';

  @override
  String get toolMqttPubSub => '发布到 MQTT 主题';

  @override
  String get toolPortScan => '端口扫描';

  @override
  String get toolPortScanSub => '任意主机的开放 TCP/UDP 端口';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => '带图表的实时 Ping';

  @override
  String get toolTraceroute => '路由跟踪';

  @override
  String get toolTracerouteSub => '到任意主机的逐跳路径';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS、DNS 和反向查询';

  @override
  String get toolWifiChannels => 'Wi-Fi 信道';

  @override
  String get toolWifiChannelsSub => '2.4 与 5 GHz 干扰图';

  @override
  String get toolCellularInfo => '蜂窝信息';

  @override
  String get toolCellularInfoSub => '信号、小区 ID 和基站数据';

  @override
  String get about => '关于';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get ok => '确定';

  @override
  String get delete => '删除';

  @override
  String get retry => '重试';

  @override
  String get stop => '停止';

  @override
  String get clear => '清除';

  @override
  String get copy => '复制';

  @override
  String get copied => '已复制';

  @override
  String get copyIp => '复制 IP';

  @override
  String get hostHint => 'IP 地址或主机名';

  @override
  String get domainHostHint => '域名、IP 地址或主机名';

  @override
  String get go => '开始';

  @override
  String get trace => '追踪';

  @override
  String get lookUp => '查询';

  @override
  String get lookingUp => '查询中…';

  @override
  String get enterHostGo => '输入主机并点击开始';

  @override
  String get enterHostTrace => '输入主机并点击追踪';

  @override
  String get enterHostScan => '输入主机并点击扫描';

  @override
  String get enterDomainIp => '输入域名、IP 或主机名';

  @override
  String get aboutPing => '关于 Ping';

  @override
  String get aboutTraceroute => '关于 Traceroute';

  @override
  String get aboutWhois => '关于 Who Is';

  @override
  String get aboutPortScan => '关于端口扫描';

  @override
  String get hiddenNode => '隐藏节点';

  @override
  String get destination => '目标';

  @override
  String get yourRouter => '你的路由器';

  @override
  String get networkHop => '网络跳转';

  @override
  String get hop => '跳';

  @override
  String get noReply => '无响应';

  @override
  String get probingNextHop => '正在探测下一跳…';

  @override
  String get hiddenNodeInfo =>
      '该路由器未回应我们的探测。许多 ISP、防火墙和安全设备会故意丢弃或限制 ICMP（ping）流量，因此即使数据仍经过该跳，它也保持匿名。\n\n这是正常现象，并不意味着路由中断。';

  @override
  String get portsLabel => '端口：';

  @override
  String get wellKnown => '常用';

  @override
  String get rangeLabel => '范围';

  @override
  String get fromLabel => '从：';

  @override
  String get toLabel => '到：';

  @override
  String get protocolLabel => '协议：';

  @override
  String get hideSettings => '隐藏设置';

  @override
  String get myPublicIp => '我的公网 IP';

  @override
  String get errorLabel => '错误';

  @override
  String get infoUnavailable => '信息不可用。';

  @override
  String get startTest => '开始测试';

  @override
  String get download => '下载';

  @override
  String get upload => '上传';

  @override
  String get statusReady => '就绪';

  @override
  String get statusDone => '完成';

  @override
  String get measuringPing => '正在测量 ping…';

  @override
  String get findingServer => '正在查找服务器…';

  @override
  String get testingDownload => '正在测试下载…';

  @override
  String get testingUpload => '正在测试上传…';

  @override
  String get viaCloudflare => '通过 Cloudflare';

  @override
  String get viaOokla => '通过 Ookla';

  @override
  String get aboutSpeedTestTip => '关于速度测试';

  @override
  String get speedTestInfo => '速度测试信息';

  @override
  String get previousMeasurements => '历史测量';

  @override
  String get noMeasurements => '暂无测量。';

  @override
  String get dateTime => '日期 / 时间';

  @override
  String get switchToOokla => '切换到 Ookla？';

  @override
  String get ooklaConsentBody =>
      '切换到 Ookla 需要连接第三方服务器。Ookla 会收集并共享你的 IP 地址、设备标识符和位置信息。';

  @override
  String get decline => '拒绝';

  @override
  String get accept => '接受';

  @override
  String get clearHistoryTitle => '清除历史记录？';

  @override
  String get clearHistoryBody => '这将永久删除所有测量记录。';

  @override
  String get aboutThisScan => '关于此扫描';

  @override
  String get scanInfoBody =>
      '屏蔽 ICMP（ping）的设备不会显示在此处。运行“IoT 设备”或“IP 摄像头”扫描，通过其开放端口和服务来定位它们。\n\n在 Android 11+ 设备上，由于 Google 的隐私限制，无法获取 MAC 地址，因此不予显示。';

  @override
  String get stopScan => '停止扫描';

  @override
  String get reScan => '重新扫描';

  @override
  String get hostsFound => '个主机';

  @override
  String get hostname => '主机名';

  @override
  String get noSavedResults => '无保存的结果';

  @override
  String get noNetworkTarget => '未设置网络目标';

  @override
  String get tapRefreshToScan => '点击刷新按钮进行扫描';

  @override
  String get setTargetHome => '在主屏幕上设置目标';

  @override
  String get openInBrowser => '在浏览器中打开 (HTTP)';

  @override
  String get openSsh => '打开 SSH';

  @override
  String get couldNotOpenBrowser => '无法打开浏览器';

  @override
  String get noSshApp => '未找到 SSH 应用。请安装 ConnectBot 或 Termius。';

  @override
  String get deviceInfo => '设备信息';

  @override
  String get ipAddress => 'IP 地址';

  @override
  String get macAddress => 'MAC 地址';

  @override
  String get manufacturer => '制造商';

  @override
  String get deviceTypeLabel => '设备类型';

  @override
  String get openPorts => '开放端口';

  @override
  String get stopPortScan => '停止端口扫描';

  @override
  String get portScanSettings => '端口扫描设置';

  @override
  String get reScanPorts => '重新扫描端口';

  @override
  String get noOpenPorts => '未找到开放端口。';

  @override
  String get applyRescan => '应用并重新扫描';

  @override
  String get diagnostics => '诊断';

  @override
  String get times => '次';

  @override
  String get deleteAllLogs => '删除所有日志';

  @override
  String get deleteAllLogsQ => '删除所有日志？';

  @override
  String get cannotBeUndone => '此操作无法撤销。';

  @override
  String get deleteAll => '全部删除';

  @override
  String get deleteLogQ => '删除日志？';

  @override
  String get noLogsYet => '暂无日志';

  @override
  String get scanningEllipsis => '扫描中…';

  @override
  String get iotDevicesFound => '个 IoT 设备';

  @override
  String get iotNoSaved => '无保存的结果。\n点击刷新进行扫描。';

  @override
  String get unknown => '未知';

  @override
  String get viaLabel => '通过';

  @override
  String get confDefinite => '确定';

  @override
  String get confProbable => '可能';

  @override
  String get confPossible => '或许';

  @override
  String get ipCameraScan => 'IP 摄像头扫描';

  @override
  String get camMethodProtocolPort => '协议端口';

  @override
  String get camMethodKnownVendor => '已知厂商';

  @override
  String get camMethodHttpFingerprint => 'HTTP 指纹';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return '扫描中… $done/$total 主机 — $n 个摄像头';
  }

  @override
  String camNoSaved(Object cidr) {
    return '无保存的结果 — 点击刷新以扫描 $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '找到 $n 个摄像头 — $cidr';
  }

  @override
  String get noCamerasFound => '未找到摄像头。';

  @override
  String get mqttSettingsTitle => 'MQTT 设置';

  @override
  String get brokerIpFqdn => '代理 IP / FQDN';

  @override
  String get searchingSubnet => '正在搜索子网…';

  @override
  String get brokerHint => '例如 192.168.1.10 或 broker.example.com';

  @override
  String get portLabel => '端口';

  @override
  String get usernameOptional => '用户名（可选）';

  @override
  String get leaveEmptyOptional => '如不需要请留空';

  @override
  String get passwordOptional => '密码（可选）';

  @override
  String get keepPassword => '保存密码（不推荐）';

  @override
  String get keepPasswordSub => '密码以明文形式存储在应用存储中。';

  @override
  String get save => '保存';

  @override
  String get screenStaysOn => '屏幕保持常亮';

  @override
  String get screenMaySleep => '屏幕可能休眠';

  @override
  String get mqttSubscribe => 'MQTT 订阅';

  @override
  String get mqttPublish => 'MQTT 发布';

  @override
  String get topicLabel => '主题';

  @override
  String get topicSubHint => '例如 home/sensor/# 或 home/sensor/temp';

  @override
  String get listen => '监听';

  @override
  String get humanReadableJson => '易读 JSON';

  @override
  String get waitingForMessages => '正在等待消息…';

  @override
  String get enterTopicListen => '输入主题并点击监听';

  @override
  String get tapListenReceive => '点击监听开始接收';

  @override
  String get enterTopicTapListen => '输入主题并点击监听';

  @override
  String get enterTopicFirst => '请先输入主题。';

  @override
  String get stoppedStatus => '已停止。';

  @override
  String get connectingStatus => '连接中…';

  @override
  String get reconnectingStatus => '重新连接中…';

  @override
  String listeningOn(Object topic) {
    return '正在监听 \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return '连接失败：$e';
  }

  @override
  String get topicPubHint => '例如 home/light/switch';

  @override
  String get messageLabel => '消息';

  @override
  String get enterPayload => '输入负载…';

  @override
  String get retain => '保留';

  @override
  String get retainSub => '代理为新订阅者保留最后一条消息。';

  @override
  String get publish => '发布';

  @override
  String get connectedEnterTopic => '已连接 — 在下方输入主题';

  @override
  String connectedTopic(Object topic) {
    return '已连接 — 主题：\"$topic\"';
  }

  @override
  String get disconnectedStatus => '已断开连接';

  @override
  String publishedTo(Object topic) {
    return '已发布到 \"$topic\"';
  }

  @override
  String get about5GhzChannels => '关于 5 GHz 信道';

  @override
  String get wifiBandInfoTitle => '5 GHz 网络中的双接入点检测';

  @override
  String get wifiBandInfoBody =>
      '💡 长按 SSID 查看完整的接入点名称。\n\nℹ️ 在 5 GHz 频段上，你通常会看到每个接入点同时出现在两个（或更多）信道上。这是正常的。\n\n为了更快，现代路由器会把相邻的 20 MHz 信道粘合成一条更宽的车道——40、80 甚至 160 MHz。这称为\"信道绑定\"。更宽的车道能承载更多数据，就像更宽的道路能容纳更多汽车一样。\n\n通过\"动态信道宽度\"，路由器会选择它能用的最宽车道，并在空中变得繁忙或嘈杂时自动收窄，从而在不打扰邻居的情况下保持高速。\n\n所以，例如一个同时出现在信道 36 和 40 上的 5 GHz 网络，只是一个使用 40 MHz 宽绑定信道的接入点——而不是两个独立的网络。';

  @override
  String get noResults => '无结果。';

  @override
  String get scanErrorPrefix => '扫描错误';

  @override
  String noBandNetworks(Object band) {
    return '未检测到 $band 网络。';
  }

  @override
  String get securityLabel => '安全';

  @override
  String get qualityLabel => '质量';

  @override
  String get qExcellent => '极佳';

  @override
  String get qGood => '良好';

  @override
  String get qFair => '一般';

  @override
  String get qWeak => '较弱';

  @override
  String get qPoor => '很差';

  @override
  String get refresh => '刷新';

  @override
  String get cellShowingDemo => '正在显示演示数据。';

  @override
  String get noDataReturned => '设备未返回任何数据。';

  @override
  String get platformErrorPrefix => '平台错误';

  @override
  String get carrier => '运营商';

  @override
  String get provider => '提供商';

  @override
  String get technology => '技术';

  @override
  String get roaming => '漫游';

  @override
  String get dataState => '数据状态';

  @override
  String get signalQuality => '信号质量';

  @override
  String get cellTower => '基站';

  @override
  String get cellId => '小区 ID';

  @override
  String get bandLabel => '频段';

  @override
  String get estDistance => '估计距离';

  @override
  String get location => '位置';

  @override
  String get coordinates => '坐标';

  @override
  String get locating => '正在定位…';

  @override
  String get nearestPlace => '最近的地点';

  @override
  String get deniedByUser => '已被用户拒绝';

  @override
  String get unavailablePrefix => '不可用';

  @override
  String get signalStrength => '信号强度';

  @override
  String get rsrpHint =>
      'RSRP — 参考信号接收功率。\n\n小区参考信号的平均功率，以 dBm 为单位。它反映原始信号强度。\n\n典型范围：约 −80 dBm（极佳）到 −120 dBm（非常弱）。数值越高（越接近零）越好。';

  @override
  String get rsrqHint =>
      'RSRQ — 参考信号接收质量。\n\n以 dB 表示的信号质量，除强度外还考虑干扰和网络负载。\n\n典型范围：约 −3 dB（极佳）到 −20 dB（差）。数值越高越好。';

  @override
  String get sinrHint =>
      'SINR — 信号与干扰加噪声比。\n\n有用信号比干扰加背景噪声高出多少，以 dB 表示。\n\n数值越高越好：高于约 20 dB 为极佳，约 0 dB 或以下为差。';

  @override
  String get pciHint =>
      'PCI — 物理小区标识。\n\n一个数字（LTE 上为 0–503），用于在无线接口上标识服务小区。相邻小区使用不同的 PCI，以便手机能够区分它们。';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA 绝对射频信道号。\n\n标识设备正在使用的确切载波频率；它对应到特定的 LTE 频段和信道。';

  @override
  String get estDistHint =>
      '到基站的估计距离。\n\n通过无线传播模型从信号强度（RSRP）推算而来。这只是一个非常粗略的数量级参考 — 并非精确测量。';

  @override
  String get version => '版本';

  @override
  String get sendFeedback => '发送反馈 / 改进建议';

  @override
  String get buyMeCoffee => '请我喝杯咖啡';

  @override
  String get shareAction => '分享';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get settingsTitle => '設定';

  @override
  String get appearance => '外觀';

  @override
  String get language => '語言';

  @override
  String get theme => '主題';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get themeAuto => '自動';

  @override
  String get screenOnTimeout => '螢幕常亮逾時';

  @override
  String get timeoutSystem => '系統';

  @override
  String get timeoutTriple => '3× 系統';

  @override
  String get timeoutStayOn => '保持常亮';

  @override
  String get scanning => '掃描';

  @override
  String get showMacAddress => '顯示 MAC 位址';

  @override
  String get showMacBlocked => '由於 Google 隱私限制，在 Android v.11 及以上版本停用';

  @override
  String get showMacSubtitle => '在掃描結果中顯示 MAC 欄';

  @override
  String get resolveHostnames => '解析主機名稱';

  @override
  String get resolveHostnamesSubtitle => '掃描時執行反向 DNS + mDNS';

  @override
  String get enableLogging => '啟用日誌';

  @override
  String get enableLoggingSubtitle => '將掃描與工具輸出儲存到日誌檔';

  @override
  String get account => '帳戶';

  @override
  String get logIn => '登入';

  @override
  String get comingSoon => '即將推出';

  @override
  String get settings => '設定';

  @override
  String get aboutSimplyNet => '關於 SimplyNet';

  @override
  String get scan => '掃描';

  @override
  String get logs => '日誌';

  @override
  String get networkTools => '網路工具';

  @override
  String get networkTarget => '網路目標';

  @override
  String get networkTargetHint => '例如 192.168.1.0/24';

  @override
  String get invalidCidr => '無效的 CIDR — 請使用如 192.168.1.0/24 的格式';

  @override
  String get detectMyNetwork => '偵測我的網路';

  @override
  String get toolSpeedTest => '速度測試';

  @override
  String get toolSpeedTestSub => '下載與上傳速度';

  @override
  String get toolPublicIp => '公用 IP';

  @override
  String get toolPublicIpSub => '您的 IP、ISP 與位置';

  @override
  String get toolIpCameras => 'IP 攝影機';

  @override
  String get toolIpCamerasSub => '尋找區域網路中的攝影機';

  @override
  String get toolIotDevices => 'IoT 裝置';

  @override
  String get toolIotDevicesSub => 'Matter、Tasmota、Shelly 等';

  @override
  String get toolMqttSub => 'MQTT 訂閱';

  @override
  String get toolMqttSubSub => '訂閱 MQTT 主題';

  @override
  String get toolMqttPub => 'MQTT 發佈';

  @override
  String get toolMqttPubSub => '發佈到 MQTT 主題';

  @override
  String get toolPortScan => '連接埠掃描';

  @override
  String get toolPortScanSub => '任意主機的開放 TCP/UDP 連接埠';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => '帶圖表的即時 Ping';

  @override
  String get toolTraceroute => '路由追蹤';

  @override
  String get toolTracerouteSub => '到任意主機的逐跳路徑';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS、DNS 與反向查詢';

  @override
  String get toolWifiChannels => 'Wi-Fi 頻道';

  @override
  String get toolWifiChannelsSub => '2.4 與 5 GHz 干擾圖';

  @override
  String get toolCellularInfo => '行動網路資訊';

  @override
  String get toolCellularInfoSub => '訊號、基地台 ID 與基地台資料';

  @override
  String get about => '關於';

  @override
  String get close => '關閉';

  @override
  String get cancel => '取消';

  @override
  String get ok => '確定';

  @override
  String get delete => '刪除';

  @override
  String get retry => '重試';

  @override
  String get stop => '停止';

  @override
  String get clear => '清除';

  @override
  String get copy => '複製';

  @override
  String get copied => '已複製';

  @override
  String get copyIp => '複製 IP';

  @override
  String get hostHint => 'IP 位址或主機名稱';

  @override
  String get domainHostHint => '網域、IP 位址或主機名稱';

  @override
  String get go => '開始';

  @override
  String get trace => '追蹤';

  @override
  String get lookUp => '查詢';

  @override
  String get lookingUp => '查詢中…';

  @override
  String get enterHostGo => '輸入主機並點擊開始';

  @override
  String get enterHostTrace => '輸入主機並點擊追蹤';

  @override
  String get enterHostScan => '輸入主機並點擊掃描';

  @override
  String get enterDomainIp => '輸入網域、IP 或主機名稱';

  @override
  String get aboutPing => '關於 Ping';

  @override
  String get aboutTraceroute => '關於 Traceroute';

  @override
  String get aboutWhois => '關於 Who Is';

  @override
  String get aboutPortScan => '關於連接埠掃描';

  @override
  String get hiddenNode => '隱藏節點';

  @override
  String get destination => '目標';

  @override
  String get yourRouter => '你的路由器';

  @override
  String get networkHop => '網路躍點';

  @override
  String get hop => '躍點';

  @override
  String get noReply => '無回應';

  @override
  String get probingNextHop => '正在探測下一躍點…';

  @override
  String get hiddenNodeInfo =>
      '此路由器未回應我們的探測。許多 ISP、防火牆與安全裝置會故意丟棄或限制 ICMP（ping）流量，因此即使資料仍經過該躍點，它也保持匿名。\n\n這是正常現象，並不代表路由中斷。';

  @override
  String get portsLabel => '連接埠：';

  @override
  String get wellKnown => '常用';

  @override
  String get rangeLabel => '範圍';

  @override
  String get fromLabel => '從：';

  @override
  String get toLabel => '到：';

  @override
  String get protocolLabel => '通訊協定：';

  @override
  String get hideSettings => '隱藏設定';

  @override
  String get myPublicIp => '我的公用 IP';

  @override
  String get errorLabel => '錯誤';

  @override
  String get infoUnavailable => '資訊不可用。';

  @override
  String get startTest => '開始測試';

  @override
  String get download => '下載';

  @override
  String get upload => '上傳';

  @override
  String get statusReady => '就緒';

  @override
  String get statusDone => '完成';

  @override
  String get measuringPing => '正在測量 ping…';

  @override
  String get findingServer => '正在尋找伺服器…';

  @override
  String get testingDownload => '正在測試下載…';

  @override
  String get testingUpload => '正在測試上傳…';

  @override
  String get viaCloudflare => '透過 Cloudflare';

  @override
  String get viaOokla => '透過 Ookla';

  @override
  String get aboutSpeedTestTip => '關於速度測試';

  @override
  String get speedTestInfo => '速度測試資訊';

  @override
  String get previousMeasurements => '先前的測量';

  @override
  String get noMeasurements => '尚無測量。';

  @override
  String get dateTime => '日期 / 時間';

  @override
  String get switchToOokla => '切換到 Ookla？';

  @override
  String get ooklaConsentBody =>
      '切換到 Ookla 需要連線到第三方伺服器。Ookla 會收集並分享你的 IP 位址、裝置識別碼與位置資料。';

  @override
  String get decline => '拒絕';

  @override
  String get accept => '接受';

  @override
  String get clearHistoryTitle => '清除歷史記錄？';

  @override
  String get clearHistoryBody => '這將永久刪除所有測量記錄。';

  @override
  String get aboutThisScan => '關於此掃描';

  @override
  String get scanInfoBody =>
      '封鎖 ICMP（ping）的裝置不會顯示在此處。執行“IoT 裝置”或“IP 攝影機”掃描，透過其開放連接埠與服務來定位它們。\n\n在 Android 11+ 裝置上，由於 Google 的隱私限制，無法取得 MAC 位址，因此不予顯示。';

  @override
  String get stopScan => '停止掃描';

  @override
  String get reScan => '重新掃描';

  @override
  String get hostsFound => '個主機';

  @override
  String get hostname => '主機名稱';

  @override
  String get noSavedResults => '無已儲存的結果';

  @override
  String get noNetworkTarget => '未設定網路目標';

  @override
  String get tapRefreshToScan => '點擊重新整理按鈕進行掃描';

  @override
  String get setTargetHome => '在主畫面上設定目標';

  @override
  String get openInBrowser => '在瀏覽器中開啟 (HTTP)';

  @override
  String get openSsh => '開啟 SSH';

  @override
  String get couldNotOpenBrowser => '無法開啟瀏覽器';

  @override
  String get noSshApp => '找不到 SSH 應用程式。請安裝 ConnectBot 或 Termius。';

  @override
  String get deviceInfo => '裝置資訊';

  @override
  String get ipAddress => 'IP 位址';

  @override
  String get macAddress => 'MAC 位址';

  @override
  String get manufacturer => '製造商';

  @override
  String get deviceTypeLabel => '裝置類型';

  @override
  String get openPorts => '開放連接埠';

  @override
  String get stopPortScan => '停止連接埠掃描';

  @override
  String get portScanSettings => '連接埠掃描設定';

  @override
  String get reScanPorts => '重新掃描連接埠';

  @override
  String get noOpenPorts => '未找到開放連接埠。';

  @override
  String get applyRescan => '套用並重新掃描';

  @override
  String get diagnostics => '診斷';

  @override
  String get times => '次';

  @override
  String get deleteAllLogs => '刪除所有記錄';

  @override
  String get deleteAllLogsQ => '刪除所有記錄？';

  @override
  String get cannotBeUndone => '此操作無法復原。';

  @override
  String get deleteAll => '全部刪除';

  @override
  String get deleteLogQ => '刪除記錄？';

  @override
  String get noLogsYet => '尚無記錄';

  @override
  String get scanningEllipsis => '掃描中…';

  @override
  String get iotDevicesFound => '個 IoT 裝置';

  @override
  String get iotNoSaved => '無已儲存的結果。\n點擊重新整理進行掃描。';

  @override
  String get unknown => '未知';

  @override
  String get viaLabel => '透過';

  @override
  String get confDefinite => '確定';

  @override
  String get confProbable => '可能';

  @override
  String get confPossible => '或許';

  @override
  String get ipCameraScan => 'IP 攝影機掃描';

  @override
  String get camMethodProtocolPort => '協定連接埠';

  @override
  String get camMethodKnownVendor => '已知廠商';

  @override
  String get camMethodHttpFingerprint => 'HTTP 指紋';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return '掃描中… $done/$total 主機 — $n 個攝影機';
  }

  @override
  String camNoSaved(Object cidr) {
    return '無已儲存的結果 — 點擊重新整理以掃描 $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '找到 $n 個攝影機 — $cidr';
  }

  @override
  String get noCamerasFound => '未找到攝影機。';

  @override
  String get mqttSettingsTitle => 'MQTT 設定';

  @override
  String get brokerIpFqdn => '代理 IP / FQDN';

  @override
  String get searchingSubnet => '正在搜尋子網路…';

  @override
  String get brokerHint => '例如 192.168.1.10 或 broker.example.com';

  @override
  String get portLabel => '連接埠';

  @override
  String get usernameOptional => '使用者名稱（選填）';

  @override
  String get leaveEmptyOptional => '如不需要請留空';

  @override
  String get passwordOptional => '密碼（選填）';

  @override
  String get keepPassword => '儲存密碼（不建議）';

  @override
  String get keepPasswordSub => '密碼以明文形式儲存在應用程式儲存空間中。';

  @override
  String get save => '儲存';

  @override
  String get screenStaysOn => '螢幕保持常亮';

  @override
  String get screenMaySleep => '螢幕可能休眠';

  @override
  String get mqttSubscribe => 'MQTT 訂閱';

  @override
  String get mqttPublish => 'MQTT 發布';

  @override
  String get topicLabel => '主題';

  @override
  String get topicSubHint => '例如 home/sensor/# 或 home/sensor/temp';

  @override
  String get listen => '監聽';

  @override
  String get humanReadableJson => '易讀 JSON';

  @override
  String get waitingForMessages => '正在等待訊息…';

  @override
  String get enterTopicListen => '輸入主題並點擊監聽';

  @override
  String get tapListenReceive => '點擊監聽開始接收';

  @override
  String get enterTopicTapListen => '輸入主題並點擊監聽';

  @override
  String get enterTopicFirst => '請先輸入主題。';

  @override
  String get stoppedStatus => '已停止。';

  @override
  String get connectingStatus => '連線中…';

  @override
  String get reconnectingStatus => '重新連線中…';

  @override
  String listeningOn(Object topic) {
    return '正在監聽 \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return '連線失敗：$e';
  }

  @override
  String get topicPubHint => '例如 home/light/switch';

  @override
  String get messageLabel => '訊息';

  @override
  String get enterPayload => '輸入負載…';

  @override
  String get retain => '保留';

  @override
  String get retainSub => '代理為新訂閱者保留最後一則訊息。';

  @override
  String get publish => '發布';

  @override
  String get connectedEnterTopic => '已連線 — 在下方輸入主題';

  @override
  String connectedTopic(Object topic) {
    return '已連線 — 主題：\"$topic\"';
  }

  @override
  String get disconnectedStatus => '已中斷連線';

  @override
  String publishedTo(Object topic) {
    return '已發布到 \"$topic\"';
  }

  @override
  String get about5GhzChannels => '關於 5 GHz 頻道';

  @override
  String get wifiBandInfoTitle => '5 GHz 網路中的雙存取點偵測';

  @override
  String get wifiBandInfoBody =>
      '💡 長按 SSID 查看完整的存取點名稱。\n\nℹ️ 在 5 GHz 頻段上，你通常會看到每個存取點同時出現在兩個（或更多）頻道上。這是正常的。\n\n為了更快，現代路由器會把相鄰的 20 MHz 頻道黏合成一條更寬的車道——40、80 甚至 160 MHz。這稱為\"頻道綁定\"。更寬的車道能承載更多資料，就像更寬的道路能容納更多汽車一樣。\n\n透過\"動態頻道寬度\"，路由器會選擇它能用的最寬車道，並在空中變得繁忙或嘈雜時自動收窄，從而在不打擾鄰居的情況下保持高速。\n\n所以，例如一個同時出現在頻道 36 和 40 上的 5 GHz 網路，只是一個使用 40 MHz 寬綁定頻道的存取點——而不是兩個獨立的網路。';

  @override
  String get noResults => '無結果。';

  @override
  String get scanErrorPrefix => '掃描錯誤';

  @override
  String noBandNetworks(Object band) {
    return '未偵測到 $band 網路。';
  }

  @override
  String get securityLabel => '安全';

  @override
  String get qualityLabel => '品質';

  @override
  String get qExcellent => '極佳';

  @override
  String get qGood => '良好';

  @override
  String get qFair => '一般';

  @override
  String get qWeak => '較弱';

  @override
  String get qPoor => '很差';

  @override
  String get refresh => '重新整理';

  @override
  String get cellShowingDemo => '正在顯示示範資料。';

  @override
  String get noDataReturned => '裝置未回傳任何資料。';

  @override
  String get platformErrorPrefix => '平台錯誤';

  @override
  String get carrier => '電信業者';

  @override
  String get provider => '供應商';

  @override
  String get technology => '技術';

  @override
  String get roaming => '漫遊';

  @override
  String get dataState => '數據狀態';

  @override
  String get signalQuality => '訊號品質';

  @override
  String get cellTower => '基地台';

  @override
  String get cellId => '細胞 ID';

  @override
  String get bandLabel => '頻段';

  @override
  String get estDistance => '估計距離';

  @override
  String get location => '位置';

  @override
  String get coordinates => '座標';

  @override
  String get locating => '正在定位…';

  @override
  String get nearestPlace => '最近的地點';

  @override
  String get deniedByUser => '已被使用者拒絕';

  @override
  String get unavailablePrefix => '無法使用';

  @override
  String get signalStrength => '訊號強度';

  @override
  String get rsrpHint =>
      'RSRP — 參考訊號接收功率。\n\n細胞參考訊號的平均功率，以 dBm 為單位。它反映原始訊號強度。\n\n典型範圍：約 −80 dBm（極佳）到 −120 dBm（非常弱）。數值越高（越接近零）越好。';

  @override
  String get rsrqHint =>
      'RSRQ — 參考訊號接收品質。\n\n以 dB 表示的訊號品質，除強度外還考慮干擾和網路負載。\n\n典型範圍：約 −3 dB（極佳）到 −20 dB（差）。數值越高越好。';

  @override
  String get sinrHint =>
      'SINR — 訊號與干擾加雜訊比。\n\n有用訊號比干擾加背景雜訊高出多少，以 dB 表示。\n\n數值越高越好：高於約 20 dB 為極佳，約 0 dB 或以下為差。';

  @override
  String get pciHint =>
      'PCI — 實體細胞識別碼。\n\n一個數字（LTE 上為 0–503），用於在無線介面上標識服務細胞。相鄰細胞使用不同的 PCI，以便手機能夠區分它們。';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA 絕對射頻頻道號。\n\n標識裝置正在使用的確切載波頻率；它對應到特定的 LTE 頻段和頻道。';

  @override
  String get estDistHint =>
      '到基地台的估計距離。\n\n透過無線傳播模型從訊號強度（RSRP）推算而來。這只是一個非常粗略的數量級參考 — 並非精確測量。';

  @override
  String get version => '版本';

  @override
  String get sendFeedback => '傳送意見 / 改進建議';

  @override
  String get buyMeCoffee => '請我喝杯咖啡';

  @override
  String get shareAction => '分享';
}
