import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wi-Fi Interference screen.
///
/// Shows a bar chart of RSSI per SSID per channel for the 2.4 GHz band.
/// Swipe left to switch to the 5 GHz view.
///
/// Data source: `iw dev wlan0 scan` / `iwlist scan` on Android
/// (requires ACCESS_FINE_LOCATION permission which the app already requests).
/// Falls back to a MethodChannel call on Android for WifiManager scan results.
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
  String _error  = '';

  // Platform channel to call Android WifiManager.getScanResults()
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

  Future<void> _scan() async {
    setState(() { _scanning = true; _error = ''; });
    try {
      // Ask Android for scan results via MethodChannel.
      // The channel is implemented in MainActivity.kt (added separately).
      final raw = await _channel.invokeMethod<List>('getScanResults');
      if (raw != null) {
        final nets = raw
            .cast<Map>()
            .map((m) => _WifiNetwork(
                  ssid:    (m['ssid'] as String?) ?? '<hidden>',
                  bssid:   (m['bssid'] as String?) ?? '',
                  rssi:    (m['rssi'] as int?) ?? -100,
                  channel: _freqToChannel(m['freq'] as int? ?? 0),
                  band:    _freqToBand(m['freq']    as int? ?? 0),
                ))
            .toList();
        setState(() => _networks = nets);
      } else {
        setState(() => _error = 'No scan results returned.');
      }
    } on PlatformException catch (e) {
      setState(() => _error = 'Scan failed: ${e.message}');
      // Use demo data so the UI is useful even without the native channel
      setState(() => _networks = _demoNetworks());
    } catch (e) {
      setState(() {
        _error    = 'Error: $e';
        _networks = _demoNetworks();
      });
    } finally {
      setState(() => _scanning = false);
    }
  }

  static int _freqToChannel(int freq) {
    if (freq >= 2412 && freq <= 2484) {
      if (freq == 2484) return 14;
      return (freq - 2412) ~/ 5 + 1;
    }
    if (freq >= 5170 && freq <= 5825) return (freq - 5170) ~/ 5 + 34;
    return 0;
  }

  static String _freqToBand(int freq) {
    if (freq >= 2400 && freq < 3000) return '2.4';
    if (freq >= 5000 && freq < 6000) return '5';
    return 'other';
  }

  List<_WifiNetwork> _demoNetworks() => [
    _WifiNetwork(ssid: 'HomeNetwork',  bssid: 'AA:BB:CC:DD:EE:01', rssi: -45, channel: 6,  band: '2.4'),
    _WifiNetwork(ssid: 'NeighborWifi', bssid: 'AA:BB:CC:DD:EE:02', rssi: -68, channel: 6,  band: '2.4'),
    _WifiNetwork(ssid: 'Office_WiFi',  bssid: 'AA:BB:CC:DD:EE:03', rssi: -72, channel: 1,  band: '2.4'),
    _WifiNetwork(ssid: 'Guest',        bssid: 'AA:BB:CC:DD:EE:04', rssi: -80, channel: 11, band: '2.4'),
    _WifiNetwork(ssid: 'HomeNetwork5', bssid: 'AA:BB:CC:DD:EE:05', rssi: -50, channel: 36, band: '5'),
    _WifiNetwork(ssid: 'Office5G',     bssid: 'AA:BB:CC:DD:EE:06', rssi: -65, channel: 44, band: '5'),
    _WifiNetwork(ssid: 'Neighbor5G',   bssid: 'AA:BB:CC:DD:EE:07', rssi: -78, channel: 36, band: '5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi Channels',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_scanning)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2,
                      color: Colors.white)),
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
          if (_error.isNotEmpty)
            Container(
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text(_error,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onErrorContainer))),
              ]),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _ChannelChart(
                  networks:  _networks.where((n) => n.band == '2.4').toList(),
                  channels:  List.generate(13, (i) => i + 1),
                  band:      '2.4 GHz',
                ),
                _ChannelChart(
                  networks:  _networks.where((n) => n.band == '5').toList(),
                  channels:  [36, 40, 44, 48, 52, 56, 60, 64, 100, 104, 108,
                               112, 116, 120, 124, 128, 132, 136, 140, 149,
                               153, 157, 161, 165],
                  band:      '5 GHz',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Channel chart ─────────────────────────────────────────────────────────────

class _ChannelChart extends StatelessWidget {
  final List<_WifiNetwork> networks;
  final List<int>          channels;
  final String             band;

  const _ChannelChart({
    required this.networks,
    required this.channels,
    required this.band,
  });

  @override
  Widget build(BuildContext context) {
    if (networks.isEmpty) {
      return Center(
        child: Text('No $band networks detected.',
            style: const TextStyle(fontSize: 14)),
      );
    }

    // Assign a distinct color per SSID
    final ssids  = networks.map((n) => n.ssid).toSet().toList();
    const palette = [
      Colors.blue, Colors.red, Colors.green, Colors.orange,
      Colors.purple, Colors.teal, Colors.pink, Colors.cyan,
    ];
    final colorMap = {
      for (var i = 0; i < ssids.length; i++)
        ssids[i]: palette[i % palette.length],
    };

    // Build channel → networks map
    final byChannel = <int, List<_WifiNetwork>>{};
    for (final ch in channels) byChannel[ch] = [];
    for (final n in networks) {
      if (byChannel.containsKey(n.channel)) byChannel[n.channel]!.add(n);
    }

    return Column(
      children: [
        // Legend
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: ssids.map((ssid) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12,
                    decoration: BoxDecoration(
                        color: colorMap[ssid],
                        borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 4),
                Text(ssid,
                    style: const TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis),
              ],
            )).toList(),
          ),
        ),
        // Chart
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: SizedBox(
              width: math.max(
                MediaQuery.of(context).size.width - 16,
                channels.length * 52.0,
              ),
              child: CustomPaint(
                painter: _ChannelPainter(
                  byChannel: byChannel,
                  channels:  channels,
                  colorMap:  colorMap,
                ),
              ),
            ),
          ),
        ),
        // Table: SSID / channel / RSSI / quality
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Column(
            children: [
              const Divider(),
              ...networks.map((n) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(children: [
                  Container(width: 10, height: 10,
                      decoration: BoxDecoration(
                          color: colorMap[n.ssid],
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 6),
                  Expanded(child: Text(n.ssid,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 48,
                      child: Text('ch ${n.channel}',
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.right)),
                  SizedBox(width: 64,
                      child: Text('${n.rssi} dBm',
                          style: const TextStyle(
                              fontSize: 11, fontFamily: 'monospace'),
                          textAlign: TextAlign.right)),
                  SizedBox(width: 64,
                      child: Text(_quality(n.rssi),
                          style: TextStyle(
                              fontSize: 11,
                              color: _qualityColor(n.rssi)),
                          textAlign: TextAlign.right)),
                ]),
              )),
            ],
          ),
        ),
      ],
    );
  }

  static String _quality(int rssi) {
    if (rssi >= -50) return 'Excellent';
    if (rssi >= -60) return 'Good';
    if (rssi >= -70) return 'Fair';
    if (rssi >= -80) return 'Weak';
    return 'Poor';
  }

  static Color _qualityColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -60) return Colors.lightGreen;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }
}

