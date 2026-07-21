// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeAuto => 'Auto';

  @override
  String get screenOnTimeout => 'Screen On Timeout';

  @override
  String get timeoutSystem => 'System';

  @override
  String get timeoutTriple => '3× System';

  @override
  String get timeoutStayOn => 'Stay On';

  @override
  String get scanning => 'Scanning';

  @override
  String get showMacAddress => 'Show MAC Address';

  @override
  String get showMacBlocked =>
      'Disabled on Android v.11 and up due to Google privacy concerns';

  @override
  String get showMacSubtitle => 'Display MAC column in scan results';

  @override
  String get resolveHostnames => 'Resolve Hostnames';

  @override
  String get resolveHostnamesSubtitle =>
      'Perform reverse-DNS + mDNS during scan';

  @override
  String get enableLogging => 'Enable Logging';

  @override
  String get enableLoggingSubtitle => 'Save scan and tool output to log files';

  @override
  String get account => 'Account';

  @override
  String get logIn => 'Log In';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get settings => 'Settings';

  @override
  String get aboutSimplyNet => 'About SimplyNet';

  @override
  String get scan => 'Scan';

  @override
  String get logs => 'Logs';

  @override
  String get networkTools => 'Network Tools';

  @override
  String get networkTarget => 'Network Target';

  @override
  String get networkTargetHint => 'e.g. 192.168.1.0/24';

  @override
  String get invalidCidr => 'Invalid CIDR — use format like 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'Detect my network';

  @override
  String get toolSpeedTest => 'Speed Test';

  @override
  String get toolSpeedTestSub => 'Download & upload speed';

  @override
  String get toolPublicIp => 'Public IP';

  @override
  String get toolPublicIpSub => 'Your IP, ISP & location';

  @override
  String get toolIpCameras => 'IP Cameras';

  @override
  String get toolIpCamerasSub => 'Find cameras on your LAN';

  @override
  String get toolIotDevices => 'IoT Devices';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly & more';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'Subscribe to an MQTT topic';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'Publish to an MQTT topic';

  @override
  String get toolPortScan => 'Port Scan';

  @override
  String get toolPortScanSub => 'Open TCP/UDP ports on any host';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Live ping with graph';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'Hop-by-hop path to any host';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS & reverse lookup';

  @override
  String get toolWifiChannels => 'Wi-Fi Channels';

  @override
  String get toolWifiChannelsSub => '2.4 & 5 GHz interference map';

  @override
  String get toolCellularInfo => 'Cellular Info';

  @override
  String get toolCellularInfoSub => 'Signal, cell ID & tower data';

  @override
  String get about => 'About';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get stop => 'Stop';

  @override
  String get clear => 'Clear';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get copyIp => 'Copy IP';

  @override
  String get hostHint => 'IP address or hostname';

  @override
  String get domainHostHint => 'Domain, IP address, or hostname';

  @override
  String get go => 'Go';

  @override
  String get trace => 'Trace';

  @override
  String get lookUp => 'Look up';

  @override
  String get lookingUp => 'Looking up…';

  @override
  String get enterHostGo => 'Enter a host and press Go';

  @override
  String get enterHostTrace => 'Enter a host and press Trace';

  @override
  String get enterHostScan => 'Enter a host and tap Scan';

  @override
  String get enterDomainIp => 'Enter a domain, IP, or hostname';

  @override
  String get aboutPing => 'About Ping';

  @override
  String get aboutTraceroute => 'About Traceroute';

  @override
  String get aboutWhois => 'About Who Is';

  @override
  String get aboutPortScan => 'About Port Scan';

  @override
  String get hiddenNode => 'Hidden Node';

  @override
  String get destination => 'Destination';

  @override
  String get yourRouter => 'Your router';

  @override
  String get networkHop => 'Network Hop';

  @override
  String get hop => 'Hop';

  @override
  String get noReply => 'no reply';

  @override
  String get probingNextHop => 'Probing next hop…';

  @override
  String get hiddenNodeInfo =>
      'This router did not reply to our probes. Many ISPs, firewalls and security appliances deliberately drop or rate-limit ICMP (ping) traffic, so the hop stays anonymous even though your data still passes through it.\n\nThis is normal and does not mean the route is broken.';

  @override
  String get portsLabel => 'Ports:';

  @override
  String get wellKnown => 'Well-known';

  @override
  String get rangeLabel => 'Range';

  @override
  String get fromLabel => 'From:';

  @override
  String get toLabel => 'To:';

  @override
  String get protocolLabel => 'Protocol:';

  @override
  String get hideSettings => 'Hide settings';

  @override
  String get myPublicIp => 'My Public IP';

  @override
  String get errorLabel => 'Error';

  @override
  String get infoUnavailable => 'Information not available.';

  @override
  String get startTest => 'Start Test';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusDone => 'Done';

  @override
  String get measuringPing => 'Measuring ping…';

  @override
  String get findingServer => 'Finding server…';

  @override
  String get testingDownload => 'Testing download…';

  @override
  String get testingUpload => 'Testing upload…';

  @override
  String get viaCloudflare => 'Via Cloudflare';

  @override
  String get viaOokla => 'Via Ookla';

  @override
  String get aboutSpeedTestTip => 'About the speed test';

  @override
  String get speedTestInfo => 'Speed Test Info';

  @override
  String get previousMeasurements => 'Previous Measurements';

  @override
  String get noMeasurements => 'No measurements yet.';

  @override
  String get dateTime => 'Date / Time';

  @override
  String get switchToOokla => 'Switch to Ookla?';

  @override
  String get ooklaConsentBody =>
      'Switching to Ookla requires connecting to third-party servers. Ookla collects and shares your IP address, device identifiers, and location data.';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get clearHistoryTitle => 'Clear History?';

  @override
  String get clearHistoryBody =>
      'This will permanently delete all measurement records.';

  @override
  String get aboutThisScan => 'About this scan';

  @override
  String get scanInfoBody =>
      'Devices blocking ICMP (pings) will not appear here. Run the \'IoT Devices\' or \'IP Cameras\' scan to locate them via their open ports and services.\n\nIn Android 11+ devices, MAC addresses cannot be retrieved due to Google\'s privacy restrictions, so they are not displayed.';

  @override
  String get stopScan => 'Stop scan';

  @override
  String get reScan => 'Re-scan';

  @override
  String get hostsFound => 'host(s) found';

  @override
  String get hostname => 'Hostname';

  @override
  String get noSavedResults => 'No saved results';

  @override
  String get noNetworkTarget => 'No network target set';

  @override
  String get tapRefreshToScan => 'Tap the refresh button to scan';

  @override
  String get setTargetHome => 'Set a target on the Home screen';

  @override
  String get openInBrowser => 'Open in browser (HTTP)';

  @override
  String get openSsh => 'Open SSH';

  @override
  String get couldNotOpenBrowser => 'Could not open browser';

  @override
  String get noSshApp => 'No SSH app found. Install ConnectBot or Termius.';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get macAddress => 'MAC Address';

  @override
  String get manufacturer => 'Manufacturer';

  @override
  String get deviceTypeLabel => 'Device Type';

  @override
  String get openPorts => 'Open Ports';

  @override
  String get stopPortScan => 'Stop port scan';

  @override
  String get portScanSettings => 'Port scan settings';

  @override
  String get reScanPorts => 'Re-scan ports';

  @override
  String get noOpenPorts => 'No open ports found.';

  @override
  String get applyRescan => 'Apply & Rescan';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get times => 'times';

  @override
  String get deleteAllLogs => 'Delete all logs';

  @override
  String get deleteAllLogsQ => 'Delete all logs?';

  @override
  String get cannotBeUndone => 'This cannot be undone.';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get deleteLogQ => 'Delete log?';

  @override
  String get noLogsYet => 'No logs yet';

  @override
  String get scanningEllipsis => 'Scanning…';

  @override
  String get iotDevicesFound => 'IoT device(s) found';

  @override
  String get iotNoSaved => 'No saved results.\nTap refresh to scan.';

  @override
  String get unknown => 'Unknown';

  @override
  String get viaLabel => 'via';

  @override
  String get confDefinite => 'definite';

  @override
  String get confProbable => 'probable';

  @override
  String get confPossible => 'possible';

  @override
  String get ipCameraScan => 'IP Camera Scan';

  @override
  String get camMethodProtocolPort => 'Protocol port';

  @override
  String get camMethodKnownVendor => 'Known vendor';

  @override
  String get camMethodHttpFingerprint => 'HTTP fingerprint';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'Scanning… $done/$total hosts — $n camera(s)';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'No saved results — tap refresh to scan $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n camera(s) found — $cidr';
  }

  @override
  String get noCamerasFound => 'No cameras found.';

  @override
  String get mqttSettingsTitle => 'MQTT Settings';

  @override
  String get brokerIpFqdn => 'Broker IP / FQDN';

  @override
  String get searchingSubnet => 'Searching subnet…';

  @override
  String get brokerHint => 'e.g. 192.168.1.10 or broker.example.com';

  @override
  String get portLabel => 'Port';

  @override
  String get usernameOptional => 'Username (optional)';

  @override
  String get leaveEmptyOptional => 'leave empty if not required';

  @override
  String get passwordOptional => 'Password (optional)';

  @override
  String get keepPassword => 'Keep password (not recommended)';

  @override
  String get keepPasswordSub =>
      'Password is stored in plain text in app storage.';

  @override
  String get save => 'Save';

  @override
  String get screenStaysOn => 'Screen stays on';

  @override
  String get screenMaySleep => 'Screen may sleep';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'Topic';

  @override
  String get topicSubHint => 'e.g. home/sensor/# or home/sensor/temp';

  @override
  String get listen => 'Listen';

  @override
  String get humanReadableJson => 'Human-readable JSON';

  @override
  String get waitingForMessages => 'Waiting for messages…';

  @override
  String get enterTopicListen => 'Enter a topic and tap Listen';

  @override
  String get tapListenReceive => 'Tap Listen to start receiving';

  @override
  String get enterTopicTapListen => 'Enter the topic and tap Listen';

  @override
  String get enterTopicFirst => 'Enter a topic first.';

  @override
  String get stoppedStatus => 'Stopped.';

  @override
  String get connectingStatus => 'Connecting…';

  @override
  String get reconnectingStatus => 'Reconnecting…';

  @override
  String listeningOn(Object topic) {
    return 'Listening on \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'Connection failed: $e';
  }

  @override
  String get topicPubHint => 'e.g. home/light/switch';

  @override
  String get messageLabel => 'Message';

  @override
  String get enterPayload => 'Enter payload…';

  @override
  String get retain => 'Retain';

  @override
  String get retainSub => 'Broker keeps the last message for new subscribers.';

  @override
  String get publish => 'Publish';

  @override
  String get connectedEnterTopic => 'Connected — enter a topic below';

  @override
  String connectedTopic(Object topic) {
    return 'Connected — topic: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'Disconnected';

  @override
  String publishedTo(Object topic) {
    return 'Published to \"$topic\"';
  }

  @override
  String get about5GhzChannels => 'About 5 GHz channels';

  @override
  String get wifiBandInfoTitle =>
      'Dual access point detection in 5 GHz network';

  @override
  String get wifiBandInfoBody =>
      '💡 Hold SSID to see full Access Point name.\n\nℹ️ On the 5 GHz band you will usually see each access point appear on two (or more) channels at once. That is normal.\n\nTo go faster, modern routers glue neighbouring 20 MHz channels together into one wider lane — 40, 80, or even 160 MHz. This is called \"channel bonding\". A wider lane carries more data, just like a wider road carries more cars.\n\nWith \"dynamic channel width\" the router picks the widest lane it can and narrows it automatically when the air gets busy or noisy, so it stays fast without stepping on the neighbours.\n\nSo a single 5 GHz network showing on channels 36 and 40, for example, is just one access point using an 40 MHz-wide bonded channel — not two separate networks.';

  @override
  String get noResults => 'No results.';

  @override
  String get scanErrorPrefix => 'Scan error';

  @override
  String noBandNetworks(Object band) {
    return 'No $band networks detected.';
  }

  @override
  String get securityLabel => 'Security';

  @override
  String get qualityLabel => 'Quality';

  @override
  String get qExcellent => 'Excellent';

  @override
  String get qGood => 'Good';

  @override
  String get qFair => 'Fair';

  @override
  String get qWeak => 'Weak';

  @override
  String get qPoor => 'Poor';

  @override
  String get refresh => 'Refresh';

  @override
  String get cellShowingDemo => 'Showing demo data.';

  @override
  String get noDataReturned => 'No data returned from device.';

  @override
  String get platformErrorPrefix => 'Platform error';

  @override
  String get carrier => 'Carrier';

  @override
  String get provider => 'Provider';

  @override
  String get technology => 'Technology';

  @override
  String get roaming => 'Roaming';

  @override
  String get dataState => 'Data state';

  @override
  String get signalQuality => 'Signal Quality';

  @override
  String get cellTower => 'Cell Tower';

  @override
  String get cellId => 'Cell ID';

  @override
  String get bandLabel => 'Band';

  @override
  String get estDistance => 'Est. distance';

  @override
  String get location => 'Location';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get locating => 'Locating…';

  @override
  String get nearestPlace => 'Nearest place';

  @override
  String get deniedByUser => 'Denied by the user';

  @override
  String get unavailablePrefix => 'Unavailable';

  @override
  String get signalStrength => 'Signal strength';

  @override
  String get rsrpHint =>
      'RSRP — Reference Signal Received Power.\n\nThe average power of the cell\'s reference signals, measured in dBm. It reflects raw signal strength.\n\nTypical range: about −80 dBm (excellent) down to −120 dBm (very weak). Higher (closer to zero) is better.';

  @override
  String get rsrqHint =>
      'RSRQ — Reference Signal Received Quality.\n\nSignal quality in dB, factoring in interference and network load alongside strength.\n\nTypical range: about −3 dB (excellent) down to −20 dB (poor). Higher is better.';

  @override
  String get sinrHint =>
      'SINR — Signal to Interference-plus-Noise Ratio.\n\nHow much the wanted signal exceeds interference plus background noise, in dB.\n\nHigher is better: above ~20 dB is excellent, around 0 dB or below is poor.';

  @override
  String get pciHint =>
      'PCI — Physical Cell ID.\n\nA number (0–503 on LTE) that identifies the serving cell on the radio interface. Neighbouring cells use different PCIs so the phone can tell them apart.';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA Absolute Radio Frequency Channel Number.\n\nIdentifies the exact carrier frequency the device is using; it maps to a specific LTE band and channel.';

  @override
  String get estDistHint =>
      'Estimated distance to the cell tower.\n\nDerived from signal strength (RSRP) using a radio propagation model. It is a very rough, order-of-magnitude indication only — not a precise measurement.';
}
