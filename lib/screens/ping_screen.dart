import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simply_net/services/foreground_service.dart';
import 'package:simply_net/screens/markdown_info_screen.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:simply_net/widgets/diag_widgets.dart';
import 'package:simply_net/widgets/history_field.dart';

class PingScreen extends StatefulWidget {
  const PingScreen({super.key});
  @override
  State<PingScreen> createState() => _PingScreenState();
}

class _PingScreenState extends State<PingScreen> {
  final _ctrl = TextEditingController();
  final _diagOutput = StringBuffer();
  final _pingTimings = <double>[];
  StreamSubscription<String>? _sub;
  bool _running = false;
  int _parsedUpTo = 0;
  final _scroll = ScrollController();

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  //  TODO: refactor: use One subnet scan for IP cameras, General scan, and IOT devices search.
  void _toggle() {
    if (_running) {
      _sub?.cancel();
      FgService.stop(doneBody: 'Ping stopped.');
      setState(() => _running = false);
      // TODO: accomplish saving log after ping
      // _saveLog(partial: true);
    } else {
      final host = _ctrl.text.trim();
      if (host.isEmpty) return;
      FocusScope.of(context).unfocus();
      setState(() {
        _running = true;
        _parsedUpTo = 0;
        _diagOutput.clear();
        _pingTimings.clear();
      });
      FgService.start(title: 'Ping', body: 'Pinging $host…');

      /// TODO: refactor: use rawResults ping scan cache if available. Scan if cache is empty.
      _sub = NetworkTools.ping(host, count: 50).listen(
        (chunk) {
          setState(() {
            _diagOutput.write(chunk);
            final (newMs, cursor) = parsePingTimings(
              _diagOutput.toString(),
              _parsedUpTo,
            );
            _pingTimings.addAll(newMs);
            _parsedUpTo = cursor;
          });
        },
        onDone: () async {
          final (tail, _) = parsePingTimings(
            _diagOutput.toString(),
            _parsedUpTo,
          );
          setState(() {
            _pingTimings.addAll(tail);
            _running = false;
          });
          FgService.stop(doneBody: 'Ping complete.');
          // TODO: accomplish saving log after ping
          // await _saveLog();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ping',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Ping',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MarkdownInfoScreen(
                  title: 'About Ping',
                  assetPath: 'assets/ping_info.md',
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
                    onSubmitted: (_) => _toggle(),
                    enabled: !_running,
                    decoration: InputDecoration(
                      hintText: 'IP address or hostname',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _toggle,
                  icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                  label: Text(_running ? 'Stop' : 'Go'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _running
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _ctrl.text.isEmpty && !_running && _pingTimings.isEmpty
                  ? Center(
                      child: Text(
                        'Enter a host and press Go',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    )
                  : DiagOutputPanel(
                      output: _diagOutput.toString(),
                      isRunning: _running,
                      isPing: true,
                      pingTimings: _pingTimings,
                      scrollController: _scroll,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

