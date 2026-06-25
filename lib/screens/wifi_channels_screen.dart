import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WifiChannelsScreen extends StatefulWidget {
  const WifiChannelsScreen({super.key});
  @override
  State<WifiChannelsScreen> createState() => _WifiChannelsScreenState();
}

class _WifiChannelsScreenState extends State<WifiChannelsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  List<_WifiNetwork> _networks = [];
  bool _scanning = false;
  String _error = '';

  static const _channel = MethodChannel('simplynet/wifi');

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _scan();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  // The native side now triggers a real scan and waits for the
  // SCAN_RESULTS_AVAILABLE broadcast, so a single pass already returns a
  // complete dual-band snapshot. A second pass is merged for robustness in
  // case the first scan was throttled to a partial (single-band) cache.
  static const _scanPasses = 2;
  static const _passGap = Duration(milliseconds: 400);

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _error = '';
    });

    final merged = <String, _WifiNetwork>{};
    String err = '';

    for (var pass = 0; pass < _scanPasses; pass++) {
      try {
        final raw = await _channel.invokeMethod<List>('getScanResults');
        if (raw != null) {
          for (final m in raw.cast<Map>()) {
            final freq = m['freq'] as int? ?? 0;
            final band = _freqToBand(freq);
            if (band == 'other') continue;
            final bssid = (m['bssid'] as String?) ?? '';
            final ssid = (m['ssid'] as String?);
            final net = _WifiNetwork(
              ssid: (ssid != null && ssid.isNotEmpty) ? ssid : '<hidden>',
              bssid: bssid,
              rssi: (m['rssi'] as int?) ?? -100,
              channel: _freqToChannel(freq),
              band: band,
            );
            final key = bssid.isNotEmpty ? bssid : '${net.ssid}/${net.channel}';
            merged[key] = net; // latest snapshot wins for this AP
          }
        }
      } on PlatformException catch (e) {
        err = 'Scan error: ${e.message}';
      } catch (e) {
        err = '$e';
      }
      // Give the OS time to land a fresh scan before the next read.
      if (pass < _scanPasses - 1) await Future.delayed(_passGap);
      if (!mounted) return;
    }

    if (!mounted) return;
    setState(() {
      if (merged.isEmpty) {
        _error = err.isEmpty ? 'No results.' : err;
        _networks = _demo();
      } else {
        _error = '';
        _networks = merged.values.toList();
      }
      _scanning = false;
    });
  }

  static int _freqToChannel(int f) {
    if (f >= 2412 && f <= 2484) return f == 2484 ? 14 : (f - 2412) ~/ 5 + 1;
    if (f >= 5160 && f <= 5885) return (f - 5000) ~/ 5;
    return 0;
  }

  static String _freqToBand(int f) {
    if (f >= 2400 && f < 3000) return '2.4';
    if (f >= 5000 && f < 6000) return '5';
    return 'other';
  }

  List<_WifiNetwork> _demo() => [
    _WifiNetwork(
      ssid: 'HomeNetwork',
      bssid: 'AA:BB:CC:DD:EE:01',
      rssi: -45,
      channel: 6,
      band: '2.4',
    ),
    _WifiNetwork(
      ssid: 'NeighborWifi',
      bssid: 'AA:BB:CC:DD:EE:02',
      rssi: -68,
      channel: 6,
      band: '2.4',
    ),
    _WifiNetwork(
      ssid: 'Office_WiFi',
      bssid: 'AA:BB:CC:DD:EE:03',
      rssi: -72,
      channel: 1,
      band: '2.4',
    ),
    _WifiNetwork(
      ssid: 'Guest',
      bssid: 'AA:BB:CC:DD:EE:04',
      rssi: -80,
      channel: 11,
      band: '2.4',
    ),
    _WifiNetwork(
      ssid: 'HomeNet5G',
      bssid: 'AA:BB:CC:DD:EE:05',
      rssi: -50,
      channel: 36,
      band: '5',
    ),
    _WifiNetwork(
      ssid: 'Office5G',
      bssid: 'AA:BB:CC:DD:EE:06',
      rssi: -65,
      channel: 44,
      band: '5',
    ),
    _WifiNetwork(
      ssid: 'Neighbor5G',
      bssid: 'AA:BB:CC:DD:EE:07',
      rssi: -78,
      channel: 36,
      band: '5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wi-Fi Channels',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_scanning)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Re-scan',
              onPressed: _scan,
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: '2.4 GHz'),
            Tab(text: '5 GHz'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_error.isNotEmpty) _ErrorBanner(_error),
          Expanded(
            // Use AnimatedBuilder + IndexedStack instead of TabBarView.
            // TabBarView wraps a PageView which hijacks ALL horizontal swipe
            // gestures, preventing the chart's horizontal scroll from working.
            // With IndexedStack the tab content owns all gestures; tabs switch
            // only via the TabBar tap (which is what you want in landscape).
            child: AnimatedBuilder(
              animation: _tabs,
              builder: (_, __) => IndexedStack(
                index: _tabs.index,
                children: [
                  _ChannelChart(
                    networks: _networks.where((n) => n.band == '2.4').toList(),
                    channels: List.generate(13, (i) => i + 1),
                    band: '2.4 GHz',
                  ),
                  _ChannelChart(
                    networks: _networks.where((n) => n.band == '5').toList(),
                    channels: [
                      36,
                      40,
                      44,
                      48,
                      52,
                      56,
                      60,
                      64,
                      100,
                      104,
                      108,
                      112,
                      116,
                      120,
                      124,
                      128,
                      132,
                      136,
                      140,
                      144,
                      149,
                      153,
                      157,
                      161,
                      165,
                      169,
                      173,
                      177,
                    ],
                    band: '5 GHz',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String msg;
  const _ErrorBanner(this.msg);
  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.errorContainer,
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            msg,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── Channel chart ─────────────────────────────────────────────────────────────

class _ChannelChart extends StatelessWidget {
  final List<_WifiNetwork> networks;
  final List<int> channels;
  final String band;
  const _ChannelChart({
    required this.networks,
    required this.channels,
    required this.band,
  });

  @override
  Widget build(BuildContext context) {
    if (networks.isEmpty) {
      return Center(child: Text('No $band networks detected.'));
    }

    final ssids = networks.map((n) => n.ssid).toSet().toList();
    const palette = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
    ];
    final colorMap = {
      for (var i = 0; i < ssids.length; i++)
        ssids[i]: palette[i % palette.length],
    };

    final byChannel = <int, List<_WifiNetwork>>{};
    for (final ch in channels) byChannel[ch] = [];
    for (final n in networks) {
      if (byChannel.containsKey(n.channel)) byChannel[n.channel]!.add(n);
    }

    // Portrait  → chart top half, list bottom half (vertical split)
    // Landscape → chart left half, list right half (horizontal split)
    return OrientationBuilder(
      builder: (ctx, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final chart = _buildChart(context, byChannel, colorMap);
        final list = _buildList(context, networks, colorMap);

        if (isLandscape) {
          return Row(
            children: [
              Expanded(child: chart),
              const VerticalDivider(width: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: list,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(child: chart),
              const Divider(height: 1),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: list,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildChart(
    BuildContext context,
    Map<int, List<_WifiNetwork>> byChannel,
    Map<String, Color> colorMap,
  ) {
    // LayoutBuilder provides the real available height so CustomPaint
    // is never given Size(w, infinity) which causes a blank canvas.
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final chartH = constraints.maxHeight.isInfinite
            ? 200.0
            : constraints.maxHeight;
        final minW = math.max(
          MediaQuery.of(context).size.width - 16,
          channels.length * 52.0,
        );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: SizedBox(
            width: minW,
            height: chartH,
            child: CustomPaint(
              painter: _ChannelPainter(
                byChannel: byChannel,
                channels: channels,
                colorMap: colorMap,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<_WifiNetwork> nets,
    Map<String, Color> colorMap,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      children: [
        // Legend header row
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'SSID',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  'Ch',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                width: 64,
                child: Text(
                  'RSSI',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                width: 64,
                child: Text(
                  'Quality',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 4),
        ...nets.map(
          (n) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: colorMap[n.ssid],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Text(
                    n.ssid,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    'ch ${n.channel}',
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    '${n.rssi} dBm',
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    _quality(n.rssi),
                    style: TextStyle(fontSize: 11, color: _qColor(n.rssi)),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _quality(int r) {
    if (r >= -50) return 'Excellent';
    if (r >= -60) return 'Good';
    if (r >= -70) return 'Fair';
    if (r >= -80) return 'Weak';
    return 'Poor';
  }

  static Color _qColor(int r) {
    if (r >= -50) return Colors.green;
    if (r >= -60) return Colors.lightGreen;
    if (r >= -70) return Colors.orange;
    return Colors.red;
  }
}

// ── CustomPainter ─────────────────────────────────────────────────────────────

class _ChannelPainter extends CustomPainter {
  final Map<int, List<_WifiNetwork>> byChannel;
  final List<int> channels;
  final Map<String, Color> colorMap;
  const _ChannelPainter({
    required this.byChannel,
    required this.channels,
    required this.colorMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const labelH = 24.0, padTop = 8.0, minR = -100.0, maxR = -20.0;
    final chartH = size.height - labelH - padTop;
    final colW = size.width / channels.length;

    final gridP = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (final level in [-40, -60, -80]) {
      final frac = (level - minR) / (maxR - minR);
      final y = padTop + chartH * (1 - frac);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridP);
      tp
        ..text = TextSpan(
          text: '${level}dB',
          style: const TextStyle(color: Colors.grey, fontSize: 8),
        )
        ..layout();
      tp.paint(canvas, Offset(2, y - 9));
    }

    for (var ci = 0; ci < channels.length; ci++) {
      final ch = channels[ci];
      final nets = byChannel[ch] ?? [];
      final xMid = ci * colW + colW / 2;
      final barW = math.min(colW * 0.7, 32.0);

      tp
        ..text = TextSpan(
          text: '$ch',
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        )
        ..layout();
      tp.paint(canvas, Offset(xMid - tp.width / 2, size.height - labelH + 4));

      final slot = barW / math.max(nets.length, 1);
      for (var ni = 0; ni < nets.length; ni++) {
        final n = nets[ni];
        final frac = ((n.rssi - minR) / (maxR - minR)).clamp(0.0, 1.0);
        final bh = frac * chartH;
        final bx = (xMid - barW / 2) + ni * slot;
        final by = padTop + chartH - bh;
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(bx, by, slot - 1, bh),
            topLeft: const Radius.circular(3),
            topRight: const Radius.circular(3),
          ),
          Paint()
            ..color = (colorMap[n.ssid] ?? Colors.blue).withValues(alpha: 0.75)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ChannelPainter old) =>
      old.byChannel != byChannel || old.channels != channels;
}

// ── Data model ────────────────────────────────────────────────────────────────

class _WifiNetwork {
  final String ssid, bssid, band;
  final int rssi, channel;
  const _WifiNetwork({
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.channel,
    required this.band,
  });
}
