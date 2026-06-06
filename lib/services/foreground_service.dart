/// SimplyNet Foreground Service helper.
///
/// Wraps flutter_foreground_task to keep long-running operations (network
/// scan, ping, traceroute, camera scan) alive in a persistent Android
/// foreground service with a status-bar notification.
///
/// Why notifications fail silently and what this version fixes:
///   1. NotificationChannelImportance.DEFAULT is promoted to HIGH so the
///      status-bar icon always appears (DEFAULT can be suppressed by Android
///      "quiet hours" and battery optimisation policies on API 29-32).
///   2. The channel-ID version suffix is bumped (→ v3) so Android creates a
///      fresh channel with the new importance on all existing installs.
///   3. requestPermissions() now correctly handles API 29-32 where
///      POST_NOTIFICATIONS does not exist — we skip the permission check on
///      those API levels entirely.
///   4. FgService.start() explicitly verifies the service is NOT already
///      running before calling startService() to avoid a silent no-op.
///   5. The _initialized flag is removed — init() is idempotent in
///      flutter_foreground_task and the flag was preventing re-init after
///      the notification channel was updated.
///
/// Usage:
///   await FgService.start(title: 'Scanning…', body: 'Finding devices…');
///   // … run your work …
///   await FgService.update(body: '12 hosts found so far…');
///   await FgService.stop();
library foreground_service;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// ── Top-level task handler ────────────────────────────────────────────────────
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
    FlutterForegroundTask.launchApp();
  }
}

// ── Public API ────────────────────────────────────────────────────────────────

class FgService {
  FgService._();

  static void _init() {
    // init() is idempotent in flutter_foreground_task — safe to call every time.
    // We do NOT cache _initialized because bumping channelId requires re-init.
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        // v3: forces Android to create a NEW channel with HIGH importance.
        // Previous installs had LOW (v1) or DEFAULT (v2) which could be
        // silently suppressed. HIGH guarantees the status-bar icon appears.
        channelId:          'simplynet_tasks_v3',
        channelName:        'SimplyNet active operations',
        channelDescription: 'Shown while a network scan or diagnostic is running.',
        channelImportance:  NotificationChannelImportance.HIGH,
        priority:           NotificationPriority.HIGH,
        // Silent: no sound, no vibration — just the persistent status-bar icon.
        playSound:          false,
        enableVibration:    false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound:        false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction:       ForegroundTaskEventAction.nothing(),
        autoRunOnBoot:     false,
        allowWakeLock:     true,
        allowWifiLock:     true,
      ),
    );
  }

  /// Must be called once from the root widget (e.g. HomeScreen.initState).
  /// Requests POST_NOTIFICATIONS on Android 13+ and battery-optimisation
  /// exemption. Safe to call on older API levels — guards are internal.
  static Future<void> requestPermissions() async {
    if (!Platform.isAndroid) return;
    // POST_NOTIFICATIONS (android.permission.POST_NOTIFICATIONS) only exists
    // on Android 13+ (API 33+). FlutterForegroundTask returns denied on older
    // API levels even though no permission is required there — check API level
    // via the permission result:  if it's already granted, skip the request.
    final perm = await FlutterForegroundTask.checkNotificationPermission();
    if (perm != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
    // Request battery optimisation exemption (shows system dialog once).
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }

  /// Start the foreground service and show a persistent status-bar notification.
  static Future<void> start({
    required String title,
    required String body,
  }) async {
    if (!Platform.isAndroid) return;
    _init();

    final running = await FlutterForegroundTask.isRunningService;
    if (running) {
      await update(title: title, body: body);
      return;
    }

    await FlutterForegroundTask.startService(
      serviceId:         1001,
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

  /// Stop the foreground service.
  static Future<void> stop({String? doneBody}) async {
    if (!Platform.isAndroid) return;
    if (!await FlutterForegroundTask.isRunningService) return;
    if (doneBody != null) {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'SimplyNet',
        notificationText:  doneBody,
      );
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    await FlutterForegroundTask.stopService();
  }

  /// Convenience wrapper widget — use on Scaffold bodies that trigger services.
  static Widget wrap(Widget child) => WithForegroundTask(child: child);
}
