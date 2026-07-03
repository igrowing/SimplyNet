import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simply_net/widgets/pulsing_icon.dart';

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

  void _showBandInfo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dual access point detection in 5 GHz network'),
        content: const SingleChildScrollView(
          child: Text(
            '💡 Hold SSID to see full Access Point name.\n\n'
            'ℹ️ On the 5 GHz band you will usually see each access point appear on '
            'two (or more) channels at once. That is normal.\n\n'
            'To go faster, modern routers glue neighbouring 20 MHz channels '
            'together into one wider lane — 40, 80, or even 160 MHz. This is '
            'called "channel bonding". A wider lane carries more data, just '
            'like a wider road carries more cars.\n\n'
            'With "dynamic channel width" the router picks the widest lane it '
            'can and narrows it automatically when the air gets busy or noisy, '
            'so it stays fast without stepping on the neighbours.\n\n'
            'So a single 5 GHz network showing on channels 36 and 40, for '
            'example, is just one access point using an 40 MHz-wide bonded '
            'channel — not two separate networks.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
              ssid: (ssid != null && ssid.trim().isNotEmpty) ? ssid : '<Hidden Network>',
              bssid: bssid,
              rssi: (m['rssi'] as int?) ?? -100,
              channel: _freqToChannel(freq),
              band: band,
              security: wifiSecurityLabel(m['capabilities'] as String?),
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
      security: 'WPA2',
    ),
    _WifiNetwork(
      ssid: 'NeighborWifi',
      bssid: 'AA:BB:CC:DD:EE:02',
      rssi: -68,
      channel: 6,
      band: '2.4',
      security: 'WPA2',
    ),
    _WifiNetwork(
      ssid: 'Office_WiFi',
      bssid: 'AA:BB:CC:DD:EE:03',
      rssi: -72,
      channel: 1,
      band: '2.4',
      security: 'WPA3',
    ),
    _WifiNetwork(
      ssid: 'Guest',
      bssid: 'AA:BB:CC:DD:EE:04',
      rssi: -80,
      channel: 11,
      band: '2.4',
      security: 'Open',
    ),
    _WifiNetwork(
      ssid: 'HomeNet5G',
      bssid: 'AA:BB:CC:DD:EE:05',
      rssi: -50,
      channel: 36,
      band: '5',
      security: 'WPA2',
    ),
    _WifiNetwork(
      ssid: 'Office5G',
      bssid: 'AA:BB:CC:DD:EE:06',
      rssi: -65,
      channel: 44,
      band: '5',
      security: 'WPA2',
    ),
    _WifiNetwork(
      ssid: 'Neighbor5G',
      bssid: 'AA:BB:CC:DD:EE:07',
      rssi: -78,
      channel: 36,
      band: '5',
      security: 'Open',
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
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About 5 GHz channels',
            onPressed: _showBandInfo,
          ),
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
              icon: const PulsingIcon(child: Icon(Icons.refresh)),
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
              builder: (_, _) => IndexedStack(
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

class _ChannelChart extends StatefulWidget {
  final List<_WifiNetwork> networks;
  final List<int> channels;
  final String band;
  const _ChannelChart({
    required this.networks,
    required this.channels,
    required this.band,
  });

  @override
  State<_ChannelChart> createState() => _ChannelChartState();
}

class _ChannelChartState extends State<_ChannelChart> {
  _WifiSort _sort = _WifiSort.channel;
  bool _asc = true;

  void _onSort(_WifiSort col) {
    setState(() {
      if (_sort == col) {
        _asc = !_asc;
      } else {
        _sort = col;
        _asc = true;
      }
    });
  }

  // Sort on the numeric fields (channel/rssi are ints) so the natural order is
  // honoured — no ascii pitfall where "101" would sort before "20".
  int _cmp(_WifiNetwork a, _WifiNetwork b) {
    int c;
    switch (_sort) {
      case _WifiSort.ssid:
        c = a.ssid.toLowerCase().compareTo(b.ssid.toLowerCase());
      case _WifiSort.channel:
        c = a.channel.compareTo(b.channel);
      case _WifiSort.rssi:
      case _WifiSort.quality:
        c = a.rssi.compareTo(b.rssi);
    }
    return _asc ? c : -c;
  }

  @override
  Widget build(BuildContext context) {
    final networks = widget.networks;
    final channels = widget.channels;
    final band = widget.band;
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
    for (final ch in channels) {
      byChannel[ch] = [];
    }
    for (final n in networks) {
      if (byChannel.containsKey(n.channel)) byChannel[n.channel]!.add(n);
    }

    // Portrait  → chart top half, list bottom half (vertical split)
    // Landscape → chart left half, list right half (horizontal split)
    return OrientationBuilder(
      builder: (ctx, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final chart = _buildChart(context, byChannel, colorMap);
        final list = _buildList(context, [...networks]..sort(_cmp), colorMap);

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

  Widget _headerCell(String label, _WifiSort col, bool rightAlign) {
    final active = _sort == col;
    return InkWell(
      onTap: () => _onSort(col),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment:
              rightAlign ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: rightAlign ? TextAlign.right : TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (active)
              Icon(_asc ? Icons.arrow_upward : Icons.arrow_downward, size: 11),
          ],
        ),
      ),
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
          widget.channels.length * 52.0,
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
                channels: widget.channels,
                colorMap: colorMap,
              ),
            ),
          ),
        );
      },
    );
  }
  final double _securityWidth = 60;
  final double _chWidth = 32;
  final double _rssiWidth = 60;
  final double _qualityWidth = 60;

  Widget _buildList(
    BuildContext context,
    List<_WifiNetwork> nets,
    Map<String, Color> colorMap,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(child: _headerCell('SSID', _WifiSort.ssid, false)),
              SizedBox(
                width: _securityWidth,
                child: Text(
                  'Security',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: _chWidth, child: _headerCell('Ch', _WifiSort.channel, true)),
              SizedBox(width: _rssiWidth, child: _headerCell('RSSI', _WifiSort.rssi, true)),
              SizedBox(
                width: _qualityWidth,
                child: _headerCell('Quality', _WifiSort.quality, true),
              ),
            ],
          ),
        ),
        const Divider(height: 4),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: nets.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (ctx, index) {
              final n = nets[index];
              return _buildNetworkRow(ctx, n, colorMap);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkRow(
    BuildContext context,
    _WifiNetwork n,
    Map<String, Color> colorMap,
  ) {
    return Padding(
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
            child: Tooltip(
              message: n.ssid,
              waitDuration: Duration.zero,
              showDuration: const Duration(seconds: 3),
              child: Row(
                children: [
                  Icon(
                    _securityIcon(n.security),
                    size: 14,
                    color: _securityIconColor(n.security),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      n.ssid,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: _securityWidth,
            child: Text(
              n.security,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: _chWidth,
            child: Text(
              '${n.channel}',
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: _rssiWidth,
            child: Text(
              '${n.rssi} dBm',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: _qualityWidth,
            child: Text(
              _quality(n.rssi),
              style: TextStyle(fontSize: 11, color: _qColor(n.rssi)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
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

  static IconData _securityIcon(String security) {
    return security.toLowerCase() == 'open'
        ? Icons.lock_open
        : Icons.lock_outline;
  }

  static Color _securityIconColor(String security) {
    return security.toLowerCase() == 'open'
        ? Colors.green
        : Colors.orange;
  }
}

String wifiSecurityLabel(String? capabilities) {
  final caps = capabilities?.trim() ?? '';
  if (caps.isEmpty) return 'Unknown';

  final upper = caps.toUpperCase();
  final hasWpa3 = upper.contains('WPA3') || upper.contains('SAE');
  final hasWpa2 = upper.contains('WPA2');
  final hasWpa = upper.contains('WPA');
  final hasWep = upper.contains('WEP');
  final hasOwe = upper.contains('OWE');
  final hasEap = upper.contains('802.1X') || upper.contains('EAP');
  final hasEss = upper.contains('ESS');

  if (hasWep) return 'WEP';
  if (hasWpa3) return 'WPA3';
  if (hasWpa2) return 'WPA2';
  if (hasWpa) return 'WPA';
  if (hasOwe) return 'OWE';
  if (hasEap) return '802.1X';
  if (hasEss) return 'Open';
  return 'Protected';
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

enum _WifiSort { ssid, channel, rssi, quality }

class _WifiNetwork {
  final String ssid, bssid, band, security;
  final int rssi, channel;
  const _WifiNetwork({
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.channel,
    required this.band,
    required this.security,
  });
}
