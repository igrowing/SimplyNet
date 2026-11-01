/// Hostname and port signatures used to recognise IoT devices.
///
/// Seeded from field observations of real home networks. Each signature
/// carries two kinds of hostname keyword:
///
/// * `substrings` — distinctive keywords matched anywhere in the whole
///   (lower-cased) hostname, e.g. `.*tasmota.*` or `.*bk7231.*`.
/// * `tokens` — short or generic keywords matched against whole tokens of
///   the leftmost DNS label only. A token matches when it equals the keyword
///   or continues with a digit (`pi4b`, `esp32c3`), so `pi` never matches
///   `spider` and `hub` never matches `github`. Keywords of four or more
///   letters also match their plural (`lights`, `plugs2`).
library;

import 'package:flutter/foundation.dart';

/// How certain the scanner is that a host is an IoT device.
enum IotConfidence { definite, probable, possible }

/// One device category recognisable from its hostname and open ports.
@immutable
class IotSignature {
  /// Creates a signature for the category [label].
  const IotSignature({
    required this.label,
    this.substrings = const {},
    this.tokens = const {},
    this.portGatedTokens = const {},
    this.supportPorts = const {},
    this.definitePorts = const {},
  });

  /// Category shown to the user, e.g. `Raspberry Pi`.
  final String label;

  /// Distinctive keywords matched anywhere in the hostname.
  final Set<String> substrings;

  /// Generic keywords matched against whole hostname tokens.
  final Set<String> tokens;

  /// Tokens too generic to count alone; they identify the category only
  /// when one of `definitePorts` is open.
  final Set<String> portGatedTokens;

  /// Open ports that corroborate a hostname match.
  final Set<int> supportPorts;

  /// Open ports that make a hostname match definite.
  final Set<int> definitePorts;
}

/// The signature catalogue, ordered by precedence on equal evidence.
abstract final class IotSignatures {
  /// Home Assistant (often on a Raspberry Pi).
  static const homeAssistant = IotSignature(
    label: 'Home Assistant',
    substrings: {'homeassistant', 'hassio'},
    tokens: {'ha'},
    portGatedTokens: {'home', 'pi', 'raspi', 'raspberrypi'},
    supportPorts: {1883, 22, 8080},
    definitePorts: {8123},
  );

  /// openHAB home automation server (OpenHABian images use this hostname).
  static const openHab = IotSignature(
    label: 'openHAB',
    substrings: {'openhab'},
    supportPorts: {8080, 8443, 9001},
  );

  /// Node-RED flow server.
  static const nodeRed = IotSignature(
    label: 'Node-RED',
    substrings: {'nodered', 'node-red'},
    definitePorts: {1880},
  );

  /// Google Home, Nest speakers and displays, Chromecast.
  static const googleHome = IotSignature(
    label: 'Google Home/Nest',
    substrings: {'google-home', 'googlehome', 'google-nest', 'chromecast'},
    tokens: {'nest'},
    supportPorts: {8008, 8009},
  );

  /// Amazon Echo / Alexa devices (default hostname `amazon-<hex>`).
  static const amazonEcho = IotSignature(
    label: 'Amazon Echo/Alexa',
    substrings: {'amazon-echo', 'echodot'},
    tokens: {'echo', 'alexa', 'amazon'},
  );

  /// Athom Homey hub.
  static const homey = IotSignature(label: 'Homey', tokens: {'homey'});

  /// Samsung SmartThings hub.
  static const smartThings = IotSignature(
    label: 'SmartThings',
    substrings: {'smartthings'},
  );

  /// Apple HomePod and HomePod mini.
  static const homePod = IotSignature(
    label: 'Apple HomePod',
    substrings: {'homepod'},
  );

  /// IKEA DIRIGERA hub and the older TRÅDFRI gateway.
  static const ikeaHub = IotSignature(
    label: 'IKEA DIRIGERA/Trådfri',
    substrings: {'dirigera', 'tradfri'},
    supportPorts: {8443},
  );

  /// Philips Hue bridge.
  static const philipsHue = IotSignature(
    label: 'Philips Hue',
    substrings: {'philipshue', 'philips-hue'},
    tokens: {'hue'},
  );

  /// Hubitat Elevation hub.
  static const hubitat = IotSignature(
    label: 'Hubitat',
    substrings: {'hubitat'},
  );

  /// Aqara Zigbee hubs.
  static const aqara = IotSignature(label: 'Aqara hub', substrings: {'aqara'});

  /// Domoticz home automation server.
  static const domoticz = IotSignature(
    label: 'Domoticz',
    substrings: {'domoticz'},
  );

  /// Shelly relays, plugs and meters (hostnames like `shellyplug-s-XXXX`).
  static const shelly = IotSignature(
    label: 'Shelly',
    substrings: {'shelly'},
    supportPorts: {80},
  );

