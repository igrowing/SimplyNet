enum AppTheme { light, dark, system }

enum AppFontSize { small, medium, large }

class AppSettings {
  final AppTheme theme;
  final bool resolveNames;
  final bool loggingEnabled;
  final bool showMac;
  final AppFontSize fontSize;

  const AppSettings({
    this.theme = AppTheme.system,
    this.resolveNames = true,
    this.loggingEnabled = true,
    this.showMac = true,
    this.fontSize = AppFontSize.medium,
  });

  AppSettings copyWith({
    AppTheme? theme,
    bool? resolveNames,
    bool? loggingEnabled,
    bool? showMac,
    AppFontSize? fontSize,
  }) =>
      AppSettings(
        theme: theme ?? this.theme,
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
