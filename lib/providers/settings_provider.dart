import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/l10n/app_languages.dart';
import 'package:simply_net/models/app_settings.dart';
import 'package:simply_net/services/network_capability_manager.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  // True on Android 11+ where the OS blocks remote MAC resolution, so the
  // "Show MAC Address" setting is forced off and locked.
  bool _macResolutionBlocked = false;
  bool get macResolutionBlocked => _macResolutionBlocked;

  // The user-selected UI language. Defaults to English.
  AppLanguage _language = AppLanguage.supported.first;
  AppLanguage get language => _language;
  Locale get locale => _language.locale;

  static const _platform = MethodChannel('com.simplytools.simplynet/screen');

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    try {
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
      );
    } catch (e) {
      _settings = const AppSettings();
    }
    _language = AppLanguage.fromTag(prefs.getString('languageTag'));
    // On Android 11+ remote MAC resolution is blocked by the OS, so the
    // setting is forced off and locked (the user can never enable it).
    _macResolutionBlocked =
        await NetworkCapabilityManager.isMacResolutionBlocked();
    if (_macResolutionBlocked && _settings.showMac) {
      _settings = _settings.copyWith(showMac: false);
      await prefs.setBool('showMac', false);
    }
    await _applyScreenTimeout(_settings.screenTimeout);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageTag', language.tag);
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
    if (_macResolutionBlocked) return; // locked off on Android 11+
    _settings = _settings.copyWith(showMac: showMac);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMac', showMac);
  }

  ThemeMode get themeMode => switch (_settings.theme) {
        AppTheme.light => ThemeMode.light,
        AppTheme.dark => ThemeMode.dark,
        AppTheme.system => ThemeMode.system,
      };
}
