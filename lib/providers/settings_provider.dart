import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/models/app_settings.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    try {
      final fontSizeIndex = p.getInt('fontSize') ?? AppFontSize.medium.index;
      // Validate that the index is within bounds
      final fontSize = fontSizeIndex >= 0 && fontSizeIndex < AppFontSize.values.length
          ? AppFontSize.values[fontSizeIndex]
          : AppFontSize.medium;
      
      _settings = AppSettings(
        theme: AppTheme.values[p.getInt('theme') ?? AppTheme.system.index],
        resolveNames: p.getBool('resolveNames') ?? true,
        loggingEnabled: p.getBool('loggingEnabled') ?? true,
        showMac: p.getBool('showMac') ?? true,
        fontSize: fontSize,
      );
    } catch (e) {
      // If loading fails, use defaults
      _settings = const AppSettings();
    }
    notifyListeners();
  }

  Future<void> setTheme(AppTheme v) async {
    _settings = _settings.copyWith(theme: v);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('theme', v.index);
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
