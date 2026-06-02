/// SimplyNet Foreground Service helper.
///
/// Wraps flutter_foreground_task to keep long-running operations (network
/// scan, ping, traceroute, camera scan) alive in a persistent Android
/// foreground service with a status-bar notification.
///
/// Usage:
///   await FgService.start(title: 'Scanning…', body: 'Finding devices…');
///   // … run your work …
///   await FgService.update(body: '12 hosts found so far…');
///   await FgService.stop();
///
/// On iOS, flutter_foreground_task silently becomes a no-op — the app
/// keeps running as long as it stays in the foreground (which is fine for
/// our use-cases since iOS doesn't support background LAN scanning anyway).
library foreground_service;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// ── Top-level task handler ────────────────────────────────────────────────────
// flutter_foreground_task requires a top-level @pragma entry point.
// SimplyNet does not run any Dart code in the isolated service process —
// the service is used only to keep the CPU awake and show the notification.
// The actual work runs on the main isolate (streams, timers, etc.).

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(_SimplyNetTaskHandler());
}

class _SimplyNetTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isNotificationPressed) async {}

  @override
  void onNotificationPressed() {
    // Bring the app to the foreground when the user taps the notification.
    FlutterForegroundTask.launchApp();
  }
}

// ── Public API ────────────────────────────────────────────────────────────────

class FgService {
  FgService._();

  static bool _initialized = false;

  static Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId:          'simplynet_tasks',
        channelName:        'SimplyNet background tasks',
        channelDescription: 'Keeps network scans and diagnostics running.',
        channelImportance:  NotificationChannelImportance.LOW,
        priority:           NotificationPriority.LOW,
        // Don't play sound for a progress notification
        playSound:          false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound:        false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot:            false,
        allowWakeLock:            true,
        allowWifiLock:            true,
      ),
    );
  }

  /// Request notification permission (Android 13+) and request battery
  /// optimisation exemption (shows system dialog once).
  static Future<void> requestPermissions() async {
    if (!Platform.isAndroid) return;
    final notifPerm = await FlutterForegroundTask.checkNotificationPermission();
    if (notifPerm != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }

  /// Start the foreground service and show a status-bar notification.
  ///
  /// [title]   — first line of the notification  e.g. "Network scan"
  /// [body]    — second line                     e.g. "Scanning 192.168.1.0/24…"
  /// [icon]    — optional Android drawable name  (defaults to app icon)
  static Future<void> start({
    required String title,
    required String body,
  }) async {
    if (!Platform.isAndroid) return;
    await _init();

    if (await FlutterForegroundTask.isRunningService) {
      await update(title: title, body: body);
      return;
    }

    await FlutterForegroundTask.startService(
      serviceId:        1001,
      notificationTitle: title,
      notificationText:  body,
      callback:          startCallback,
    );
  }

  /// Update the notification text while the service is running.
  static Future<void> update({String? title, required String body}) async {
    if (!Platform.isAndroid) return;
    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText:  body,
    );
  }

  /// Stop the foreground service. Call this when the long operation completes.
  /// [doneTitle] and [doneBody] are shown as a one-shot notification (if not null).
  static Future<void> stop({String? doneBody}) async {
    if (!Platform.isAndroid) return;
    if (!await FlutterForegroundTask.isRunningService) return;

    if (doneBody != null) {
      // Show a brief "done" update before stopping so the user sees the result.
      await FlutterForegroundTask.updateService(
        notificationTitle: 'SimplyNet',
        notificationText:  doneBody,
      );
      await Future<void>.delayed(const Duration(seconds: 3));
    }
    await FlutterForegroundTask.stopService();
  }

  /// Convenience widget wrapper: ensures the service is properly torn down
  /// when the widget tree disposes. Wrap Scaffold bodies that trigger services.
  ///
  /// Example:
  ///   return WithForegroundTask(child: ScanScreen());
  static Widget wrap(Widget child) =>
      WithForegroundTask(child: child);
}
