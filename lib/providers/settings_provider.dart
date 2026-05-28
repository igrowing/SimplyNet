import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/app_settings.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  static const _platform = MethodChannel('com.simplynet.app/screen');

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    try {
      final fontSizeIndex = p.getInt('fontSize') ?? AppFontSize.medium.index;
      final fontSize = fontSizeIndex >= 0 && fontSizeIndex < AppFontSize.values.length
          ? AppFontSize.values[fontSizeIndex]
          : AppFontSize.medium;
      final screenTimeoutIndex = p.getInt('screenTimeout') ?? AppScreenTimeout.system.index;
      final screenTimeout = screenTimeoutIndex >= 0 && screenTimeoutIndex < AppScreenTimeout.values.length
          ? AppScreenTimeout.values[screenTimeoutIndex]
          : AppScreenTimeout.system;
      _settings = AppSettings(
        theme: AppTheme.values[p.getInt('theme') ?? AppTheme.system.index],
        screenTimeout: screenTimeout,
        resolveNames: p.getBool('resolveNames') ?? true,
        loggingEnabled: p.getBool('loggingEnabled') ?? true,
        showMac: p.getBool('showMac') ?? true,
        fontSize: fontSize,
      );
    } catch (e) {
      _settings = const AppSettings();
    }
    await _applyScreenTimeout(_settings.screenTimeout);
    notifyListeners();
  }

  Future<void> setTheme(AppTheme v) async {
    _settings = _settings.copyWith(theme: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('theme', v.index);
  }

  Future<void> setScreenTimeout(AppScreenTimeout v) async {
    _settings = _settings.copyWith(screenTimeout: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('screenTimeout', v.index);
    await _applyScreenTimeout(v);
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

  Future<void> setResolveNames(bool v) async {
    _settings = _settings.copyWith(resolveNames: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('resolveNames', v);
  }

  Future<void> setLoggingEnabled(bool v) async {
    _settings = _settings.copyWith(loggingEnabled: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('loggingEnabled', v);
  }

  Future<void> setShowMac(bool v) async {
    _settings = _settings.copyWith(showMac: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('showMac', v);
  }

  Future<void> setFontSize(AppFontSize v) async {
    _settings = _settings.copyWith(fontSize: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('fontSize', v.index);
  }

  ThemeMode get themeMode => switch (_settings.theme) {
        AppTheme.light => ThemeMode.light,
        AppTheme.dark => ThemeMode.dark,
        AppTheme.system => ThemeMode.system,
      };
}
