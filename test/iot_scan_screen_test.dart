import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/providers/iot_scan_provider.dart';
import 'package:simply_net/screens/iot_scan_screen.dart';
import 'package:simply_net/services/iot_scanner.dart';

import 'support/fake_mdns_browser.dart';

/// Provider with fixed state, so the screen renders without scanning.
class _FixedIotProvider extends IotScanProvider {
  _FixedIotProvider({required this.fixedScanning, required this.fixedDevices})
    : super(mdnsBrowser: FakeMdnsBrowser());

  final bool fixedScanning;
  final List<IotDevice> fixedDevices;

  @override
  bool get scanning => fixedScanning;

  @override
  List<IotDevice> get devices => fixedDevices;

  @override
  Future<bool> shouldAutoScan() async => false;
}

IotDevice _device(String ip) => IotDevice(
  ip: ip,
  mac: 'N/A',
  vendor: '',
  protocol: 'Tasmota',
  model: '',
  openPorts: const [],
  confidence: IotConfidence.possible,
  detectionMethod: 'hostname',
);

Widget _app(IotScanProvider provider) => ChangeNotifierProvider.value(
  value: provider,
  child: MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: const IotScanScreen(cidr: '192.0.2.0/24'),
  ),
);

void main() {
  group('IotScanScreen device count line', () {
    testWidgets('shows the count after a scan has finished', (tester) async {
      await tester.pumpWidget(
        _app(
          _FixedIotProvider(
            fixedScanning: false,
            fixedDevices: [_device('192.0.2.1'), _device('192.0.2.2')],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('2 IoT device(s) found'), findsOneWidget);
    });

    testWidgets('shows the running count while scanning', (tester) async {
      await tester.pumpWidget(
        _app(
          _FixedIotProvider(
            fixedScanning: true,
            fixedDevices: [_device('192.0.2.1')],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Scanning… 1 IoT device(s) found'), findsOneWidget);
    });

    testWidgets('shows the running count when nothing is found yet', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(_FixedIotProvider(fixedScanning: true, fixedDevices: const [])),
      );
      await tester.pump();

      expect(find.text('Scanning… 0 IoT device(s) found'), findsOneWidget);
    });

    testWidgets('shows no count line when idle with no results', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(_FixedIotProvider(fixedScanning: false, fixedDevices: const [])),
      );
      await tester.pump();

      expect(find.textContaining('IoT device(s) found'), findsNothing);
      expect(find.textContaining('No saved results'), findsOneWidget);
    });
  });
}
