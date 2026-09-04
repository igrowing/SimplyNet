// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get appearance => 'ลักษณะ';

  @override
  String get language => 'ภาษา';

  @override
  String get theme => 'ธีม';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeAuto => 'อัตโนมัติ';

  @override
  String get screenOnTimeout => 'หมดเวลาเปิดหน้าจอ';

  @override
  String get timeoutSystem => 'ระบบ';

  @override
  String get timeoutTriple => '3× ระบบ';

  @override
  String get timeoutStayOn => 'เปิดตลอด';

  @override
  String get scanning => 'การสแกน';

  @override
  String get showMacAddress => 'แสดงที่อยู่ MAC';

  @override
  String get showMacBlocked =>
      'ปิดใช้งานบน Android v.11 ขึ้นไปเนื่องจากความเป็นส่วนตัวของ Google';

  @override
  String get showMacSubtitle => 'แสดงคอลัมน์ MAC ในผลการสแกน';

  @override
  String get resolveHostnames => 'แปลงชื่อโฮสต์';

  @override
  String get resolveHostnamesSubtitle => 'ทำ reverse-DNS + mDNS ระหว่างสแกน';

  @override
  String get enableLogging => 'เปิดใช้บันทึก';

  @override
  String get enableLoggingSubtitle =>
      'บันทึกผลการสแกนและเครื่องมือลงไฟล์บันทึก';

  @override
  String get account => 'บัญชี';

  @override
  String get logIn => 'เข้าสู่ระบบ';

  @override
  String get comingSoon => 'เร็ว ๆ นี้';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get aboutSimplyNet => 'เกี่ยวกับ SimplyNet';

  @override
  String get scan => 'สแกน';

  @override
  String get logs => 'บันทึก';

  @override
  String get networkTools => 'เครื่องมือเครือข่าย';

  @override
  String get networkTarget => 'เป้าหมายเครือข่าย';

  @override
  String get networkTargetHint => 'เช่น 192.168.1.0/24';

  @override
  String get invalidCidr => 'CIDR ไม่ถูกต้อง — ใช้รูปแบบเช่น 192.168.1.0/24';

  @override
  String get detectMyNetwork => 'ตรวจหาเครือข่ายของฉัน';

  @override
  String get toolSpeedTest => 'ทดสอบความเร็ว';

  @override
  String get toolSpeedTestSub => 'ความเร็วดาวน์โหลดและอัปโหลด';

  @override
  String get toolPublicIp => 'IP สาธารณะ';

  @override
  String get toolPublicIpSub => 'IP, ISP และตำแหน่งของคุณ';

  @override
  String get toolIpCameras => 'กล้อง IP';

  @override
  String get toolIpCamerasSub => 'ค้นหากล้องใน LAN ของคุณ';

  @override
  String get toolIotDevices => 'อุปกรณ์ IoT';

  @override
  String get toolIotDevicesSub => 'Matter, Tasmota, Shelly และอื่น ๆ';

  @override
  String get toolMqttSub => 'MQTT Sub';

  @override
  String get toolMqttSubSub => 'สมัครรับ MQTT topic';

  @override
  String get toolMqttPub => 'MQTT Pub';

  @override
  String get toolMqttPubSub => 'เผยแพร่ไปยัง MQTT topic';

  @override
  String get toolPortScan => 'สแกนพอร์ต';

  @override
  String get toolPortScanSub => 'พอร์ต TCP/UDP ที่เปิดบนโฮสต์ใด ๆ';

  @override
  String get toolPing => 'Ping';

  @override
  String get toolPingSub => 'Ping สดพร้อมกราฟ';

  @override
  String get toolTraceroute => 'Traceroute';

  @override
  String get toolTracerouteSub => 'เส้นทางทีละ hop ไปยังโฮสต์ใด ๆ';

  @override
  String get toolWhois => 'Who Is…';

  @override
  String get toolWhoisSub => 'WHOIS, DNS และค้นหาย้อนกลับ';

  @override
  String get toolWifiChannels => 'ช่อง Wi-Fi';

  @override
  String get toolWifiChannelsSub => 'แผนที่การรบกวน 2.4 และ 5 GHz';

  @override
  String get toolCellularInfo => 'ข้อมูลเซลลูลาร์';

  @override
  String get toolCellularInfoSub => 'สัญญาณ, cell ID และข้อมูลเสา';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get close => 'ปิด';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get ok => 'ตกลง';

  @override
  String get delete => 'ลบ';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get stop => 'หยุด';

  @override
  String get clear => 'ล้าง';

  @override
  String get copy => 'คัดลอก';

  @override
  String get copied => 'คัดลอกแล้ว';

  @override
  String get copyIp => 'คัดลอก IP';

  @override
  String get hostHint => 'ที่อยู่ IP หรือชื่อโฮสต์';

  @override
  String get domainHostHint => 'โดเมน, ที่อยู่ IP หรือชื่อโฮสต์';

  @override
  String get go => 'เริ่ม';

  @override
  String get trace => 'ติดตาม';

  @override
  String get lookUp => 'ค้นหา';

  @override
  String get lookingUp => 'กำลังค้นหา…';

  @override
  String get enterHostGo => 'ป้อนโฮสต์แล้วกดเริ่ม';

  @override
  String get enterHostTrace => 'ป้อนโฮสต์แล้วกดติดตาม';

  @override
  String get enterHostScan => 'ป้อนโฮสต์แล้วแตะสแกน';

  @override
  String get enterDomainIp => 'ป้อนโดเมน, IP หรือชื่อโฮสต์';

  @override
  String get aboutPing => 'เกี่ยวกับ Ping';

  @override
  String get aboutTraceroute => 'เกี่ยวกับ Traceroute';

  @override
  String get aboutWhois => 'เกี่ยวกับ Who Is';

  @override
  String get aboutPortScan => 'เกี่ยวกับ Port Scan';

  @override
  String get hiddenNode => 'โหนดที่ซ่อนอยู่';

  @override
  String get destination => 'ปลายทาง';

  @override
  String get yourRouter => 'เราเตอร์ของคุณ';

  @override
  String get networkHop => 'ฮ็อพเครือข่าย';

  @override
  String get hop => 'ฮ็อพ';

  @override
  String get noReply => 'ไม่มีการตอบกลับ';

  @override
  String get probingNextHop => 'กำลังตรวจฮ็อพถัดไป…';

  @override
  String get hiddenNodeInfo =>
      'เราเตอร์นี้ไม่ตอบสนองต่อการตรวจสอบของเรา ISP, ไฟร์วอลล์ และอุปกรณ์รักษาความปลอดภัยจำนวนมากจงใจทิ้งหรือจำกัดทราฟฟิก ICMP (ping) ฮ็อพจึงยังคงไม่ระบุตัวตนแม้ข้อมูลของคุณจะยังผ่านมันอยู่\n\nนี่เป็นเรื่องปกติและไม่ได้หมายความว่าเส้นทางเสียหาย';

  @override
  String get portsLabel => 'พอร์ต:';

  @override
  String get wellKnown => 'ที่รู้จัก';

  @override
  String get rangeLabel => 'ช่วง';

  @override
  String get fromLabel => 'จาก:';

  @override
  String get toLabel => 'ถึง:';

  @override
  String get protocolLabel => 'โปรโตคอล:';

  @override
  String get hideSettings => 'ซ่อนการตั้งค่า';

  @override
  String get myPublicIp => 'IP สาธารณะของฉัน';

  @override
  String get errorLabel => 'ข้อผิดพลาด';

  @override
  String get infoUnavailable => 'ไม่มีข้อมูล';

  @override
  String get startTest => 'เริ่มทดสอบ';

  @override
  String get download => 'ดาวน์โหลด';

  @override
  String get upload => 'อัปโหลด';

  @override
  String get statusReady => 'พร้อม';

  @override
  String get statusDone => 'เสร็จ';

  @override
  String get measuringPing => 'กำลังวัด ping…';

  @override
  String get findingServer => 'กำลังค้นหาเซิร์ฟเวอร์…';

  @override
  String get testingDownload => 'กำลังทดสอบดาวน์โหลด…';

  @override
  String get testingUpload => 'กำลังทดสอบอัปโหลด…';

  @override
  String get viaCloudflare => 'ผ่าน Cloudflare';

  @override
  String get viaOokla => 'ผ่าน Ookla';

  @override
  String get aboutSpeedTestTip => 'เกี่ยวกับการทดสอบความเร็ว';

  @override
  String get speedTestInfo => 'ข้อมูลการทดสอบความเร็ว';

  @override
  String get previousMeasurements => 'การวัดก่อนหน้า';

  @override
  String get noMeasurements => 'ยังไม่มีการวัด';

  @override
  String get dateTime => 'วันที่ / เวลา';

  @override
  String get switchToOokla => 'สลับไป Ookla?';

  @override
  String get ooklaConsentBody =>
      'การสลับไป Ookla ต้องเชื่อมต่อกับเซิร์ฟเวอร์บุคคลที่สาม Ookla จะเก็บและแบ่งปันที่อยู่ IP, ตัวระบุอุปกรณ์ และข้อมูลตำแหน่งของคุณ';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get accept => 'ยอมรับ';

  @override
  String get clearHistoryTitle => 'ล้างประวัติ?';

  @override
  String get clearHistoryBody =>
      'การดำเนินการนี้จะลบบันทึกการวัดทั้งหมดอย่างถาวร';

  @override
  String get aboutThisScan => 'เกี่ยวกับการสแกนนี้';

  @override
  String get scanInfoBody =>
      'อุปกรณ์ที่บล็อก ICMP (ping) จะไม่แสดงที่นี่ ให้เรียกใช้การสแกน \'อุปกรณ์ IoT\' หรือ \'กล้อง IP\' เพื่อค้นหาผ่านพอร์ตและบริการที่เปิดอยู่\n\nบนอุปกรณ์ Android 11+ จะไม่สามารถดึงที่อยู่ MAC ได้เนื่องจากข้อจำกัดด้านความเป็นส่วนตัวของ Google จึงไม่แสดง';

  @override
  String get stopScan => 'หยุดสแกน';

  @override
  String get reScan => 'สแกนใหม่';

  @override
  String get hostsFound => 'โฮสต์ที่พบ';

  @override
  String get hostname => 'ชื่อโฮสต์';

  @override
  String get noSavedResults => 'ไม่มีผลลัพธ์ที่บันทึกไว้';

  @override
  String get noNetworkTarget => 'ยังไม่ได้ตั้งเป้าหมายเครือข่าย';

  @override
  String get tapRefreshToScan => 'แตะปุ่มรีเฟรชเพื่อสแกน';

  @override
  String get setTargetHome => 'ตั้งเป้าหมายบนหน้าจอหลัก';

  @override
  String get openInBrowser => 'เปิดในเบราว์เซอร์ (HTTP)';

  @override
  String get openSsh => 'เปิด SSH';

  @override
  String get couldNotOpenBrowser => 'ไม่สามารถเปิดเบราว์เซอร์';

  @override
  String get noSshApp => 'ไม่พบแอป SSH ติดตั้ง ConnectBot หรือ Termius';

  @override
  String get deviceInfo => 'ข้อมูลอุปกรณ์';

  @override
  String get ipAddress => 'ที่อยู่ IP';

  @override
  String get macAddress => 'ที่อยู่ MAC';

  @override
  String get manufacturer => 'ผู้ผลิต';

  @override
  String get deviceTypeLabel => 'ประเภทอุปกรณ์';

  @override
  String get openPorts => 'พอร์ตที่เปิด';

  @override
  String get stopPortScan => 'หยุดสแกนพอร์ต';

  @override
  String get portScanSettings => 'การตั้งค่าสแกนพอร์ต';

  @override
  String get reScanPorts => 'สแกนพอร์ตใหม่';

  @override
  String get noOpenPorts => 'ไม่พบพอร์ตที่เปิด';

  @override
  String get applyRescan => 'ใช้และสแกนใหม่';

  @override
  String get diagnostics => 'การวินิจฉัย';

  @override
  String get times => 'ครั้ง';

  @override
  String get deleteAllLogs => 'ลบบันทึกทั้งหมด';

  @override
  String get deleteAllLogsQ => 'ลบบันทึกทั้งหมด?';

  @override
  String get cannotBeUndone => 'การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get deleteAll => 'ลบทั้งหมด';

  @override
  String get deleteLogQ => 'ลบบันทึก?';

  @override
  String get noLogsYet => 'ยังไม่มีบันทึก';

  @override
  String get scanningEllipsis => 'กำลังสแกน…';

  @override
  String get iotDevicesFound => 'อุปกรณ์ IoT ที่พบ';

  @override
  String get iotNoSaved => 'ไม่มีผลลัพธ์ที่บันทึกไว้\nแตะรีเฟรชเพื่อสแกน';

  @override
  String get unknown => 'ไม่ทราบ';

  @override
  String get viaLabel => 'ผ่าน';

  @override
  String get confDefinite => 'แน่นอน';

  @override
  String get confProbable => 'น่าจะ';

  @override
  String get confPossible => 'อาจ';

  @override
  String get ipCameraScan => 'สแกนกล้อง IP';

  @override
  String get camMethodProtocolPort => 'พอร์ตโปรโตคอล';

  @override
  String get camMethodKnownVendor => 'ผู้ผลิตที่รู้จัก';

  @override
  String get camMethodHttpFingerprint => 'ลายนิ้วมือ HTTP';

  @override
  String get camMethodWsDiscovery => 'WS-Discovery';

  @override
  String camScanningStatus(Object done, Object n, Object total) {
    return 'กำลังสแกน… $done/$total โฮสต์ — $n กล้อง';
  }

  @override
  String camNoSaved(Object cidr) {
    return 'ไม่มีผลลัพธ์ที่บันทึกไว้ — แตะรีเฟรชเพื่อสแกน $cidr';
  }

  @override
  String camFound(Object cidr, Object n) {
    return 'พบ $n กล้อง — $cidr';
  }

  @override
  String get noCamerasFound => 'ไม่พบกล้อง';

  @override
  String get mqttSettingsTitle => 'การตั้งค่า MQTT';

  @override
  String get brokerIpFqdn => 'IP / FQDN ของโบรกเกอร์';

  @override
  String get searchingSubnet => 'กำลังค้นหาซับเน็ต…';

  @override
  String get brokerHint => 'เช่น 192.168.1.10 หรือ broker.example.com';

  @override
  String get portLabel => 'พอร์ต';

  @override
  String get usernameOptional => 'ชื่อผู้ใช้ (ไม่บังคับ)';

  @override
  String get leaveEmptyOptional => 'เว้นว่างไว้หากไม่จำเป็น';

  @override
  String get passwordOptional => 'รหัสผ่าน (ไม่บังคับ)';

  @override
  String get keepPassword => 'เก็บรหัสผ่าน (ไม่แนะนำ)';

  @override
  String get keepPasswordSub =>
      'รหัสผ่านถูกจัดเก็บเป็นข้อความธรรมดาในที่จัดเก็บของแอป';

  @override
  String get save => 'บันทึก';

  @override
  String get screenStaysOn => 'หน้าจอเปิดตลอด';

  @override
  String get screenMaySleep => 'หน้าจออาจดับ';

  @override
  String get mqttSubscribe => 'MQTT Subscribe';

  @override
  String get mqttPublish => 'MQTT Publish';

  @override
  String get topicLabel => 'หัวข้อ';

  @override
  String get topicSubHint => 'เช่น home/sensor/# หรือ home/sensor/temp';

  @override
  String get listen => 'ฟัง';

  @override
  String get humanReadableJson => 'JSON ที่อ่านง่าย';

  @override
  String get waitingForMessages => 'กำลังรอข้อความ…';

  @override
  String get enterTopicListen => 'ป้อนหัวข้อแล้วแตะฟัง';

  @override
  String get tapListenReceive => 'แตะฟังเพื่อเริ่มรับ';

  @override
  String get enterTopicTapListen => 'ป้อนหัวข้อแล้วแตะฟัง';

  @override
  String get enterTopicFirst => 'กรุณาป้อนหัวข้อก่อน';

  @override
  String get stoppedStatus => 'หยุดแล้ว';

  @override
  String get connectingStatus => 'กำลังเชื่อมต่อ…';

  @override
  String get reconnectingStatus => 'กำลังเชื่อมต่อใหม่…';

  @override
  String listeningOn(Object topic) {
    return 'กำลังฟังบน \"$topic\"';
  }

  @override
  String connFailed(Object e) {
    return 'การเชื่อมต่อล้มเหลว: $e';
  }

  @override
  String get topicPubHint => 'เช่น home/light/switch';

  @override
  String get messageLabel => 'ข้อความ';

  @override
  String get enterPayload => 'ป้อนเพย์โหลด…';

  @override
  String get retain => 'เก็บไว้';

  @override
  String get retainSub => 'โบรกเกอร์เก็บข้อความล่าสุดไว้สำหรับผู้ติดตามใหม่';

  @override
  String get publish => 'เผยแพร่';

  @override
  String get connectedEnterTopic => 'เชื่อมต่อแล้ว — ป้อนหัวข้อด้านล่าง';

  @override
  String connectedTopic(Object topic) {
    return 'เชื่อมต่อแล้ว — หัวข้อ: \"$topic\"';
  }

  @override
  String get disconnectedStatus => 'ตัดการเชื่อมต่อแล้ว';

  @override
  String publishedTo(Object topic) {
    return 'เผยแพร่ไปยัง \"$topic\" แล้ว';
  }

  @override
  String get about5GhzChannels => 'เกี่ยวกับช่อง 5 GHz';

  @override
  String get wifiBandInfoTitle => 'การตรวจจับจุดเข้าใช้งานคู่ในเครือข่าย 5 GHz';

  @override
  String get wifiBandInfoBody =>
      '💡 กด SSID ค้างไว้เพื่อดูชื่อจุดเข้าใช้งานแบบเต็ม\n\nℹ️ ในย่าน 5 GHz คุณมักจะเห็นแต่ละจุดเข้าใช้งานปรากฏบนสอง (หรือมากกว่า) ช่องพร้อมกัน ซึ่งเป็นเรื่องปกติ\n\nเพื่อให้เร็วขึ้น เราเตอร์รุ่นใหม่จะรวมช่อง 20 MHz ที่อยู่ติดกันเป็นเลนที่กว้างขึ้น — 40, 80 หรือแม้แต่ 160 MHz เรียกว่า \"channel bonding\" เลนที่กว้างขึ้นรองรับข้อมูลได้มากขึ้น เช่นเดียวกับถนนที่กว้างขึ้นรองรับรถได้มากขึ้น\n\nด้วย \"ความกว้างช่องแบบไดนามิก\" เราเตอร์จะเลือกเลนที่กว้างที่สุดเท่าที่ทำได้ และแคบลงโดยอัตโนมัติเมื่ออากาศแออัดหรือมีสัญญาณรบกวน จึงยังคงเร็วโดยไม่รบกวนเพื่อนบ้าน\n\nดังนั้น เครือข่าย 5 GHz เดียวที่แสดงบนช่อง 36 และ 40 เช่น จึงเป็นเพียงจุดเข้าใช้งานเดียวที่ใช้ช่องรวมกว้าง 40 MHz — ไม่ใช่สองเครือข่ายแยกกัน';

  @override
  String get noResults => 'ไม่มีผลลัพธ์';

  @override
  String get scanErrorPrefix => 'ข้อผิดพลาดการสแกน';

  @override
  String noBandNetworks(Object band) {
    return 'ไม่พบเครือข่าย $band';
  }

  @override
  String get securityLabel => 'ความปลอดภัย';

  @override
  String get qualityLabel => 'คุณภาพ';

  @override
  String get qExcellent => 'ดีเยี่ยม';

  @override
  String get qGood => 'ดี';

  @override
  String get qFair => 'พอใช้';

  @override
  String get qWeak => 'อ่อน';

  @override
  String get qPoor => 'แย่';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get cellShowingDemo => 'กำลังแสดงข้อมูลตัวอย่าง';

  @override
  String get noDataReturned => 'อุปกรณ์ไม่ส่งข้อมูลกลับมา';

  @override
  String get platformErrorPrefix => 'ข้อผิดพลาดแพลตฟอร์ม';

  @override
  String get carrier => 'ผู้ให้บริการ';

  @override
  String get provider => 'ผู้ให้บริการ';

  @override
  String get technology => 'เทคโนโลยี';

  @override
  String get roaming => 'โรมมิ่ง';

  @override
  String get dataState => 'สถานะข้อมูล';

  @override
  String get signalQuality => 'คุณภาพสัญญาณ';

  @override
  String get cellTower => 'เสาสัญญาณ';

  @override
  String get cellId => 'รหัสเซลล์';

  @override
  String get bandLabel => 'แบนด์';

  @override
  String get estDistance => 'ระยะโดยประมาณ';

  @override
  String get location => 'ตำแหน่ง';

  @override
  String get coordinates => 'พิกัด';

  @override
  String get locating => 'กำลังระบุตำแหน่ง…';

  @override
  String get nearestPlace => 'สถานที่ใกล้ที่สุด';

  @override
  String get deniedByUser => 'ผู้ใช้ปฏิเสธ';

  @override
  String get unavailablePrefix => 'ไม่พร้อมใช้งาน';

  @override
  String get signalStrength => 'ความแรงสัญญาณ';

  @override
  String get rsrpHint =>
      'RSRP — กำลังรับสัญญาณอ้างอิง\n\nกำลังเฉลี่ยของสัญญาณอ้างอิงของเซลล์ วัดเป็น dBm สะท้อนความแรงสัญญาณดิบ\n\nช่วงปกติ: ประมาณ −80 dBm (ดีเยี่ยม) ลงไปถึง −120 dBm (อ่อนมาก) ยิ่งสูง (ใกล้ศูนย์) ยิ่งดี';

  @override
  String get rsrqHint =>
      'RSRQ — คุณภาพการรับสัญญาณอ้างอิง\n\nคุณภาพสัญญาณเป็น dB โดยคำนึงถึงการรบกวนและภาระเครือข่ายนอกเหนือจากความแรง\n\nช่วงปกติ: ประมาณ −3 dB (ดีเยี่ยม) ลงไปถึง −20 dB (แย่) ยิ่งสูงยิ่งดี';

  @override
  String get sinrHint =>
      'SINR — อัตราส่วนสัญญาณต่อการรบกวนบวกสัญญาณรบกวน\n\nสัญญาณที่ต้องการเกินการรบกวนบวกสัญญาณรบกวนพื้นหลังเท่าใด เป็น dB\n\nยิ่งสูงยิ่งดี: สูงกว่า ~20 dB ถือว่าดีเยี่ยม ราว 0 dB หรือต่ำกว่าถือว่าแย่';

  @override
  String get pciHint =>
      'PCI — รหัสเซลล์ทางกายภาพ\n\nตัวเลข (0–503 บน LTE) ที่ระบุเซลล์ที่ให้บริการบนอินเทอร์เฟซวิทยุ เซลล์ข้างเคียงใช้ PCI ต่างกันเพื่อให้โทรศัพท์แยกแยะได้';

  @override
  String get earfcnHint =>
      'EARFCN — หมายเลขช่องความถี่วิทยุสัมบูรณ์ E-UTRA\n\nระบุความถี่พาหะที่แน่นอนที่อุปกรณ์ใช้อยู่ โดยจับคู่กับแบนด์และช่อง LTE เฉพาะ';

  @override
  String get estDistHint =>
      'ระยะโดยประมาณถึงเสาสัญญาณ\n\nคำนวณจากความแรงสัญญาณ (RSRP) โดยใช้แบบจำลองการแพร่กระจายคลื่นวิทยุ เป็นเพียงการบ่งชี้แบบคร่าว ๆ ในระดับลำดับความสำคัญเท่านั้น — ไม่ใช่การวัดที่แม่นยำ';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get sendFeedback => 'ส่งความคิดเห็น / ไอเดียการปรับปรุง';

  @override
  String get buyMeCoffee => 'เลี้ยงกาแฟฉันสักแก้ว';

  @override
  String get shareAction => 'แชร์';
}
