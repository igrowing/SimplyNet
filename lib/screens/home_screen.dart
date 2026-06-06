import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/screens/cellular_screen.dart';
import 'package:simply_net/screens/iot_scan_screen.dart';
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
              // Portrait/tablet: generous 15% side margins.
              // Landscape phone: tight 2.5% so both groups fill 95% of width.
              horizontal: isLandscape
                  ? size.width * 0.025
                  : (isWide ? size.width * 0.15 : 16),
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
      _ToolBtn(Icons.speed,         'Speed Test',     'Download & upload speed',        () => push(const SpeedTestScreen()),              Colors.blue),
      _ToolBtn(Icons.public,        'Public IP',      'Your IP, ISP & location',        () => push(const PublicIpScreen()),               Colors.green),
      _ToolBtn(Icons.videocam,      'IP Cameras',     'Find cameras on your LAN',       () => push(IpCameraScanScreen(cidr: scanTarget)), Colors.orange),
      _ToolBtn(Icons.memory,        'IoT Devices',    'Matter, Tasmota, Shelly & more', () => push(IotScanScreen(cidr: scanTarget)),      Colors.deepPurple),
      _ToolBtn(Icons.radar,         'Port Scan',      'Open TCP/UDP ports on any host', () => push(const PortScanScreen()),               Colors.purple),
      _ToolBtn(Icons.network_ping,  'Ping',           'Live ping with graph',           () => push(const PingScreen()),                   Colors.teal),
      _ToolBtn(Icons.route,         'Traceroute',     'Hop-by-hop path to any host',    () => push(const TracerouteScreen()),             Colors.deepOrange),
      _ToolBtn(Icons.manage_search, 'Who Is…',   'WHOIS, DNS & reverse lookup',    () => push(const WhoisScreen()),                  Colors.indigo),
      _ToolBtn(Icons.wifi_find,     'Wi-Fi Channels', '2.4 & 5 GHz interference map',   () => push(const WifiChannelsScreen()),           Colors.cyan),
      _ToolBtn(Icons.cell_tower,    'Cellular Info',  'Signal, cell ID & tower data',   () => push(const CellularScreen()),               Colors.deepPurple),
    ];

    // Column of 2-item rows → each button takes intrinsic height so
    // the subtitle text wraps fully and is never clipped or ellipsised.
    final rows = <Widget>[];
    for (var i = 0; i < tools.length; i += 2) {
      final left  = tools[i];
      final right = i + 1 < tools.length ? tools[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _SmallToolBtn(left)),
              const SizedBox(width: 10),
              Expanded(child: right != null
                  ? _SmallToolBtn(right)
                  : const SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < tools.length) rows.add(const SizedBox(height: 10));
    }

    return _GroupBox(
      label: 'Network Tools',
      child: Column(children: rows),
    );
  }
}if (tool.subtitle.isNotEmpty)
                    Text(tool.subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        softWrap: true),
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
              // Portrait/tablet: generous 15% side margins.
              // Landscape phone: tight 2.5% so both groups fill 95% of width.
              horizontal: isLandscape
                  ? size.width * 0.025
                  : (isWide ? size.width * 0.15 : 16),
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
      _ToolBtn(Icons.speed,         'Speed Test',     'Download & upload speed',        () => push(const SpeedTestScreen()),              Colors.blue),
      _ToolBtn(Icons.public,        'Public IP',      'Your IP, ISP & location',        () => push(const PublicIpScreen()),               Colors.green),
      _ToolBtn(Icons.videocam,      'IP Cameras',     'Find cameras on your LAN',       () => push(IpCameraScanScreen(cidr: scanTarget)), Colors.orange),
      _ToolBtn(Icons.memory,        'IoT Devices',    'Matter, Tasmota, Shelly & more', () => push(IotScanScreen(cidr: scanTarget)),      Colors.deepPurple),
      _ToolBtn(Icons.radar,         'Port Scan',      'Open TCP/UDP ports on any host', () => push(const PortScanScreen()),               Colors.purple),
      _ToolBtn(Icons.network_ping,  'Ping',           'Live ping with graph',           () => push(const PingScreen()),                   Colors.teal),
      _ToolBtn(Icons.route,         'Traceroute',     'Hop-by-hop path to any host',    () => push(const TracerouteScreen()),             Colors.deepOrange),
      _ToolBtn(Icons.manage_search, 'Who Is…',   'WHOIS, DNS & reverse lookup',    () => push(const WhoisScreen()),                  Colors.indigo),
      _ToolBtn(Icons.wifi_find,     'Wi-Fi Channels', '2.4 & 5 GHz interference map',   () => push(const WifiChannelsScreen()),           Colors.cyan),
      _ToolBtn(Icons.cell_tower,    'Cellular Info',  'Signal, cell ID & tower data',   () => push(const CellularScreen()),               Colors.deepPurple),
    ];

    // Column of 2-item rows → each button takes intrinsic height so
    // the subtitle text wraps fully and is never clipped or ellipsised.
    final rows = <Widget>[];
    for (var i = 0; i < tools.length; i += 2) {
      final left  = tools[i];
      final right = i + 1 < tools.length ? tools[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _SmallToolBtn(left)),
              const SizedBox(width: 10),
              Expanded(child: right != null
                  ? _SmallToolBtn(right)
                  : const SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < tools.length) rows.add(const SizedBox(height: 10));
    }

    return _GroupBox(
      label: 'Network Tools',
      child: Column(children: rows),
    );
  }
}
