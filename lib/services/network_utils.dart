/// Pure utility functions extracted from _HomeScreenState for testability.
/// No Flutter/Widget dependencies — safe to unit test without a widget tree.

/// Infer subnet prefix from IP address pattern when system info unavailable.
/// Heuristic: 192.168.*.* -> /24, 10.*.*.* -> /24, 172.*.*.* -> /24, etc.
int inferPrefixFromAddress(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) return 24;
  try {
    final firstOctet = int.parse(parts[0]);
    if (firstOctet == 10) return 24;
    if (firstOctet == 172) return 24;
    if (firstOctet == 192) return 24;
  } catch (_) {}
  return 24;
}

/// Returns the network address (zeroed host bits) for given IP and prefix length.
/// Example: networkAddress('192.168.1.100', 24) -> '192.168.1.0'
/// Returns [ip] unchanged on invalid input.
String networkAddress(String ip, int prefix) {
  try {
    final octets = ip.split('.').map(int.parse).toList();
    if (octets.length != 4) return ip;
    if (prefix < 0 || prefix > 32) return ip;

    final ipInt =
        (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
    final mask =
        prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final net = ipInt & mask;

    return '${(net >> 24) & 0xFF}.'
        '${(net >> 16) & 0xFF}.'
        '${(net >> 8) & 0xFF}.'
        '${net & 0xFF}';
  } catch (_) {
    return ip;
  }
}

/// Combine detectLanCidr logic from NetworkInterface results into a CIDR string.
/// Given an IP address detected on a real interface, returns the network CIDR.
/// Example: detectCidrFromAddress('192.168.1.42') -> '192.168.1.0/24'
String? cidrFromAddress(String address) {
  if (address.isEmpty) return null;
  final parts = address.split('.');
  if (parts.length != 4) return null;
  try {
    parts.forEach(int.parse); // validate all octets are numeric
  } catch (_) {
    return null;
  }
  final prefix = inferPrefixFromAddress(address);
  final network = networkAddress(address, prefix);
  return '$network/$prefix';
}
