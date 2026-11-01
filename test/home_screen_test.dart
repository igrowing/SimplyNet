import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/home_screen.dart';
import 'package:simply_net/screens/scan_screen.dart';

Widget _app(ScanProvider scan, Widget home) => MultiProvider(
  providers: [
    ChangeNotifierProvider<ScanProvider>.value(value: scan),
    ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
  ],
  child: MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tmp;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tmp = await Directory.systemTemp.createTemp('simplynet_home_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (call) async => tmp.path);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('HomeScreen LAN detection', () {
    testWidgets('sets the detected CIDR as the scan target', (tester) async {
      final scan = ScanProvider();
      await tester.pumpWidget(
        _app(scan, HomeScreen(detectCidr: () async => '10.1.2.0/24')),
      );
      await tester.pumpAndSettle();

      expect(scan.target, '10.1.2.0/24');
      expect(find.text('10.1.2.0/24'), findsOneWidget);
    });

    // Regression: on web detection returns null. The field showed a default
    // CIDR but the provider target stayed empty, so scanning was impossible.
    testWidgets('falls back to a valid scan target when detection fails', (
      tester,
    ) async {
      final scan = ScanProvider();
      await tester.pumpWidget(
        _app(scan, HomeScreen(detectCidr: () async => null)),
      );
      await tester.pumpAndSettle();

      expect(find.text(ScanProvider.defaultTarget), findsOneWidget);
      expect(scan.target, ScanProvider.defaultTarget);
      expect(scan.isValidTarget, isTrue);
    });

    testWidgets('Scan screen is usable after a failed detection', (
      tester,
    ) async {
      final scan = ScanProvider();
      await tester.pumpWidget(
        _app(scan, HomeScreen(detectCidr: () async => null)),
      );
      await tester.pumpAndSettle();

      // Consume the one-shot auto-scan so no real network scan starts.
      expect(await scan.shouldAutoScan(), isTrue);

      // Same provider instance the app shares between Home and Scan.
      await tester.pumpWidget(_app(scan, const ScanScreen()));
      await tester.pump();

      expect(find.text('No network target set'), findsNothing);
      final refresh = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.refresh_rounded),
      );
      expect(refresh.onPressed, isNotNull);
    });
  });
}