  /// Raspberry Pi and its typical single-purpose distributions.
  static const raspberryPi = IotSignature(
    label: 'Raspberry Pi',
    substrings: {
      'raspberrypi',
      'raspi',
      'octopi',
      'octoprint',
      'motioneye',
      'homebridge',
      'pihole',
      'volumio',
    },
    tokens: {'pi', 'rpi'},
    supportPorts: {22},
  );

  /// Smart plugs (Tuya, Quectel, Matter).
  static const smartPlug = IotSignature(
    label: 'Smart plug',
    tokens: {'plug', 'matter'},
    supportPorts: {6668},
  );

  /// Tasmota firmware (usually on Espressif or Beken chips).
  static const tasmota = IotSignature(
    label: 'Tasmota',
    substrings: {'tasmota', 'sonoff'},
    tokens: {'switch', 'plug', 'light'},
    supportPorts: {80},
  );

  /// Zigbee coordinators and hubs.
  static const zigbeeHub = IotSignature(
    label: 'Zigbee hub',
    substrings: {
      'zigbee',
      'coordinator',
      'slzb',
      'conbee',
      'zigate',
      'deconz',
      'zigstar',
      'tubeszb',
      'zbbridge',
    },
    tokens: {'hub'},
  );

  /// Espressif ESP32 / ESP8266 modules.
  static const espressif = IotSignature(
    label: 'Espressif (ESP32/ESP8266)',
    substrings: {'esp32', 'esp8266', 'espressif', 'esphome'},
    tokens: {'esp'},
  );

  /// Beken BK72xx modules (common in Tuya devices, OpenBeken firmware).
  static const beken = IotSignature(
    label: 'Beken (BK72xx)',
    substrings: {'beken', 'bk7231', 'bk72', 'openbk'},
    tokens: {'bk', 'obk'},
  );

  /// Stock-firmware default hostnames: `wlan0` (Tuya/Beken SDK) and `lwip0`
  /// (the lwIP network stack of ESP, Beken and Realtek modules).
  static const stockFirmware = IotSignature(
    label: 'IoT module (stock firmware)',
    tokens: {'wlan', 'lwip'},
  );

  /// Every signature, in precedence order for ties.
  ///
  /// Brand-specific hubs precede the generic categories so that, for example,
  /// `Google-Nest-Hub` is a Google device rather than a Zigbee hub.
  static const all = <IotSignature>[
    homeAssistant,
    openHab,
    nodeRed,
    googleHome,
    amazonEcho,
    homey,
    smartThings,
    homePod,
    ikeaHub,
    philipsHue,
    hubitat,
    aqara,
    domoticz,
    shelly,
    raspberryPi,
    smartPlug,
    tasmota,
    zigbeeHub,
    espressif,
    beken,
    stockFirmware,
  ];

  /// Ports that identify an IoT service on their own, with the label used
  /// when nothing more specific is known. Generic ports (22, 80, 443, ...)
  /// are deliberately absent: they only corroborate other evidence.
  ///
  /// Matter ports (5540 operational, 20202 commissioning) are handled
  /// separately: they are conclusive and combine with any other label.
  static const identifyingPorts = <int, String>{
    1880: 'Node-RED',
    1883: 'MQTT broker',
    8883: 'MQTT broker (TLS)',
    6053: 'ESPHome',
    6668: 'Tuya device',
    8008: 'Google Cast',
    8009: 'Google Cast',
    8123: 'Home Assistant',
    49153: 'Belkin WeMo',
    55443: 'Xiaomi MiIO',
  };

  /// Identifying ports strong enough to make a host `probable` on their own
  /// (an MQTT broker is almost always a smart-home component).
  static const probablePorts = <int>{1883};

  /// TCP ports of Matter 1.3+ devices: operational and commissioning.
  static const matterPorts = <int>{5540, 20202};

  /// mDNS / DNS-SD service types that identify a smart-home device, with the
  /// label shown for each. A device announcing one of these is conclusively
  /// IoT, whatever its hostname or open ports.
  static const mdnsServices = <String, String>{
    '_matter._tcp': 'Matter device',
    '_matterc._udp': 'Matter device',
    '_esphomelib._tcp': 'ESPHome',
    '_hap._tcp': 'HomeKit accessory',
    '_home-assistant._tcp': 'Home Assistant',
    '_hue._tcp': 'Philips Hue',
    '_shelly._tcp': 'Shelly',
    '_googlecast._tcp': 'Google Cast',
    '_octoprint._tcp': 'OctoPrint',
    '_slzb-06._tcp': 'Zigbee hub',
  };

  /// The mDNS service types of Matter: operational and commissionable.
  static const matterServices = <String>{'_matter._tcp', '_matterc._udp'};
}
