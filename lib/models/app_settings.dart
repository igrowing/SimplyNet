enum AppTheme { light, dark, system }

enum AppFontSize { small, medium, large }

enum AppScreenTimeout { system, triple, stayOn }

class AppSettings {
  final AppTheme theme;
  final AppScreenTimeout screenTimeout;
  final bool resolveNames;
  final bool loggingEnabled;
  final bool showMac;
  final AppFontSize fontSize;

  const AppSettings({
    this.theme = AppTheme.system,
    this.screenTimeout = AppScreenTimeout.system,
    this.resolveNames = true,
    this.loggingEnabled = true,
    this.showMac = true,
    this.fontSize = AppFontSize.medium,
  });

  AppSettings copyWith({
    AppTheme? theme,
    AppScreenTimeout? screenTimeout,
    bool? resolveNames,
    bool? loggingEnabled,
    bool? showMac,
    AppFontSize? fontSize,
  }) =>
      AppSettings(
        theme: theme ?? this.theme,
        screenTimeout: screenTimeout ?? this.screenTimeout,
        resolveNames: resolveNames ?? this.resolveNames,
        loggingEnabled: loggingEnabled ?? this.loggingEnabled,
        showMac: showMac ?? this.showMac,
        fontSize: fontSize ?? this.fontSize,
      );

  double get fontScale => switch (fontSize) {
        AppFontSize.small => 0.85,
        AppFontSize.medium => 1.0,
        AppFontSize.large => 1.2,
      };
}
