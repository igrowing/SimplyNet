import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/models/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('default values', () {
      const s = AppSettings();
      expect(s.theme, AppTheme.system);
      expect(s.resolveNames, isTrue);
      expect(s.loggingEnabled, isTrue);
      expect(s.showMac, isTrue);
      expect(s.fontSize, AppFontSize.medium);
    });

    test('fontScale small = 0.85', () {
      const s = AppSettings(fontSize: AppFontSize.small);
      expect(s.fontScale, closeTo(0.85, 0.001));
    });

    test('fontScale medium = 1.0', () {
      const s = AppSettings(fontSize: AppFontSize.medium);
      expect(s.fontScale, closeTo(1.0, 0.001));
    });

    test('fontScale large = 1.2', () {
      const s = AppSettings(fontSize: AppFontSize.large);
      expect(s.fontScale, closeTo(1.2, 0.001));
    });

    test('copyWith changes only specified fields', () {
      const s = AppSettings();
      final updated = s.copyWith(showMac: false, fontSize: AppFontSize.large);
      expect(updated.showMac, isFalse);
      expect(updated.fontSize, AppFontSize.large);
      // unchanged
      expect(updated.theme, AppTheme.system);
      expect(updated.resolveNames, isTrue);
    });

    test('copyWith with no args returns equivalent object', () {
      const s = AppSettings(theme: AppTheme.dark, showMac: false);
      final copy = s.copyWith();
      expect(copy.theme, AppTheme.dark);
      expect(copy.showMac, isFalse);
    });
  });
}
