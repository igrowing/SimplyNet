import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/screens/cellular_screen.dart';
import 'package:simply_net/screens/network_tools_screen.dart';
import 'package:simply_net/screens/wifi_channels_screen.dart';
import 'package:simply_net/services/lan_detector.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _appVersion = '';
  late TextEditingController _ctrl;
  final FocusNode _focusNode = FocusNode();
  bool _hasError  = false;
  bool _detecting = false;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('pubspec.yaml').then((yaml) {
      for (final line in yaml.split('\n')) {
        if (line.startsWith('version:')) {
          final raw = line.replaceFirst('version:', '').trim();
          if (mounted) setState(() => _appVersion = 'v${raw.split('+').first}');
          break;
        }
      }
    }).catchError((_) {});
    final prov = context.read<ScanProvider>();
    _ctrl = TextEditingController(text: prov.target);
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
      if (!kIsWeb) {
        final status = await Permission.locationWhenInUse.status;
        if (status.isDenied) await Permission.locationWhenInUse.request();
      }
      final cidr = await detectLanCidr();
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
  }

  void _onChanged(String v) {
    context.read<ScanProvider>().setTarget(v);
    setState(() => _hasError = v.isNotEmpty && !NetworkScanner.isValidCidr(v));
  }

  void _onSubmitted(String v) {
    _focusNode.unfocus();
    if (NetworkScanner.isValidCidr(v)) context.read<ScanProvider>().setTarget(v);
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final size   = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/simplynet.png', height: 32, width: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SimplyNet',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_appVersion, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          // ── Settings gear ──────────────────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          // ── About / README ─────────────────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About SimplyNet',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
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
                      Expanded(child: _buildScanGroup(theme, ctx)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildNetworkToolsGroup(ctx)),
                    ],
                  )
                : Column(
                    children: [
                      _buildScanGroup(theme, ctx),
                      const SizedBox(height: 20),
                      _buildNetworkToolsGroup(ctx),
                    ],
                  ),
          );
        },
      ),
    );
  }

  // ── "Scan" group ──────────────────────────────────────────────────────────

  Widget _buildScanGroup(ThemeData theme, BuildContext ctx) {
    return _GroupBox(
      label: 'Scan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Network target input
          TextField(
            controller: _ctrl,
            focusNode: _focusNode,
            onChanged: _onChanged,
            onSubmitted: _onSubmitted,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Network Target',
              hintText: 'e.g. 192.168.1.0/24',
              errorText: _hasError
                  ? 'Invalid CIDR — use format like 192.168.1.0/24'
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
              suffixIcon: _detecting
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18, height: 18,
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
          const SizedBox(height: 10),
          // Scan + Logs on one row
          Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.pushNamed(ctx, '/scan'),
                icon: const Icon(Icons.network_check),
                label: const Text('Scan'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(ctx, '/logs'),
                icon: const Icon(Icons.article),
                label: const Text('Logs'),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ── "Network Tools" group ─────────────────────────────────────────────────

  Widget _buildNetworkToolsGroup(BuildContext ctx) {
    // Use direct MaterialPageRoute pushes — named sub-routes like
    // '/network_tools/speed' are not registered in the router.
    void push(Widget screen) =>
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen));
    final scanTarget = ctx.read<ScanProvider>().target;

    final tools = [
      _ToolBtn(Icons.speed,         'Speed Test',     () => push(const SpeedTestScreen())),
      _ToolBtn(Icons.public,        'Public IP',      () => push(const PublicIpScreen())),
      _ToolBtn(Icons.videocam,      'IP Cameras',     () => push(IpCameraScanScreen(cidr: scanTarget))),
      _ToolBtn(Icons.manage_search, 'Who Is…',        () => push(const WhoisScreen())),
      _ToolBtn(Icons.network_ping,  'Ping',            () => push(const PingScreen())),
      _ToolBtn(Icons.route,         'Traceroute',     () => push(const TracerouteScreen())),
      _ToolBtn(Icons.dns,           'NS Lookup',      () => push(const NslookupScreen())),
      _ToolBtn(Icons.wifi_find,     'Wi-Fi Channels', () => push(const WifiChannelsScreen())),
      _ToolBtn(Icons.cell_tower,    'Cellular Info',  () => push(const CellularScreen())),
    ];

    return _GroupBox(
      label: 'Network Tools',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.8,
        children: tools
            .map((t) => _SmallToolBtn(t))
            .toList(),
      ),
    );
  }
}

// ── Shared group box ──────────────────────────────────────────────────────────

class _GroupBox extends StatelessWidget {
  final String label;
  final Widget child;
  const _GroupBox({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 22, 14, 14),
            child: child,
          ),
          Positioned(
            top: -10,
            left: 14,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small tool button for the 2-column grid ───────────────────────────────────

class _ToolBtn {
  final IconData     icon;
  final String       label;
  final VoidCallback onTap;
  const _ToolBtn(this.icon, this.label, this.onTap);
}

class _SmallToolBtn extends StatelessWidget {
  final _ToolBtn tool;
  const _SmallToolBtn(this.tool);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tool.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(tool.icon, size: 20,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(tool.label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
