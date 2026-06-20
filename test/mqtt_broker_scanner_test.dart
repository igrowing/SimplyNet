import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/mqtt_broker_scanner.dart';

/// These run against RFC 5737 TEST-NET subnets (reserved, unroutable) so no
/// real LAN traffic is generated and nothing ever answers.
void main() {
  group('MqttBrokerScanner.findBroker', () {
    test('returns null for an invalid CIDR', () async {
      expect(await MqttBrokerScanner.findBroker('not-a-cidr', 1883), isNull);
    });

    test('returns null for an out-of-range port', () async {
      expect(await MqttBrokerScanner.findBroker('192.0.2.0/30', 0), isNull);
      expect(await MqttBrokerScanner.findBroker('192.0.2.0/30', 70000), isNull);
    });

    test(
      'returns null when no host on a tiny subnet answers',
      () async {
        // 192.0.2.0/30 (TEST-NET-1) expands to .1 and .2; neither answers.
        final ip = await MqttBrokerScanner.findBroker(
          '192.0.2.0/30',
          1883,
          timeout: const Duration(milliseconds: 200),
        );
        expect(ip, isNull);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );
  });
}
