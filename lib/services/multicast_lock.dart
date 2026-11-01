import 'package:flutter/services.dart';
import 'package:simply_net/services/mdns_exception.dart';

/// Android `WifiManager.MulticastLock`, via the `simplynet/multicast`
/// channel.
///
/// Android drops incoming multicast packets while the screen is off or the
/// Wi-Fi chip is in power-save mode unless an app holds this lock, so mDNS
/// answers would never arrive. On other platforms there is no native
/// handler and both calls are no-ops.
abstract final class MulticastLock {
  static const _channel = MethodChannel('simplynet/multicast');

  /// Acquires the lock. Returns true when the platform granted it and false
  /// where no lock exists (iOS, desktop). Throws [MdnsException] when the
  /// platform refuses.
  static Future<bool> acquire() async {
    try {
      return await _channel.invokeMethod<bool>('acquire') ?? false;
    } on MissingPluginException {
      // No native handler: not Android, so no lock is needed.
      return false;
    } on PlatformException catch (e) {
      throw MdnsException('multicast lock denied: ${e.message ?? e.code}');
    }
  }

  /// Releases the lock taken by `acquire`. Safe to call when none is held.
  static Future<void> release() async {
    try {
      await _channel.invokeMethod<void>('release');
    } on MissingPluginException {
      // No native handler: nothing was acquired.
    } on PlatformException catch (e) {
      throw MdnsException('multicast lock release failed: ${e.message}');
    }
  }
}
