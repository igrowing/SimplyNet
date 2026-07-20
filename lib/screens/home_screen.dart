import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/screens/cellular_screen.dart';
import 'package:simply_net/screens/mqtt_screen.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/iot_scan_screen.dart';
import 'package:simply_net/screens/network_tools_screen.dart';
import 'package:simply_net/screens/wifi_channels_screen.dart';
import 'package:simply_net/services/lan_detector.dart';
import 'package:simply_net/services/network_scanner.dart';
import 'package:simply_net/widgets/history_field.dart';
import 'package:simply_net/main.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
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
          setState(() => _appVersion = 'v${raw.split('-').first}');
          if (mounted) setState(() => _appVersion = 'v${raw.split('+').first.split('-').first}');
          break;
        }
      }
    }).catchError((_) {});
    final prov = context.read<ScanProvider>();
    _ctrl = TextEditingController(text: prov.target);
    WidgetsBinding.instance.addPostFrameCallback((_) => _detect());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) routeObserver.subscribe(this, route);
  }

  // Drop focus from the CIDR field before another screen covers the home
  // screen. Otherwise Flutter restores focus to it on return, re-popping the
  // keyboard even though the user only wanted to come back to the home screen.
  @override
  void didPushNext() => _focusNode.unfocus();

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
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
            tooltip: AppLocalizations.of(context).settings,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          // ── About / README ─────────────────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: AppLocalizations.of(context).aboutSimplyNet,
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      // Derive orientation from MediaQuery (the stable window orientation)
      // rather than OrientationBuilder, whose value comes from transient box
      // constraints and briefly reported landscape while a page transition
      // was settling — causing the home screen to flash its side-by-side
      // layout before snapping to the correct one.
      body: Builder(
        builder: (ctx) {
          final isLandscape =
              MediaQuery.orientationOf(ctx) == Orientation.landscape;
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
    final l = AppLocalizations.of(ctx);
    return _GroupBox(
      label: l.scan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Network target input
          HistoryField(
            controller: _ctrl,
            focusNode: _focusNode,
            historyKey: 'network_target',
            onChanged: _onChanged,
            onSubmitted: _onSubmitted,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l.networkTarget,
              hintText: l.networkTargetHint,
              errorText: _hasError
                  ? l.invalidCidr
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
                      tooltip: l.detectMyNetwork,
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
                label: Text(l.scan),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(ctx, '/logs'),
                icon: const Icon(Icons.article),
                label: Text(l.logs),
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
    final l = AppLocalizations.of(ctx);

    final tools = [
      _ToolBtn(Icons.speed,         l.toolSpeedTest,     l.toolSpeedTestSub,     () => push(const SpeedTestScreen()),              Colors.blue),
      _ToolBtn(Icons.public,        l.toolPublicIp,      l.toolPublicIpSub,      () => push(const PublicIpScreen()),               Colors.green),
      _ToolBtn(Icons.videocam,      l.toolIpCameras,     l.toolIpCamerasSub,     () => push(IpCameraScanScreen(cidr: scanTarget)), Colors.orange),
      _ToolBtn(Icons.memory,        l.toolIotDevices,    l.toolIotDevicesSub,    () => push(IotScanScreen(cidr: scanTarget)),      Colors.deepPurple),
      _ToolBtn(Icons.subscriptions, l.toolMqttSub,       l.toolMqttSubSub,       () => push(MqttSubScreen(appScreenTimeoutMode: ctx.read<SettingsProvider>().settings.screenTimeout.index)), Colors.brown),
      _ToolBtn(Icons.publish,       l.toolMqttPub,       l.toolMqttPubSub,       () => push(MqttPubScreen(appScreenTimeoutMode: ctx.read<SettingsProvider>().settings.screenTimeout.index)), Colors.deepOrange),
      _ToolBtn(Icons.radar,         l.toolPortScan,      l.toolPortScanSub,      () => push(const PortScanScreen()),               Colors.purple),
      _ToolBtn(Icons.network_ping,  l.toolPing,          l.toolPingSub,          () => push(const PingScreen()),                   Colors.teal),
      _ToolBtn(Icons.route,         l.toolTraceroute,    l.toolTracerouteSub,    () => push(const TracerouteScreen()),             Colors.deepOrange),
      _ToolBtn(Icons.manage_search, l.toolWhois,         l.toolWhoisSub,         () => push(const WhoisScreen()),                  Colors.indigo),
      _ToolBtn(Icons.wifi_find,     l.toolWifiChannels,  l.toolWifiChannelsSub,  () => push(const WifiChannelsScreen()),           Colors.cyan),
      _ToolBtn(Icons.cell_tower,    l.toolCellularInfo,  l.toolCellularInfoSub,  () => push(const CellularScreen()),               Colors.deepPurple),
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
      label: l.networkTools,
      child: Column(children: rows),
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
  final String       subtitle;
  final VoidCallback onTap;
  final Color        color;
  const _ToolBtn(this.icon, this.label, this.subtitle, this.onTap, this.color);
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
          border: Border.all(color: tool.color.withValues(alpha: 0.55), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(tool.icon, size: 22, color: tool.color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.label,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  if (tool.subtitle.isNotEmpty)
                    Text(tool.subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        softWrap: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}