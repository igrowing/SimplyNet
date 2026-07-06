import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/screens/cellular_screen.dart';
import 'package:simply_net/screens/iot_scan_screen.dart';
import 'package:simply_net/screens/wifi_channels_screen.dart';
import 'package:simply_net/screens/ip_camera_scan_screen.dart';
import 'package:simply_net/screens/ping_screen.dart';
import 'package:simply_net/screens/port_scan_screen.dart';
import 'package:simply_net/screens/public_ip_screen.dart';
import 'package:simply_net/screens/speed_test_screen.dart';
import 'package:simply_net/screens/traceroute_screen.dart';
import 'package:simply_net/screens/whois_screen.dart';

// Re-export the tool screens so existing importers of this file keep working.
export 'package:simply_net/screens/ip_camera_scan_screen.dart';
export 'package:simply_net/screens/ping_screen.dart';
export 'package:simply_net/screens/port_scan_screen.dart';
export 'package:simply_net/screens/public_ip_screen.dart';
export 'package:simply_net/screens/speed_test_screen.dart';
export 'package:simply_net/screens/traceroute_screen.dart';
export 'package:simply_net/screens/whois_screen.dart';

class NetworkToolsScreen extends StatelessWidget {
  const NetworkToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tools = [
      _ToolCard(
        icon: Icons.speed,
        title: l.toolSpeedTest,
        subtitle: l.toolSpeedTestSub,
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SpeedTestScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.public,
        title: l.toolPublicIp,
        subtitle: l.toolPublicIpSub,
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PublicIpScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.videocam,
        title: l.toolIpCameras,
        subtitle: l.toolIpCamerasSub,
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                IpCameraScanScreen(cidr: context.read<ScanProvider>().target),
          ),
        ),
      ),
      _ToolCard(
        icon: Icons.memory,
        title: l.toolIotDevices,
        subtitle: l.toolIotDevicesSub,
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                IotScanScreen(cidr: context.read<ScanProvider>().target),
          ),
        ),
      ),
      _ToolCard(
        icon: Icons.radar,
        title: l.toolPortScan,
        subtitle: l.toolPortScanSub,
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PortScanScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.network_ping,
        title: l.toolPing,
        subtitle: l.toolPingSub,
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PingScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.route,
        title: l.toolTraceroute,
        subtitle: l.toolTracerouteSub,
        color: Colors.deepOrange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TracerouteScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.manage_search,
        title: l.toolWhois,
        subtitle: l.toolWhoisSub,
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WhoisScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.wifi_find,
        title: l.toolWifiChannels,
        subtitle: l.toolWifiChannelsSub,
        color: Colors.cyan,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WifiChannelsScreen()),
        ),
      ),
      _ToolCard(
        icon: Icons.cell_tower,
        title: l.toolCellularInfo,
        subtitle: l.toolCellularInfoSub,
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CellularScreen()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.networkTools,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.55,
          ),
          itemCount: tools.length,
          itemBuilder: (_, i) => tools[i],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

