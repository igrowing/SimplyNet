import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:network_discovery/network_discovery.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _ctrl;
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  bool _detecting = false;

  @override
  void initState() {
    super.initState();
    final prov = context.read<ScanProvider>();
    _ctrl = TextEditingController(text: prov.target);
    // Auto-detect on first open
    WidgetsBinding.instance.addPostFrameCallback((_) => _detect());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _detect() async {
    if (_detecting) return;
    setState(() => _detecting = true);
    try {
      final cidr = await _detectLanCidr();
      if (cidr != null && mounted) {
        context.read<ScanProvider>().setTarget(cidr);
        _ctrl.text = cidr;
        setState(() => _hasError = false);
      } else {
        _ctrl.text = '192.168.178.0/24';
      }
    } finally {
      if (mounted) setState(() => _detecting = false);
    }
    // final String deviceIP = await NetworkDiscovery.discoverDeviceIpAddress();
    // if(deviceIP.isNotEmpty){
    //   print(deviceIP);
    //   // Can use to get subnet from IP Address
    //   final String subnet = deviceIP.substring(0, deviceIP.lastIndexOf('.'));
    // }else{
    //     print("Couldn't get IP Address");
    // }
  }

  /// Detect LAN CIDR from current network interface (cross-platform).
  /// Works on Android, iOS, Windows, macOS, Linux.
  /// On Web: NetworkInterface API is unavailable (browser security), returns null.
  Future<String?> _detectLanCidr() async {
    // NetworkInterface is not available on web (browser security restriction)
    if (kIsWeb) {
      debugPrint('Network detection skipped: not available on web browsers');
      return null;
    }

    try {
      // Get all IPv4 network interfaces
      final ifaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );

      for (final iface in ifaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && addr.address.isNotEmpty) {
            // Infer subnet prefix from IP address pattern
            int prefix = _inferPrefixFromAddress(addr.address);
            final network = _networkAddress(addr.address, prefix);
            debugPrint(
              'Detected interface "${iface.name}": ${addr.address}/$prefix',
            );
            return '$network/$prefix';
          }
        }
      }
    } catch (e) {
      debugPrint('Network detection failed: $e');
    }
    return null;
  }

  /// Infer prefix from IP address pattern when system info unavailable.
  /// This is a heuristic: 192.168.*.* -> /24, 10.*.*.* -> /24, etc.
  int _inferPrefixFromAddress(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return 24;

    try {
      final firstOctet = int.parse(parts[0]);

      // Common private network patterns
      if (firstOctet == 10) return 24; // 10.0.0.0/8 typically used as /24
      if (firstOctet == 172) return 24; // 172.16.0.0/12 typically used as /24
      if (firstOctet == 192) return 24; // 192.168.0.0/16 typically used as /24
    } catch (_) {}

    return 24; // Safe default
  }

  /// Returns the network address (zeroed host bits) for given IP and prefix length.
  /// Example: _networkAddress('192.168.1.100', 24) -> '192.168.1.0'
  String _networkAddress(String ip, int prefix) {
    try {
      final octets = ip.split('.').map(int.parse).toList();
      if (octets.length != 4) {
        debugPrint('Invalid IP format: $ip');
        return ip;
      }

      if (prefix < 0 || prefix > 32) {
        debugPrint('Invalid prefix length: $prefix');
        return ip;
      }

      // Convert IP to 32-bit integer
      final ipInt =
          (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];

      // Create netmask by shifting left by (32 - prefix) and AND'ing
      final mask = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;

      // Apply mask to get network address
      final net = ipInt & mask;

      // Convert back to dotted-decimal notation
      final result =
          '${(net >> 24) & 0xFF}.'
          '${(net >> 16) & 0xFF}.'
          '${(net >> 8) & 0xFF}.'
          '${net & 0xFF}';
      return result;
    } catch (e) {
      debugPrint('Error calculating network address for $ip/$prefix: $e');
      return ip;
    }
  }

  void _onChanged(String v) {
    context.read<ScanProvider>().setTarget(v);
    setState(() => _hasError = v.isNotEmpty && !NetworkScanner.isValidCidr(v));
  }

  void _onSubmitted(String v) {
    _focusNode.unfocus();
    if (NetworkScanner.isValidCidr(v)) {
      context.read<ScanProvider>().setTarget(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SimplyNet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: OrientationBuilder(
        builder: (ctx, orientation) {
          final isLandscape = orientation == Orientation.landscape;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? size.width * 0.15 : 16,
              vertical: 16,
            ),
            child: isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInput(theme)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildButtons(context)),
                    ],
                  )
                : Column(
                    children: [
                      _buildInput(theme),
                      const SizedBox(height: 20),
                      _buildButtons(context),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildInput(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Network Target',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _ctrl,
          focusNode: _focusNode,
          onChanged: _onChanged,
          onSubmitted: _onSubmitted,
          // Keep keyboard open until user explicitly dismisses
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'e.g. 192.168.1.0/24',
            errorText: _hasError
                ? 'Invalid CIDR — use format like 192.168.1.0/24'
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: _detecting
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.my_location),
                    tooltip: 'Detect my network',
                    onPressed: _detect,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext ctx) {
    final buttons = [
      _NavBtn(icon: Icons.network_check, label: 'Scan', route: '/scan'),
      _NavBtn(icon: Icons.article, label: 'Logs', route: '/logs'),
      _NavBtn(icon: Icons.hub, label: 'Network Tools', route: '/network_tools'),
      _NavBtn(icon: Icons.wifi, label: 'WiFi Tools', route: '/wifi_tools'),
      _NavBtn(icon: Icons.settings, label: 'Settings', route: '/settings'),
    ];

    return Column(
      children: buttons.map((b) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushNamed(ctx, b.route),
              icon: Icon(b.icon),
              label: Text(b.label, style: const TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NavBtn {
  final IconData icon;
  final String label;
  final String route;
  const _NavBtn({required this.icon, required this.label, required this.route});
}
