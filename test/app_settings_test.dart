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
    });

    test('copyWith changes only specified fields', () {
      const s = AppSettings();
      final updated = s.copyWith(showMac: false);
      expect(updated.showMac, isFalse);
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
