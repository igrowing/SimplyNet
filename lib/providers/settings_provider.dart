import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/app_settings.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  static const _platform = MethodChannel('com.simplynet.app/screen');

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final fontSizeIndex = prefs.getInt('fontSize') ?? AppFontSize.medium.index;
      final fontSize = fontSizeIndex >= 0 && fontSizeIndex < AppFontSize.values.length
          ? AppFontSize.values[fontSizeIndex]
          : AppFontSize.medium;
      final screenTimeoutIndex = prefs.getInt('screenTimeout') ?? AppScreenTimeout.system.index;
      final screenTimeout = screenTimeoutIndex >= 0 && screenTimeoutIndex < AppScreenTimeout.values.length
          ? AppScreenTimeout.values[screenTimeoutIndex]
          : AppScreenTimeout.system;
      _settings = AppSettings(
        theme: AppTheme.values[prefs.getInt('theme') ?? AppTheme.system.index],
        screenTimeout: screenTimeout,
        resolveNames: prefs.getBool('resolveNames') ?? true,
        loggingEnabled: prefs.getBool('loggingEnabled') ?? true,
        showMac: prefs.getBool('showMac') ?? true,
        fontSize: fontSize,
      );
    } catch (e) {
      _settings = const AppSettings();
    }
    await _applyScreenTimeout(_settings.screenTimeout);
    notifyListeners();
  }

  Future<void> setTheme(AppTheme theme) async {
    _settings = _settings.copyWith(theme: theme);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', theme.index);
  }

  Future<void> setScreenTimeout(AppScreenTimeout screenTimeout) async {
    _settings = _settings.copyWith(screenTimeout: screenTimeout);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('screenTimeout', screenTimeout.index);
    await _applyScreenTimeout(screenTimeout);
  }

  Future<void> _applyScreenTimeout(AppScreenTimeout v) async {
    // keepScreenOn flag sent to native Android via MethodChannel.
    // MainActivity handles FLAG_KEEP_SCREEN_ON accordingly.
    // On iOS / other platforms this is a no-op.
    try {
      await _platform.invokeMethod('setScreenTimeout', {'mode': v.index});
    } catch (_) {
      // Platform not supported or channel not set up — ignore silently.
    }
  }

  Future<void> setResolveNames(bool resolveNames) async {
    _settings = _settings.copyWith(resolveNames: resolveNames);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('resolveNames', resolveNames);
  }

  Future<void> setLoggingEnabled(bool loggingEnabled) async {
    _settings = _settings.copyWith(loggingEnabled: loggingEnabled);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggingEnabled', loggingEnabled);
  }

  Future<void> setShowMac(bool showMac) async {
    _settings = _settings.copyWith(showMac: showMac);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMac', showMac);
  }

  Future<void> setFontSize(AppFontSize fontSize) async {
    _settings = _settings.copyWith(fontSize: fontSize);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fontSize', fontSize.index);
  }

  ThemeMode get themeMode => switch (_settings.theme) {
        AppTheme.light => ThemeMode.light,
        AppTheme.dark => ThemeMode.dark,
        AppTheme.system => ThemeMode.system,
      };
}
