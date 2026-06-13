import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/app_settings.dart';
import 'package:simply_net/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const screenChannel = MethodChannel('com.simplytools.simplynet/screen');
  final screenCalls = <MethodCall>[];

  setUp(() {
    screenCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenChannel, (call) async {
      screenCalls.add(call);
      return null;
    });
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenChannel, null);
  });

  group('SettingsProvider defaults', () {
    test('initial settings are the defaults', () {
      final p = SettingsProvider();
      expect(p.settings.theme, AppTheme.system);
      expect(p.settings.fontSize, AppFontSize.medium);
      expect(p.settings.screenTimeout, AppScreenTimeout.system);
      expect(p.settings.resolveNames, isTrue);
      expect(p.settings.loggingEnabled, isTrue);
      expect(p.settings.showMac, isTrue);
    });
  });

  group('SettingsProvider.load', () {
    test('uses defaults when prefs are empty', () async {
      final p = SettingsProvider();
      await p.load();
      expect(p.settings.theme, AppTheme.system);
      expect(p.settings.fontSize, AppFontSize.medium);
    });

    test('reads persisted values', () async {
      SharedPreferences.setMockInitialValues({
        'theme': AppTheme.dark.index,
        'fontSize': AppFontSize.large.index,
        'screenTimeout': AppScreenTimeout.stayOn.index,
        'resolveNames': false,
        'loggingEnabled': false,
        'showMac': false,
      });
      final p = SettingsProvider();
      await p.load();
      expect(p.settings.theme, AppTheme.dark);
      expect(p.settings.fontSize, AppFontSize.large);
      expect(p.settings.screenTimeout, AppScreenTimeout.stayOn);
      expect(p.settings.resolveNames, isFalse);
      expect(p.settings.loggingEnabled, isFalse);
      expect(p.settings.showMac, isFalse);
    });

    test('out-of-range fontSize index falls back to medium', () async {
      SharedPreferences.setMockInitialValues({'fontSize': 999});
      final p = SettingsProvider();
      await p.load();
      expect(p.settings.fontSize, AppFontSize.medium);
    });

    test('applies the screen timeout via the platform channel', () async {
      final p = SettingsProvider();
      await p.load();
      expect(screenCalls.map((c) => c.method), contains('setScreenTimeout'));
    });

    test('falls back to default settings when a pref has the wrong type', () async {
      // A String stored under an int key makes prefs.getInt throw, exercising
      // the catch block in load().
      SharedPreferences.setMockInitialValues({'theme': 'not-an-int'});
      final p = SettingsProvider();
      await p.load();
      expect(p.settings.theme, AppTheme.system);
      expect(p.settings.fontSize, AppFontSize.medium);
    });
  });

  group('SettingsProvider setters persist and notify', () {
    test('setTheme', () async {
      final p = SettingsProvider();
      var notified = 0;
      p.addListener(() => notified++);
      await p.setTheme(AppTheme.light);
      expect(p.settings.theme, AppTheme.light);
      expect(notified, 1);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('theme'), AppTheme.light.index);
    });

    test('setFontSize', () async {
      final p = SettingsProvider();
      await p.setFontSize(AppFontSize.large);
      expect(p.settings.fontSize, AppFontSize.large);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('fontSize'), AppFontSize.large.index);
    });

    test('setShowMac', () async {
      final p = SettingsProvider();
      await p.setShowMac(false);
      expect(p.settings.showMac, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('showMac'), isFalse);
    });

    test('setResolveNames', () async {
      final p = SettingsProvider();
      await p.setResolveNames(false);
      expect(p.settings.resolveNames, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('resolveNames'), isFalse);
    });

    test('setLoggingEnabled', () async {
      final p = SettingsProvider();
      await p.setLoggingEnabled(false);
      expect(p.settings.loggingEnabled, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('loggingEnabled'), isFalse);
    });

    test('setScreenTimeout persists and invokes platform channel', () async {
      final p = SettingsProvider();
      await p.setScreenTimeout(AppScreenTimeout.stayOn);
      expect(p.settings.screenTimeout, AppScreenTimeout.stayOn);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('screenTimeout'), AppScreenTimeout.stayOn.index);
      final last = screenCalls.last;
      expect(last.method, 'setScreenTimeout');
      expect((last.arguments as Map)['mode'], AppScreenTimeout.stayOn.index);
    });
  });

  group('SettingsProvider.themeMode', () {
    test('maps AppTheme to ThemeMode', () async {
      final p = SettingsProvider();
      await p.setTheme(AppTheme.light);
      expect(p.themeMode, ThemeMode.light);
      await p.setTheme(AppTheme.dark);
      expect(p.themeMode, ThemeMode.dark);
      await p.setTheme(AppTheme.system);
      expect(p.themeMode, ThemeMode.system);
    });
  });
}
