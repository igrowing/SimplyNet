import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/constants/iot_signatures.dart';
import 'package:simply_net/services/iot_classifier.dart';

void main() {
  IotClassification? classify(
    String hostname, {
    String mac = '',
    String vendor = '',
    List<int> ports = const [],
    String? http,
    Set<String> mdns = const {},
  }) => IotClassifier.classify(
    hostname: hostname,
    mac: mac,
    vendor: vendor,
    openPorts: ports,
    httpProtocol: http,
    mdnsServices: mdns,
  );

  group('IotClassifier.hostnameTokens', () {
    test('lower-cases and splits the leftmost label only', () {
      expect(IotClassifier.hostnameTokens('Tasmota-1A2B3C-4567.lan'), [
        'tasmota',
        '1a2b3c',
        '4567',
      ]);
    });

    test('splits on underscores', () {
      expect(IotClassifier.hostnameTokens('ESP_1A2B3C'), ['esp', '1a2b3c']);
    });

    test('empty hostname gives no tokens', () {
      expect(IotClassifier.hostnameTokens(''), isEmpty);
    });
  });

  group('IotClassifier.tokenMatches', () {
    test('exact token matches', () {
      expect(IotClassifier.tokenMatches('pi', 'pi'), isTrue);
    });

    test('keyword followed by a digit matches', () {
      expect(IotClassifier.tokenMatches('pi4b', 'pi'), isTrue);
      expect(IotClassifier.tokenMatches('esp32c3', 'esp'), isTrue);
      expect(IotClassifier.tokenMatches('bk7231n', 'bk'), isTrue);
    });

    test('keyword of 4+ letters also matches its plural', () {
      expect(IotClassifier.tokenMatches('lights', 'light'), isTrue);
      expect(IotClassifier.tokenMatches('plugs2', 'plug'), isTrue);
    });

    test('short keywords do not take a plural', () {
      expect(IotClassifier.tokenMatches('has', 'ha'), isFalse);
      expect(IotClassifier.tokenMatches('pis', 'pi'), isFalse);
    });

    test('a plural followed by letters does not match', () {
      expect(IotClassifier.tokenMatches('lightsaber', 'light'), isFalse);
    });

    test('keyword followed by a letter does not match', () {
      expect(IotClassifier.tokenMatches('pihole', 'pi'), isFalse);
      expect(IotClassifier.tokenMatches('spider', 'pi'), isFalse);
      expect(IotClassifier.tokenMatches('github', 'hub'), isFalse);
    });
  });

  group('IotClassifier.classify — signatures from the field notes', () {
    test('Raspberry Pi: octopi with SSH is probable', () {
      final c = classify('octopi', ports: [22])!;
      expect(c.label, IotSignatures.raspberryPi.label);
      expect(c.confidence, IotConfidence.probable);
    });

    test('Raspberry Pi: bare raspberrypi hostname is possible', () {
      final c = classify('raspberrypi.lan')!;
      expect(c.label, IotSignatures.raspberryPi.label);
      expect(c.confidence, IotConfidence.possible);
    });

    test('Home Assistant: raspi with port 8123 is definite', () {
      final c = classify('raspi', ports: [22, 8123])!;
      expect(c.label, IotSignatures.homeAssistant.label);
      expect(c.confidence, IotConfidence.definite);
    });

    test('Home Assistant: homeassistant hostname alone is recognised', () {
      final c = classify('homeassistant.local')!;
      expect(c.label, IotSignatures.homeAssistant.label);
    });

    test('Home Assistant: generic "home" without 8123 is not HA', () {
      expect(classify('home'), isNull);
    });

    test('Smart plug: "plug" hostname is recognised', () {
      final c = classify('plug-kitchen')!;
      expect(c.label, IotSignatures.smartPlug.label);
    });

    test('Smart plug: "matter" hostname is recognised', () {
      final c = classify('matter-1234')!;
      expect(c.label, IotSignatures.smartPlug.label);
    });

    test('Smart plug: hostname equal to the device MAC is definite', () {
      final c = classify('a4cf12aabbcc', mac: 'A4:CF:12:AA:BB:CC')!;
      expect(c.label, IotSignatures.smartPlug.label);
      expect(c.confidence, IotConfidence.definite);
    });

    test('Smart plug: MAC-as-hostname with an IoT vendor is probable', () {
      final c = classify('a4cf12aabbcc', vendor: 'Tuya Smart Inc.')!;
      expect(c.label, IotSignatures.smartPlug.label);
      expect(c.confidence, IotConfidence.probable);
      expect(c.method, contains('MAC in hostname'));
    });

    test('Smart plug: MAC-as-hostname with unknown vendor is possible', () {
      final c = classify('02aabbccddee')!;
      expect(c.label, IotSignatures.smartPlug.label);
      expect(c.confidence, IotConfidence.possible);
    });

    test('Espressif: ESP_xxxxxx hostname is recognised', () {
      final c = classify('ESP_1A2B3C')!;
      expect(c.label, IotSignatures.espressif.label);
    });

    test('Espressif: esp32 hostname with Espressif OUI is probable', () {
      final c = classify('esp32-cam', vendor: 'Espressif Inc.')!;
      expect(c.label, IotSignatures.espressif.label);
      expect(c.confidence, IotConfidence.probable);
    });

    test('Beken: bk7231n hostname is recognised', () {
      final c = classify('bk7231n-1a2b')!;
      expect(c.label, IotSignatures.beken.label);
    });

    test('Beken: OpenBeken default hostname is recognised', () {
      final c = classify('OpenBK7231N_1A2B3C4D')!;
      expect(c.label, IotSignatures.beken.label);
    });

    test('Tasmota: default tasmota hostname with no open port', () {
      final c = classify('tasmota-1A2B3C-4567')!;
      expect(c.label, IotSignatures.tasmota.label);
    });

    test('Tasmota: "switch" hostname with port 80 is probable', () {
      final c = classify('switch-hall', ports: [80])!;
      expect(c.label, IotSignatures.tasmota.label);
      expect(c.confidence, IotConfidence.probable);
    });

    test('Tasmota: Espressif hostname with port 80 is upgraded', () {
      final c = classify('esp-1a2b3c', ports: [80])!;
      expect(c.label, IotSignatures.tasmota.label);
    });

    test('Tasmota: Beken OUI with port 80 and no hostname is upgraded', () {
      final c = classify('', vendor: 'Beken Corporation', ports: [80])!;
      expect(c.label, IotSignatures.tasmota.label);
      expect(c.confidence, IotConfidence.probable);
    });

    test('Tasmota: plug + port 80 + IoT OUI is definite', () {
      final c = classify('plug-1', vendor: 'Espressif Inc.', ports: [80])!;
      expect(c.label, IotSignatures.tasmota.label);
      expect(c.confidence, IotConfidence.definite);
    });

    test('Zigbee hub: SLZB-06 hostname is recognised', () {
      final c = classify('SLZB-06')!;
      expect(c.label, IotSignatures.zigbeeHub.label);
    });

    test('Zigbee hub: conbee2 hostname is recognised', () {
      final c = classify('conbee2.lan')!;
      expect(c.label, IotSignatures.zigbeeHub.label);
    });
  });

  group('IotClassifier.classify — keyword anywhere in the hostname', () {
    for (final name in [
      'tasmota',
      'mytasmota',
      'kitchen-tasmota-2',
      'Tasmota_1A2B3C.lan',
    ]) {
      test('.*tasmota.* — "$name" → Tasmota', () {
        expect(classify(name)!.label, IotSignatures.tasmota.label);
      });
    }

    for (final name in [
      'B4DEAB12DE34',
      'dev-b4deab12de34',
      'xB4DEAB12DE34y.lan',
    ]) {
      test('.*B4DEAB12DE34.* equal to the MAC — "$name" → definite plug', () {
        final c = classify(name, mac: 'B4:DE:AB:12:DE:34')!;
        expect(c.label, IotSignatures.smartPlug.label);
        expect(c.confidence, IotConfidence.definite);
      });
    }

    test('a 12-hex run that differs from the MAC is not "equal"', () {
      final c = classify('dev-b4deab12de34', mac: 'B4:DE:AB:12:DE:35');
      expect(c?.confidence, isNot(IotConfidence.definite));
    });

    for (final name in ['bk7231n', 'OpenBK7231T_1A2B', 'mybk7231dev']) {
      test('.*bk7231.* — "$name" → Beken', () {
        expect(classify(name)!.label, IotSignatures.beken.label);
      });
    }

    for (final name in ['SLZB-06', 'slzb06m', 'my-slzb']) {
      test('.*SLZB.* — "$name" → Zigbee hub', () {
        expect(classify(name)!.label, IotSignatures.zigbeeHub.label);
      });
    }
  });

  group('IotClassifier.classify — smart home hubs and assistants', () {
    void expectLabel(
      IotSignature sig,
      List<String> hostnames, {
      List<int> ports = const [],
    }) {
      for (final name in hostnames) {
        test('"$name" → ${sig.label}', () {
          expect(classify(name, ports: ports)?.label, sig.label);
        });
      }
    }

    expectLabel(IotSignatures.openHab, [
      'openhab',
      'openhabian',
      'openhab-server.lan',
    ]);
    expectLabel(IotSignatures.nodeRed, ['nodered', 'Node-RED', 'my-nodered']);
    expectLabel(IotSignatures.googleHome, [
      'Google-Home-Mini',
      'Google-Nest-Hub',
      'Nest-Mini',
      'GoogleHome-1234',
      'Chromecast',
    ]);
    expectLabel(IotSignatures.amazonEcho, [
      'echo-dot',
      'Echo-Show-8',
      'amazon-1a2b3c4d5e6f',
      'alexa-kitchen',
    ]);
    expectLabel(IotSignatures.homey, ['homey', 'Homey-Pro', 'homey.local']);
    expectLabel(IotSignatures.smartThings, [
      'SmartThings-Hub',
      'smartthings',
      'samsung-smartthings-station',
    ]);
    expectLabel(IotSignatures.homePod, [
      'HomePod',
      'HomePod-mini',
      'Kitchen-HomePod',
    ]);
    expectLabel(IotSignatures.ikeaHub, [
      'DIRIGERA-1A2B',
      'dirigera',
      'TRADFRI-Gateway-1A2B',
    ]);
    expectLabel(IotSignatures.philipsHue, ['Philips-hue', 'philipshue', 'hue']);
    expectLabel(IotSignatures.hubitat, ['hubitat', 'Hubitat-Elevation']);
    expectLabel(IotSignatures.aqara, ['aqara-hub-m2', 'Aqara_Hub']);
    expectLabel(IotSignatures.domoticz, ['domoticz', 'domoticz-pi']);
    expectLabel(IotSignatures.shelly, [
      'shelly1-1A2B3C',
      'shellyplug-s-1A2B3C',
      'ShellyPro4PM-1A2B',
    ]);

    test('"Google-Nest-Hub" is a Google device, not a Zigbee hub', () {
      expect(
        classify('Google-Nest-Hub')!.label,
        isNot(IotSignatures.zigbeeHub.label),
      );
    });

    test('"SmartThings-Hub" is SmartThings, not a Zigbee hub', () {
      expect(
        classify('SmartThings-Hub')!.label,
        isNot(IotSignatures.zigbeeHub.label),
      );
    });

    test('Dirigera with its API port 8443 is probable', () {
      final c = classify('dirigera', ports: [8443])!;
      expect(c.label, IotSignatures.ikeaHub.label);
      expect(c.confidence, IotConfidence.probable);
    });

    test('Node-RED port 1880 with a nodered hostname is definite', () {
      final c = classify('nodered', ports: [1880])!;
      expect(c.label, IotSignatures.nodeRed.label);
      expect(c.confidence, IotConfidence.definite);
    });

    test('Node-RED port 1880 alone is recognised as possible', () {
      final c = classify('', ports: [1880])!;
      expect(c.label, 'Node-RED');
      expect(c.confidence, IotConfidence.possible);
    });

    test('Cast ports 8008/8009 alone are a possible Google Cast device', () {
      final c = classify('', ports: [8008, 8009])!;
      expect(c.label, 'Google Cast');
      expect(c.confidence, IotConfidence.possible);
    });

    test('an Amazon OUI with an Echo hostname is probable', () {
      final c = classify('echo-dot', vendor: 'Amazon Technologies Inc.')!;
      expect(c.label, IotSignatures.amazonEcho.label);
      expect(c.confidence, IotConfidence.probable);
    });

    for (final name in ['nestor-pc', 'hubert', 'amazonia', 'homepage']) {
      test('"$name" is not a hub', () {
        expect(classify(name), isNull);
      });
    }
  });

  group('IotClassifier.classify — other evidence', () {
    test('an HTTP fingerprint wins and is definite', () {
      final c = classify('esp-1a2b3c', ports: [80], http: 'WLED')!;
      expect(c.label, 'WLED');
      expect(c.confidence, IotConfidence.definite);
    });

    test('an IoT OUI alone is possible', () {
      final c = classify('', vendor: 'Tuya Smart Inc.')!;
      expect(c.confidence, IotConfidence.possible);
      expect(c.method, contains('OUI'));
    });

    test('an IoT-specific port alone is possible', () {
      final c = classify('', ports: [6668])!;
      expect(c.label, 'Tuya device');
      expect(c.confidence, IotConfidence.possible);
    });

    // Restored from the pre-classifier scanner: MQTT alone was probable.
    test('MQTT port 1883 alone is a probable MQTT broker', () {
      final c = classify('', ports: [1883])!;
      expect(c.label, 'MQTT broker');
      expect(c.confidence, IotConfidence.probable);
    });
  });

  // Restored from the pre-classifier scanner: an open TCP Matter port
  // (5540 operational, 20202 commissioning) made a device definite.
  group('IotClassifier.classify — Matter over TCP', () {
    for (final port in [5540, 20202]) {
      test('port $port alone is a definite Matter device', () {
        final c = classify('', ports: [port])!;
        expect(c.label, 'Matter device');
        expect(c.confidence, IotConfidence.definite);
      });
    }

    test('Matter port on a recognised device appends "+ Matter"', () {
      final c = classify('plug-kitchen', ports: [5540])!;
      expect(c.label, '${IotSignatures.smartPlug.label} + Matter');
      expect(c.confidence, IotConfidence.definite);
      expect(c.method, contains('Matter port'));
    });
  });

  // Hostnames from a real scan log that the first version missed.
  group('IotClassifier.classify — field log regressions', () {
    for (final name in [
      'living-lights-2016.fritz.box',
      'kitchen-lights-3924.fritz.box',
      'bedroom-lights-0172.fritz.box',
      'hall-switches-1',
    ]) {
      test('plural keyword — "$name" → Tasmota', () {
        expect(classify(name)!.label, IotSignatures.tasmota.label);
      });
    }

    test('plural keyword — "garden-plugs" → Smart plug', () {
      expect(classify('garden-plugs')!.label, IotSignatures.smartPlug.label);
    });

    test('bare "ha" hostname is a possible Home Assistant', () {
      final c = classify('ha.fritz.box')!;
      expect(c.label, IotSignatures.homeAssistant.label);
      expect(c.confidence, IotConfidence.possible);
    });

    test('"ha" with port 8123 is definite Home Assistant', () {
      final c = classify('ha.fritz.box', ports: [8123])!;
      expect(c.label, IotSignatures.homeAssistant.label);
      expect(c.confidence, IotConfidence.definite);
    });

    for (final name in ['wlan0.fritz.box', 'lwip0.fritz.box', 'WLAN0']) {
      test('stock-firmware default "$name" → IoT module', () {
        expect(classify(name)!.label, IotSignatures.stockFirmware.label);
      });
    }
  });

  // Matter and other smart-home devices announce themselves over mDNS
  // (DNS-SD); that is the reliable way to find Matter, whose own transport
  // is UDP.
  group('IotClassifier.classify — mDNS services', () {
    test('_matter._tcp alone is a definite Matter device', () {
      final c = classify('', mdns: {'_matter._tcp'})!;
      expect(c.label, 'Matter device');
      expect(c.confidence, IotConfidence.definite);
      expect(c.method, contains('mDNS _matter._tcp'));
    });

    test('_matterc._udp (commissionable) is a definite Matter device', () {
      final c = classify('', mdns: {'_matterc._udp'})!;
      expect(c.label, 'Matter device');
      expect(c.confidence, IotConfidence.definite);
      expect(c.method, contains('mDNS _matterc._udp'));
    });

    test('Matter on a recognised device appends "+ Matter"', () {
      final c = classify('plug-kitchen', mdns: {'_matter._tcp'})!;
      expect(c.label, '${IotSignatures.smartPlug.label} + Matter');
      expect(c.confidence, IotConfidence.definite);
    });

    test('Matter seen by port and by mDNS appends "+ Matter" once', () {
      final c = classify(
        'plug-kitchen',
        ports: [5540],
        mdns: {'_matter._tcp'},
      )!;
      expect(c.label, '${IotSignatures.smartPlug.label} + Matter');
      expect(c.method, contains('Matter port'));
      expect(c.method, contains('mDNS _matter._tcp'));
    });

    test('a Matter HTTP label is not suffixed again', () {
      final c = classify('', http: 'Matter device', mdns: {'_matter._tcp'})!;
      expect(c.label, 'Matter device');
    });

    test('_esphomelib._tcp is a definite ESPHome device', () {
      final c = classify('', mdns: {'_esphomelib._tcp'})!;
      expect(c.label, 'ESPHome');
      expect(c.confidence, IotConfidence.definite);
    });

    for (final (service, label) in [
      ('_hap._tcp', 'HomeKit accessory'),
      ('_home-assistant._tcp', 'Home Assistant'),
      ('_hue._tcp', 'Philips Hue'),
      ('_shelly._tcp', 'Shelly'),
      ('_googlecast._tcp', 'Google Cast'),
      ('_octoprint._tcp', 'OctoPrint'),
      ('_slzb-06._tcp', 'Zigbee hub'),
    ]) {
      test('$service → $label', () {
        final c = classify('', mdns: {service})!;
        expect(c.label, label);
        expect(c.confidence, IotConfidence.definite);
      });
    }

    test('an mDNS service label beats a hostname-only guess', () {
      final c = classify('hub-1', mdns: {'_hap._tcp'})!;
      expect(c.label, 'HomeKit accessory');
    });

    test('an HTTP fingerprint label beats the mDNS label', () {
      final c = classify('', http: 'Tasmota', mdns: {'_hap._tcp'})!;
      expect(c.label, 'Tasmota');
      expect(c.method, contains('mDNS _hap._tcp'));
    });

    test('unlisted service types are ignored', () {
      expect(classify('', mdns: {'_ipp._tcp', '_airplay._tcp'}), isNull);
    });

    test('mDNS evidence adds to an OUI signal', () {
      final c = classify(
        '',
        vendor: 'Espressif Inc.',
        mdns: {'_esphomelib._tcp'},
      )!;
      expect(c.method, allOf(contains('OUI'), contains('mDNS')));
    });
  });

  group('IotClassifier.classify — must not match', () {
    for (final name in [
      'spider',
      'iphone',
      'github-runner',
      'desktop-pc',
      'has',
      'lightsaber',
      'wlanrouter',
    ]) {
      test('"$name" is not IoT', () {
        expect(classify(name), isNull);
      });
    }

    test('SSH alone is not IoT', () {
      expect(classify('', ports: [22]), isNull);
    });

    test('generic web ports alone are not IoT', () {
      expect(classify('nas', ports: [80, 443, 8080]), isNull);
    });

    test('no evidence at all is not IoT', () {
      expect(classify(''), isNull);
    });
  });
}
