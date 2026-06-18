enum AppTheme { light, dark, system }

enum AppScreenTimeout { system, triple, stayOn }

class AppSettings {
  final AppTheme theme;
  final AppScreenTimeout screenTimeout;
  final bool resolveNames;
  final bool loggingEnabled;
  final bool showMac;

  const AppSettings({
    this.theme = AppTheme.system,
    this.screenTimeout = AppScreenTimeout.system,
    this.resolveNames = true,
    this.loggingEnabled = true,
    this.showMac = true,
  });

  AppSettings copyWith({
    AppTheme? theme,
    AppScreenTimeout? screenTimeout,
    bool? resolveNames,
    bool? loggingEnabled,
    bool? showMac,
  }) =>
      AppSettings(
        theme: theme ?? this.theme,
        screenTimeout: screenTimeout ?? this.screenTimeout,
        resolveNames: resolveNames ?? this.resolveNames,
        loggingEnabled: loggingEnabled ?? this.loggingEnabled,
        showMac: showMac ?? this.showMac,
      );
}