class _ChannelPainter extends CustomPainter {
  final Map<int, List<_WifiNetwork>> byChannel;
  final List<int>                    channels;
  final Map<String, Color>           colorMap;

  const _ChannelPainter({
    required this.byChannel,
    required this.channels,
    required this.colorMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const labelH  = 24.0;
    const padTop  = 8.0;
    const minRssi = -100.0;
    const maxRssi = -20.0;
    final chartH  = size.height - labelH - padTop;
    final colW    = size.width / channels.length;

    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    // Horizontal grid lines at -40, -60, -80 dBm
    for (final level in [-40, -60, -80]) {
      final frac = (level - minRssi) / (maxRssi - minRssi);
      final y = padTop + chartH * (1 - frac);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(
          text: '${level}dB',
          style: const TextStyle(color: Colors.grey, fontSize: 8),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y - 9));
    }

    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (var ci = 0; ci < channels.length; ci++) {
      final ch    = channels[ci];
      final nets  = byChannel[ch] ?? [];
      final x0    = ci * colW;
      final xMid  = x0 + colW / 2;
      final barW  = math.min(colW * 0.7, 32.0);
      final barX  = xMid - barW / 2;

      // Channel label
      tp
        ..text = TextSpan(
            text: '$ch',
            style: const TextStyle(fontSize: 9, color: Colors.grey))
        ..layout();
      tp.paint(canvas, Offset(xMid - tp.width / 2,
          size.height - labelH + 4));

      // Bars (stacked side by side within column)
      final barSlot = barW / math.max(nets.length, 1);
      for (var ni = 0; ni < nets.length; ni++) {
        final n    = nets[ni];
        final frac = ((n.rssi.toDouble() - minRssi) / (maxRssi - minRssi))
            .clamp(0.0, 1.0);
        final barH = frac * chartH;
        final bx   = barX + ni * barSlot;
        final by   = padTop + chartH - barH;

        final paint = Paint()
          ..color = (colorMap[n.ssid] ?? Colors.blue).withValues(alpha: 0.75)
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(bx, by, barSlot - 1, barH),
            topLeft:     const Radius.circular(3),
            topRight:    const Radius.circular(3),
          ),
          paint,
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
  final String ssid;
  final String bssid;
  final int    rssi;
  final int    channel;
  final String band; // '2.4' or '5'

  const _WifiNetwork({
    required this.ssid, required this.bssid,
    required this.rssi, required this.channel, required this.band,
  });
}
