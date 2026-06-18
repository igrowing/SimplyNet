import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/network_scanner.dart';

void main() {
  group('NetworkScanner.detectDeviceType', () {
    test('empty manufacturer returns empty string', () {
      expect(NetworkScanner.detectDeviceType(''), '');
    });

    test('IoT chip/brand vendors map to IoT Device', () {
      for (final m in [
        'Espressif Inc.',
        'Nordic Semiconductor ASA',
        'Silicon Labs',
        'Texas Instruments',
        'STMicroelectronics',
        'Tuya Smart Inc.',
        'Shelly / Allterco Robotics',
        'Sonoff ITEAD',
        'Meross Technology',
        'Philips Hue',
        'IKEA of Sweden',
        'Belkin WeMo',
        'Xiaomi Communications',
        'Wyze Labs',
        'SmartThings',
        'Amazon Technologies',
        'Google, Inc.',
        'Raspberry Pi Foundation',
        'Arduino',
        'TP-Link Kasa',
      ]) {
        expect(NetworkScanner.detectDeviceType(m), 'IoT Device', reason: m);
      }
    });

    test('Smart TV / media vendors', () {
      for (final m in ['Samsung', 'LG Electronics', 'Vizio', 'Sony', 'Roku', 'Apple TV']) {
        expect(NetworkScanner.detectDeviceType(m), 'Smart TV', reason: m);
      }
    });

    test('Smart Home hubs', () {
      for (final m in ['Echo Dot', 'Nest Labs', 'Ring Doorbell', 'Arlo Camera Co']) {
        expect(NetworkScanner.detectDeviceType(m), 'Smart Home', reason: m);
      }
    });

    test('Printers', () {
      for (final m in ['Brother Printer', 'Xerox', 'Canon', 'HP Inc', 'Epson', 'Ricoh']) {
        expect(NetworkScanner.detectDeviceType(m), 'Printer', reason: m);
      }
    });

    test('IP cameras', () {
      for (final m in ['Generic Camera', 'Hikvision', 'Axis', 'Dahua', 'Uniview']) {
        expect(NetworkScanner.detectDeviceType(m), 'IP Camera', reason: m);
      }
    });

    test('Networking equipment', () {
      for (final m in [
        'Cisco Systems',
        'Some Router',
        'Netgear',
        'D-Link',
        'ASUSTek',
        'Ubiquiti Networks',
        'Arista',
        'Juniper',
        'Fortinet',
      ]) {
        expect(NetworkScanner.detectDeviceType(m), 'Network Device', reason: m);
      }
    });

    test('Apple and Android', () {
      expect(NetworkScanner.detectDeviceType('Apple Inc.'), 'Apple Device');
      expect(NetworkScanner.detectDeviceType('Samsung Mobile'), 'Smart TV',
          reason: 'samsung is matched as Smart TV before the mobile rule');
    });

    test('Computers / NIC chip vendors', () {
      for (final m in ['Intel Corporate', 'Realtek', 'Broadcom', 'Atheros', 'Qualcomm']) {
        expect(NetworkScanner.detectDeviceType(m), 'Computer', reason: m);
      }
    });

    test('unknown vendor returns empty string', () {
      expect(NetworkScanner.detectDeviceType('Totally Unknown Vendor LLC'), '');
    });
  });

  group('NetworkScanner.expandCidr', () {
    test('/30 yields the two usable hosts', () {
      expect(NetworkScanner.expandCidr('192.168.1.0', 30),
          ['192.168.1.1', '192.168.1.2']);
    });

    test('/29 yields six usable hosts', () {
      final hosts = NetworkScanner.expandCidr('10.0.0.0', 29);
      expect(hosts.length, 6);
      expect(hosts.first, '10.0.0.1');
      expect(hosts.last, '10.0.0.6');
    });

    test('/31 yields no usable hosts (network == broadcast - 1)', () {
      expect(NetworkScanner.expandCidr('10.0.0.0', 31), isEmpty);
    });

    test('/24 yields 254 hosts spanning the range', () {
      final hosts = NetworkScanner.expandCidr('192.168.5.0', 24);
      expect(hosts.length, 254);
      expect(hosts.first, '192.168.5.1');
      expect(hosts.last, '192.168.5.254');
    });

    test('host bits in the base address are masked off', () {
      expect(NetworkScanner.expandCidr('192.168.1.137', 30),
          ['192.168.1.137', '192.168.1.138']);
    });
  });
}
