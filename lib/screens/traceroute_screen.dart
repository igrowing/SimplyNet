import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/markdown_info_screen.dart';
import 'package:simply_net/services/foreground_service.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:simply_net/widgets/history_field.dart';

// ════════════════════════════════════════════════════════════════════════════
//  TRACEROUTE
// ════════════════════════════════════════════════════════════════════════════

class TracerouteScreen extends StatefulWidget {
  const TracerouteScreen({super.key});
  @override
  State<TracerouteScreen> createState() => _TracerouteScreenState();
}

class _TracerouteScreenState extends State<TracerouteScreen> {
  final _ctrl = TextEditingController();
  final _logBuf = StringBuffer();
  StreamSubscription<TracertHop>? _sub;
  List<TracertHop> _hops = [];
  bool _running = false;
  String _error = '';

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _run() {
    final host = _ctrl.text.trim();
    if (host.isEmpty) return;
    FocusScope.of(context).unfocus();
    _sub?.cancel();
    setState(() {
      _running = true;
      _hops = [];
      _error = '';
      _logBuf.clear();
    });
    FgService.start(title: 'Traceroute', body: 'Tracing route to $host…');
    _sub = NetworkTools.tracerouteHops(host).listen(
      (hop) {
        _logBuf.writeln(_hopLogLine(hop));
        setState(() => _hops = [..._hops, hop]);
      },
      onError: (Object e) {
        setState(() {
          _error = '$e';
          _running = false;
        });
        FgService.stop(doneBody: 'Traceroute failed.');
      },
      onDone: () async {
        setState(() => _running = false);
        FgService.stop(doneBody: 'Traceroute complete.');
        if (context.mounted) {
          final settings = context.read<SettingsProvider>().settings;
          if (settings.loggingEnabled) {
            await LogService.createLog(
              function: 'traceroute',
              content: _logBuf.toString(),
              summary: 'Traceroute → ${_ctrl.text.trim()}',
            );
          }
        }
      },
    );
  }

  void _stop() {
    _sub?.cancel();
    FgService.stop(doneBody: 'Traceroute stopped.');
    setState(() => _running = false);
  }

  String _hopLogLine(TracertHop h) {
    final where = h.timedOut
        ? '* * * (no reply)'
        : (h.hostname != null ? '${h.hostname} (${h.ip})' : h.ip);
    final avg = h.avgMs == null ? '—' : '${h.avgMs!.toStringAsFixed(1)} ms avg';
    return '${h.hop.toString().padLeft(2)}  $where  $avg';
  }

  // ── Node classification ────────────────────────────────────────────────
  _TraceNode _nodeOf(TracertHop h, AppLocalizations l) {
    if (h.timedOut) {
      return _TraceNode(
        l.hiddenNode,
        Icons.shield_outlined,
        Colors.grey,
      );
    }
    if (h.reached) {
      return _TraceNode(l.destination, Icons.cloud, Colors.blue);
    }
    if (h.hop == 1) {
      return _TraceNode(l.yourRouter, Icons.router, Colors.teal);
    }
    return _TraceNode(l.networkHop, Icons.location_city, Colors.indigo);
  }

  static Color _latencyColor(double ms) {
    if (ms < 50) return Colors.green;
    if (ms <= 150) return Colors.orange;
    return Colors.red;
  }

  void _showHiddenInfo() {
    final l = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.hiddenNode),
        content: Text(l.hiddenNodeInfo),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.toolTraceroute,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l.aboutTraceroute,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MarkdownInfoScreen(
                  title: l.aboutTraceroute,
                  assetPath: 'assets/tracert_info.md',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: HistoryField(
                    controller: _ctrl,
                    historyKey: 'host',
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _running ? null : _run(),
                    enabled: !_running,
                    decoration: InputDecoration(
                      hintText: l.hostHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _running ? _stop : _run,
                  icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                  label: Text(_running ? l.stop : l.trace),
                  style: FilledButton.styleFrom(
                    backgroundColor: _running
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _hops.isEmpty && !_running
                ? Center(
                    child: Text(
                      l.enterHostTrace,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  )
                : _buildTimeline(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final l = AppLocalizations.of(context);
    final total = _hops.length + (_running ? 1 : 0);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: total,
      itemBuilder: (ctx, i) {
        final hasAbove = i > 0;
        final hasBelow = i < total - 1;
        if (i >= _hops.length) {
          return _railRow(
            context,
            icon: Icons.more_horiz,
            color: Colors.grey,
            hasAbove: hasAbove,
            hasBelow: hasBelow,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l.probingNextHop,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        final h = _hops[i];
        final node = _nodeOf(h, l);
        return _railRow(
          context,
          icon: node.icon,
          color: node.color,
          hasAbove: hasAbove,
          hasBelow: hasBelow,
          child: _hopCard(context, h, node),
        );
      },
    );
  }

  Widget _railRow(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required bool hasAbove,
    required bool hasBelow,
    required Widget child,
  }) {
    final line = Theme.of(context).colorScheme.outlineVariant;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: hasAbove ? line : Colors.transparent,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.15),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(icon, size: 19, color: color),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: hasBelow ? line : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _hopCard(BuildContext context, TracertHop h, _TraceNode node) {
    final l = AppLocalizations.of(context);
    final dim = h.timedOut;
    final addr = h.hostname != null ? '${h.hostname} (${h.ip})' : h.ip;
    final subtle = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);
    final avg = h.avgMs;
    final avgTxt = avg == null ? 'avg. — ms' : 'avg. ${avg.round()} ms';
    final lower = dim ? '${l.noReply} · $avgTxt' : '$addr · $avgTxt';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${l.hop} ${h.hop}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dim ? Colors.grey : subtle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          node.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: dim ? Colors.grey : null,
                          ),
                        ),
                      ),
                      if (dim) ...[
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: _showHiddenInfo,
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.help_outline,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(lower, style: TextStyle(fontSize: 12, color: subtle)),
                ],
              ),
            ),
            if (h.ip != null) ...[
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                iconSize: 18,
                color: subtle,
                tooltip: l.copyIp,
                icon: const Icon(Icons.copy),
                onPressed: () => _copyIp(context, h.ip!),
              ),
            ],
            const SizedBox(width: 6),
            _latency(h),
          ],
        ),
      ),
    );
  }

  Future<void> _copyIp(BuildContext context, String ip) async {
    await Clipboard.setData(ClipboardData(text: ip));
    if (!context.mounted) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l.copied} $ip'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _latency(TracertHop h) {
    final avg = h.avgMs;
    final c = avg == null ? Colors.grey : _latencyColor(avg);
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(shape: BoxShape.circle, color: c),
    );
  }
}

/// Visual style for a traceroute node (label, icon, colour).
class _TraceNode {
  final String label;
  final IconData icon;
  final Color color;
  const _TraceNode(this.label, this.icon, this.color);
}

