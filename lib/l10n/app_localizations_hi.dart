// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get appearance => 'दिखावट';

  @override
  String get language => 'भाषा';

  @override
  String get theme => 'थीम';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get themeAuto => 'स्वतः';

  @override
  String get screenOnTimeout => 'स्क्रीन चालू टाइमआउट';

  @override
  String get timeoutSystem => 'सिस्टम';

  @override
  String get timeoutTriple => '3× सिस्टम';

  @override
  String get timeoutStayOn => 'चालू रखें';

  @override
  String get scanning => 'स्कैनिंग';

  @override
  String get showMacAddress => 'MAC पता दिखाएं';

  @override
  String get showMacBlocked =>
      'Google गोपनीयता कारणों से Android v.11 और उससे ऊपर पर अक्षम';

  @override
  String get showMacSubtitle => 'स्कैन परिणामों में MAC कॉलम दिखाएं';

  @override
  String get resolveHostnames => 'होस्टनाम हल करें';

  @override
  String get resolveHostnamesSubtitle =>
      'स्कैन के दौरान रिवर्स-DNS + mDNS करें';

  @override
  String get enableLogging => 'लॉगिंग सक्षम करें';

  @override
  String get enableLoggingSubtitle =>
      'स्कैन और टूल आउटपुट को लॉग फ़ाइलों में सहेजें';

  @override
  String get account => 'खाता';

  @override
  String get logIn => 'लॉग इन';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get aboutSimplyNet => 'SimplyNet के बारे में';

  @override
  String get scan => 'स्कैन';

  @override
  String get logs => 'लॉग';

  @override
  String get networkTools => 'नेटवर्क टूल';

  @override
  String get networkTarget => 'नेटवर्क लक्ष्य';

  @override
  String get networkTargetHint => 'उदा. 192.168.1.0/24';

  @override
  String get invalidCidr =>
      'अमान्य CIDR — 192.168.1.0/24 जैसे प्रारूप का उपयोग करें';

  @override
  String get detectMyNetwork => 'मेरा नेटवर्क पहचानें';

  @override
  String get toolSpeedTest => 'स्पीड टेस्ट';

  @override
  String get toolSpeedTestSub => 'डाउनलोड और अपलोड गति';

  @override
  String get toolPublicIp => 'सार्वजनिक IP';

  @override
  String get toolPublicIpSub => 'आपका IP, ISP और स्थान';

  @override
  String get toolIpCameras => 'IP कैमरे';

  @override
  String get toolIpCamerasSub => 'अपने LAN पर कैमरे खोजें';

  @override
  String get toolIotDevices => 'IoT डिवाइस';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly और अन्य';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'MQTT टॉपिक की सदस्यता लें';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'MQTT टॉपिक पर प्रकाशित करें';

  @override
  String get toolPortScan => 'पोर्ट स्कैन';

  @override
  String get toolPortScanSub => 'किसी भी होस्ट पर खुले TCP/UDP पोर्ट';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'ग्राफ़ के साथ लाइव Ping';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'किसी भी होस्ट तक hop-दर-hop पथ';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS और रिवर्स लुकअप';

  @override
  String get toolWifiChannels => 'Wi-Fi चैनल';

  @override
  String get toolWifiChannelsSub => '2.4 और 5 GHz हस्तक्षेप मानचित्र';

  @override
  String get toolCellularInfo => 'सेल्युलर जानकारी';

  @override
  String get toolCellularInfoSub => 'सिग्नल, सेल ID और टावर डेटा';

  @override
  String get about => 'परिचय';

  @override
  String get close => 'बंद करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get delete => 'हटाएं';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get stop => 'रोकें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get copied => 'कॉपी किया गया';

  @override
  String get copyIp => 'IP कॉपी करें';

  @override
  String get hostHint => 'IP पता या होस्टनाम';

  @override
  String get domainHostHint => 'डोमेन, IP पता या होस्टनाम';

  @override
  String get go => 'जाएं';

  @override
  String get trace => 'ट्रेस';

  @override
  String get lookUp => 'खोजें';

  @override
  String get lookingUp => 'खोज रहे हैं…';

  @override
  String get enterHostGo => 'होस्ट दर्ज करें और जाएं दबाएं';

  @override
  String get enterHostTrace => 'होस्ट दर्ज करें और ट्रेस दबाएं';

  @override
  String get enterHostScan => 'होस्ट दर्ज करें और स्कैन टैप करें';

  @override
  String get enterDomainIp => 'डोमेन, IP या होस्टनाम दर्ज करें';

  @override
  String get aboutPing => 'Ping के बारे में';

  @override
  String get aboutTraceroute => 'Traceroute के बारे में';

  @override
  String get aboutWhois => 'Who Is के बारे में';

  @override
  String get aboutPortScan => 'पोर्ट स्कैन के बारे में';

  @override
  String get hiddenNode => 'छिपा नोड';

  @override
  String get destination => 'गंतव्य';

  @override
  String get yourRouter => 'आपका राउटर';

  @override
  String get networkHop => 'नेटवर्क हॉप';

  @override
  String get hop => 'हॉप';

  @override
  String get noReply => 'कोई उत्तर नहीं';

  @override
  String get probingNextHop => 'अगला हॉप जांच रहे हैं…';

  @override
  String get hiddenNodeInfo =>
      'इस राउटर ने हमारी जांच का उत्तर नहीं दिया। कई ISP, फ़ायरवॉल और सुरक्षा उपकरण जानबूझकर ICMP (ping) ट्रैफ़िक को गिरा देते हैं या सीमित कर देते हैं, इसलिए आपका डेटा गुज़रने के बावजूद यह हॉप गुमनाम रहता है।\n\nयह सामान्य है और इसका मतलब यह नहीं कि मार्ग टूटा हुआ है।';

  @override
  String get portsLabel => 'पोर्ट:';

  @override
  String get wellKnown => 'प्रसिद्ध';

  @override
  String get rangeLabel => 'श्रेणी';

  @override
  String get fromLabel => 'से:';

  @override
  String get toLabel => 'तक:';

  @override
  String get protocolLabel => 'प्रोटोकॉल:';

  @override
  String get hideSettings => 'सेटिंग्स छिपाएं';

  @override
  String get myPublicIp => 'मेरा सार्वजनिक IP';

  @override
  String get errorLabel => 'त्रुटि';

  @override
  String get infoUnavailable => 'जानकारी उपलब्ध नहीं है।';

  @override
  String get startTest => 'टेस्ट शुरू करें';

  @override
  String get download => 'डाउनलोड';

  @override
  String get upload => 'अपलोड';

  @override
  String get statusReady => 'तैयार';

  @override
  String get statusDone => 'पूर्ण';

  @override
  String get measuringPing => 'ping माप रहे हैं…';

  @override
  String get findingServer => 'सर्वर खोज रहे हैं…';

  @override
  String get testingDownload => 'डाउनलोड परीक्षण…';

  @override
  String get testingUpload => 'अपलोड परीक्षण…';

  @override
  String get viaCloudflare => 'Cloudflare के माध्यम से';

  @override
  String get viaOokla => 'Ookla के माध्यम से';

  @override
  String get aboutSpeedTestTip => 'स्पीड टेस्ट के बारे में';

  @override
  String get speedTestInfo => 'स्पीड टेस्ट जानकारी';

  @override
  String get previousMeasurements => 'पिछले माप';

  @override
  String get noMeasurements => 'अभी तक कोई माप नहीं।';

  @override
  String get dateTime => 'दिनांक / समय';

  @override
  String get switchToOokla => 'Ookla पर स्विच करें?';

  @override
  String get ooklaConsentBody =>
      'Ookla पर स्विच करने के लिए तृतीय-पक्ष सर्वरों से कनेक्ट करना आवश्यक है। Ookla आपका IP पता, डिवाइस पहचानकर्ता और स्थान डेटा एकत्र और साझा करता है।';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get clearHistoryTitle => 'इतिहास साफ़ करें?';

  @override
  String get clearHistoryBody =>
      'इससे सभी माप रिकॉर्ड स्थायी रूप से हट जाएंगे।';

  @override
  String get aboutThisScan => 'इस स्कैन के बारे में';

  @override
  String get scanInfoBody =>
      'ICMP (ping) को ब्लॉक करने वाले डिवाइस यहां नहीं दिखेंगे। उन्हें उनके खुले पोर्ट और सेवाओं के माध्यम से खोजने के लिए \'IoT डिवाइस\' या \'IP कैमरा\' स्कैन चलाएं।\n\nAndroid 11+ डिवाइस पर, Google की गोपनीयता प्रतिबंधों के कारण MAC पते प्राप्त नहीं किए जा सकते, इसलिए वे प्रदर्शित नहीं होते।';

  @override
  String get stopScan => 'स्कैन रोकें';

  @override
  String get reScan => 'फिर से स्कैन करें';

  @override
  String get hostsFound => 'होस्ट मिले';

  @override
  String get hostname => 'होस्टनाम';

  @override
  String get noSavedResults => 'कोई सहेजा गया परिणाम नहीं';

  @override
  String get noNetworkTarget => 'कोई नेटवर्क लक्ष्य सेट नहीं';

  @override
  String get tapRefreshToScan => 'स्कैन करने के लिए रीफ़्रेश बटन दबाएं';

  @override
  String get setTargetHome => 'होम स्क्रीन पर लक्ष्य सेट करें';

  @override
  String get openInBrowser => 'ब्राउज़र में खोलें (HTTP)';

  @override
  String get openSsh => 'SSH खोलें';

  @override
  String get couldNotOpenBrowser => 'ब्राउज़र नहीं खुल सका';

  @override
  String get noSshApp =>
      'कोई SSH ऐप नहीं मिला। ConnectBot या Termius इंस्टॉल करें।';

  @override
  String get deviceInfo => 'डिवाइस जानकारी';

  @override
  String get ipAddress => 'IP पता';

  @override
  String get macAddress => 'MAC पता';

  @override
  String get manufacturer => 'निर्माता';

  @override
  String get deviceTypeLabel => 'डिवाइस प्रकार';

  @override
  String get openPorts => 'खुले पोर्ट';

  @override
  String get stopPortScan => 'पोर्ट स्कैन रोकें';

  @override
  String get portScanSettings => 'पोर्ट स्कैन सेटिंग्स';

  @override
  String get reScanPorts => 'पोर्ट फिर से स्कैन करें';

  @override
  String get noOpenPorts => 'कोई खुला पोर्ट नहीं मिला।';

  @override
  String get applyRescan => 'लागू करें और फिर स्कैन करें';

  @override
  String get diagnostics => 'निदान';

  @override
  String get times => 'बार';

  @override
  String get deleteAllLogs => 'सभी लॉग हटाएं';

  @override
  String get deleteAllLogsQ => 'सभी लॉग हटाएं?';

  @override
  String get cannotBeUndone => 'इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get deleteAll => 'सभी हटाएं';

  @override
  String get deleteLogQ => 'लॉग हटाएं?';

  @override
  String get noLogsYet => 'अभी तक कोई लॉग नहीं';

  @override
  String get scanningEllipsis => 'स्कैन हो रहा है…';

  @override
  String get iotDevicesFound => 'IoT डिवाइस मिले';

  @override
  String get iotNoSaved =>
      'कोई सहेजा गया परिणाम नहीं।\nस्कैन करने के लिए रीफ़्रेश दबाएं।';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get viaLabel => 'के द्वारा';

  @override
  String get confDefinite => 'निश्चित';

  @override
  String get confProbable => 'संभावित';

  @override
  String get confPossible => 'मुमकिन';

  @override
  String get ipCameraScan => 'IP कैमरा स्कैन';

  @override
  String get camMethodProtocolPort => 'प्रोटोकॉल पोर्ट';

  @override
  String get camMethodKnownVendor => 'ज्ञात विक्रेता';

  @override
  String get camMethodHttpFingerprint => 'HTTP फ़िंगरप्रिंट';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'स्कैन हो रहा है… $done/$total होस्ट — $n कैमरे';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'कोई सहेजा गया परिणाम नहीं — $cidr स्कैन करने के लिए रीफ़्रेश दबाएं';
  }

  @override
  String camFound(Object cidr, Object n) {
    return '$n कैमरे मिले — $cidr';
  }

  @override
  String get noCamerasFound => 'कोई कैमरा नहीं मिला।';

  @override
  String get mqttSettingsTitle => 'MQTT सेटिंग्स';

  @override
  String get brokerIpFqdn => 'ब्रोकर IP / FQDN';

  @override
  String get searchingSubnet => 'सबनेट खोजा जा रहा है…';

  @override
  String get brokerHint => 'उदा. 192.168.1.10 या broker.example.com';

  @override
  String get portLabel => 'पोर्ट';

  @override
  String get usernameOptional => 'उपयोगकर्ता नाम (वैकल्पिक)';

  @override
  String get leaveEmptyOptional => 'यदि आवश्यक न हो तो खाली छोड़ें';

  @override
  String get passwordOptional => 'पासवर्ड (वैकल्पिक)';

  @override
  String get keepPassword => 'पासवर्ड रखें (अनुशंसित नहीं)';

  @override
  String get keepPasswordSub =>
      'पासवर्ड ऐप स्टोरेज में सादे टेक्स्ट में संग्रहीत होता है।';

  @override
  String get save => 'सहेजें';

  @override
  String get screenStaysOn => 'स्क्रीन चालू रहती है';

  @override
  String get screenMaySleep => 'स्क्रीन बंद हो सकती है';

  @override
  String get mqttSubscribe => 'MQTT सब्सक्राइब';

  @override
  String get mqttPublish => 'MQTT पब्लिश';

  @override
  String get topicLabel => 'टॉपिक';

  @override
  String get topicSubHint => 'उदा. home/sensor/# या home/sensor/temp';

  @override
  String get listen => 'सुनें';

  @override
  String get humanReadableJson => 'पठनीय JSON';

  @override
  String get waitingForMessages => 'संदेशों की प्रतीक्षा…';

  @override
  String get enterTopicListen => 'एक टॉपिक दर्ज करें और सुनें दबाएं';

  @override
  String get tapListenReceive => 'प्राप्त करना शुरू करने के लिए सुनें दबाएं';

  @override
  String get enterTopicTapListen => 'टॉपिक दर्ज करें और सुनें दबाएं';

  @override
  String get enterTopicFirst => 'पहले एक टॉपिक दर्ज करें।';

  @override
  String get stoppedStatus => 'रुक गया।';

  @override
  String get connectingStatus => 'कनेक्ट हो रहा है…';

  @override
  String get reconnectingStatus => 'फिर से कनेक्ट हो रहा है…';

  @override
  String listeningOn(Object topic) {
    return '\"$topic\" पर सुन रहे हैं';
  }

  @override
  String connFailed(Object e) {
    return 'कनेक्शन विफल: $e';
  }

  @override
  String get topicPubHint => 'उदा. home/light/switch';

  @override
  String get messageLabel => 'संदेश';

  @override
  String get enterPayload => 'पेलोड दर्ज करें…';

  @override
  String get retain => 'बनाए रखें';

  @override
  String get retainSub => 'ब्रोकर नए सब्सक्राइबर के लिए अंतिम संदेश रखता है।';

  @override
  String get publish => 'प्रकाशित करें';

  @override
  String get connectedEnterTopic => 'कनेक्ट हो गया — नीचे टॉपिक दर्ज करें';

  @override
  String connectedTopic(Object topic) {
    return 'कनेक्ट हो गया — टॉपिक: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'डिस्कनेक्ट हो गया';

  @override
  String publishedTo(Object topic) {
    return '\"$topic\" पर प्रकाशित';
  }

  @override
  String get about5GhzChannels => '5 GHz चैनलों के बारे में';

  @override
  String get wifiBandInfoTitle =>
      '5 GHz नेटवर्क में डुअल एक्सेस पॉइंट का पता लगाना';

  @override
  String get wifiBandInfoBody =>
      '💡 एक्सेस पॉइंट का पूरा नाम देखने के लिए SSID को दबाए रखें।\n\nℹ️ 5 GHz बैंड पर आप आमतौर पर प्रत्येक एक्सेस पॉइंट को एक साथ दो (या अधिक) चैनलों पर देखेंगे। यह सामान्य है।\n\nतेज़ चलने के लिए, आधुनिक राउटर पड़ोसी 20 MHz चैनलों को जोड़कर एक चौड़ी लेन बनाते हैं — 40, 80 या यहाँ तक कि 160 MHz। इसे \"चैनल बॉन्डिंग\" कहते हैं। चौड़ी लेन अधिक डेटा ले जाती है, जैसे चौड़ी सड़क अधिक कारें ले जाती है।\n\n\"डायनामिक चैनल चौड़ाई\" के साथ राउटर सबसे चौड़ी संभव लेन चुनता है और हवा के व्यस्त या शोरगुल वाले होने पर उसे अपने आप संकरा कर देता है, ताकि पड़ोसियों को परेशान किए बिना तेज़ बना रहे।\n\nइसलिए, उदाहरण के लिए, चैनल 36 और 40 पर दिखने वाला एक ही 5 GHz नेटवर्क सिर्फ़ एक एक्सेस पॉइंट है जो 40 MHz चौड़ा जुड़ा हुआ चैनल उपयोग कर रहा है — दो अलग नेटवर्क नहीं।';

  @override
  String get noResults => 'कोई परिणाम नहीं।';

  @override
  String get scanErrorPrefix => 'स्कैन त्रुटि';

  @override
  String noBandNetworks(Object band) {
    return 'कोई $band नेटवर्क नहीं मिला।';
  }

  @override
  String get securityLabel => 'सुरक्षा';

  @override
  String get qualityLabel => 'गुणवत्ता';

  @override
  String get qExcellent => 'उत्कृष्ट';

  @override
  String get qGood => 'अच्छा';

  @override
  String get qFair => 'ठीक-ठाक';

  @override
  String get qWeak => 'कमज़ोर';

  @override
  String get qPoor => 'खराब';

  @override
  String get refresh => 'रीफ़्रेश';

  @override
  String get cellShowingDemo => 'डेमो डेटा दिखाया जा रहा है।';

  @override
  String get noDataReturned => 'डिवाइस से कोई डेटा नहीं मिला।';

  @override
  String get platformErrorPrefix => 'प्लेटफ़ॉर्म त्रुटि';

  @override
  String get carrier => 'कैरियर';

  @override
  String get provider => 'प्रदाता';

  @override
  String get technology => 'प्रौद्योगिकी';

  @override
  String get roaming => 'रोमिंग';

  @override
  String get dataState => 'डेटा स्थिति';

  @override
  String get signalQuality => 'सिग्नल गुणवत्ता';

  @override
  String get cellTower => 'सेल टावर';

  @override
  String get cellId => 'सेल ID';

  @override
  String get bandLabel => 'बैंड';

  @override
  String get estDistance => 'अनुमानित दूरी';

  @override
  String get location => 'स्थान';

  @override
  String get coordinates => 'निर्देशांक';

  @override
  String get locating => 'स्थान का पता लगाया जा रहा है…';

  @override
  String get nearestPlace => 'निकटतम स्थान';

  @override
  String get deniedByUser => 'उपयोगकर्ता द्वारा अस्वीकृत';

  @override
  String get unavailablePrefix => 'अनुपलब्ध';

  @override
  String get signalStrength => 'सिग्नल शक्ति';

  @override
  String get rsrpHint =>
      'RSRP — रेफ़रेंस सिग्नल प्राप्त शक्ति।\n\nसेल के रेफ़रेंस सिग्नलों की औसत शक्ति, dBm में मापी जाती है। यह कच्ची सिग्नल शक्ति को दर्शाती है।\n\nसामान्य सीमा: लगभग −80 dBm (उत्कृष्ट) से −120 dBm (बहुत कमज़ोर) तक। अधिक (शून्य के करीब) बेहतर है।';

  @override
  String get rsrqHint =>
      'RSRQ — रेफ़रेंस सिग्नल प्राप्त गुणवत्ता।\n\ndB में सिग्नल गुणवत्ता, जो शक्ति के साथ-साथ हस्तक्षेप और नेटवर्क लोड को भी ध्यान में रखती है।\n\nसामान्य सीमा: लगभग −3 dB (उत्कृष्ट) से −20 dB (खराब) तक। अधिक बेहतर है।';

  @override
  String get sinrHint =>
      'SINR — सिग्नल-टू-इंटरफ़ेरेंस-प्लस-नॉइज़ अनुपात।\n\nवांछित सिग्नल हस्तक्षेप और पृष्ठभूमि शोर से कितना अधिक है, dB में।\n\nअधिक बेहतर है: ~20 dB से ऊपर उत्कृष्ट, लगभग 0 dB या उससे कम खराब है।';

  @override
  String get pciHint =>
      'PCI — भौतिक सेल ID।\n\nएक संख्या (LTE पर 0–503) जो रेडियो इंटरफ़ेस पर सेवा देने वाली सेल की पहचान करती है। पड़ोसी सेल अलग-अलग PCI उपयोग करती हैं ताकि फ़ोन उन्हें अलग कर सके।';

  @override
  String get earfcnHint =>
      'EARFCN — E-UTRA निरपेक्ष रेडियो फ़्रीक्वेंसी चैनल नंबर।\n\nडिवाइस जिस सटीक कैरियर फ़्रीक्वेंसी का उपयोग कर रहा है उसकी पहचान करता है; यह किसी विशिष्ट LTE बैंड और चैनल से मेल खाता है।';

  @override
  String get estDistHint =>
      'सेल टावर तक अनुमानित दूरी।\n\nरेडियो प्रसार मॉडल का उपयोग करके सिग्नल शक्ति (RSRP) से निकाली गई। यह केवल एक बहुत मोटा, परिमाण-क्रम का संकेत है — सटीक माप नहीं।';
}
