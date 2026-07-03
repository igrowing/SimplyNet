
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_net/services/foreground_service.dart';
 
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
 
  // On the Linux/host test VM Platform.isAndroid is false, so each public
  // method takes its early-return guard without touching a platform channel.
  // These tests pin that contract: the API is always safe to call off-Android.
  group('FgService platform guards (non-Android)', () {
    test('start completes without starting a service', () {
      expect(FgService.start(title: 'Scan', body: 'Working…'), completes);
    });
 
    test('update completes', () {
      expect(FgService.update(body: 'progress…'), completes);
    });
 
    test('update with a title completes', () {
      expect(FgService.update(title: 'SimplyNet', body: 'x'), completes);
    });
 
    test('stop completes', () {
      expect(FgService.stop(), completes);
    });
 
    test('stop with a doneBody completes', () {
      expect(FgService.stop(doneBody: 'Scan complete'), completes);
    });
 
    test('requestPermissions completes', () {
      expect(FgService.requestPermissions(), completes);
    });
  });
 
  group('FgService.wrap', () {
    test('returns a widget wrapping its child', () {
      const child = SizedBox.shrink();
      final wrapped = FgService.wrap(child);
      expect(wrapped, isA<Widget>());
    });
  });
}
