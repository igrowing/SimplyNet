/// Raised when mDNS discovery cannot run, e.g. the multicast socket cannot
/// be bound or the Android multicast lock is denied.
///
/// Callers treat it as "no mDNS evidence" and report [message] in the scan
/// log; it never aborts a scan.
class MdnsException implements Exception {
  /// Creates an exception with a human-readable [message].
  const MdnsException(this.message);

  /// What went wrong.
  final String message;

  @override
  String toString() => 'MdnsException: $message';
}
