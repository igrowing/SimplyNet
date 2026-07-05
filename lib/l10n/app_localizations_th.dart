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
}
