import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/markdown_info_screen.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:simply_net/widgets/history_field.dart';

// ── Port Scan Screen ──────────────────────────────────────────────────────────

class PortScanScreen extends StatefulWidget {
  const PortScanScreen({super.key});
  @override
  State<PortScanScreen> createState() => _PortScanScreenState();
}

class _PortScanScreenState extends State<PortScanScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _portStartCtrl = TextEditingController(text: '1');
  final _portEndCtrl = TextEditingController(text: '2048');

  bool _scanning = false;
  bool _settingsVisible = false;
  bool _useWellKnown = true;
  bool _useTcp = true;
  bool _useUdp = false;
  int _done = 0;
  int _total = 0;
  final List<String> _openLines = [];
  StreamSubscription<String>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    _portStartCtrl.dispose();
    _portEndCtrl.dispose();
    super.dispose();
  }

  void _startScan() {
    final host = _ctrl.text.trim();
    if (host.isEmpty) return;
    FocusScope.of(context).unfocus();
    _sub?.cancel();

    List<int>? ports;
    int rangeStart = 1, rangeEnd = 2048;
    if (_useWellKnown) {
      ports = NetworkTools.wellKnownPorts;
    } else {
      rangeStart = int.tryParse(_portStartCtrl.text) ?? 1;
      rangeEnd = int.tryParse(_portEndCtrl.text) ?? 2048;
    }
    final total = ports != null ? ports.length : (rangeEnd - rangeStart + 1);

    setState(() {
      _scanning = true;
      _done = 0;
      _total = total;
      _openLines.clear();
    });

    _sub =
        NetworkTools.portScan(
          host,
          ports: ports,
          rangeStart: rangeStart,
          rangeEnd: rangeEnd,
          useTcp: _useTcp,
          useUdp: _useUdp,
          onProgress: (d, _) => setState(() => _done = d),
        ).listen(
          (line) {
            if (line.startsWith('OPEN') ||
                line.startsWith('===') ||
                line.startsWith('No open') ||
                line.startsWith('\nDone')) {
              setState(() => _openLines.add(line.trim()));
            }
          },
          onDone: () async {
            setState(() => _scanning = false);
            if (context.mounted) {
              final settings = context.read<SettingsProvider>().settings;
              if (settings.loggingEnabled) {
                final openCount = _openLines
                    .where((l) => l.startsWith('OPEN'))
                    .length;
                await LogService.createLog(
                  function: 'portscan',
                  content: _openLines.join('\n'),
                  summary: 'Port scan → ${_ctrl.text.trim()}: $openCount open',
                );
              }
            }
          },
        );
  }

  void _stopScan() {
    _sub?.cancel();
    setState(() => _scanning = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.toolPortScan,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l.aboutPortScan,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MarkdownInfoScreen(
                  title: l.aboutPortScan,
                  assetPath: 'assets/portscan_info.md',
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: _settingsVisible ? l.hideSettings : l.settings,
            icon: Icon(
              Icons.settings,
              color: _settingsVisible
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () =>
                setState(() => _settingsVisible = !_settingsVisible),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Input row ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: HistoryField(
                    controller: _ctrl,
                    historyKey: 'host',
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _scanning ? null : _startScan(),
                    enabled: !_scanning,
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _scanning
                      ? FilledButton.icon(
                          key: const ValueKey('stop'),
                          onPressed: _stopScan,
                          icon: const Icon(Icons.stop_rounded),
                          label: Text(l.stop),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                        )
                      : FilledButton.icon(
                          key: const ValueKey('scan'),
                          onPressed: _startScan,
                          icon: const Icon(Icons.search),
                          label: Text(l.scan),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_settingsVisible) _buildSettings(),
          if (_scanning) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$_done / $_total',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(value: _total > 0 ? _done / _total : null),
          ],
          // ── Results ──────────────────────────────────────────────────────────
          Expanded(
            child: _openLines.isEmpty && !_scanning
                ? Center(
                    child: Text(
                      l.enterHostScan,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    itemCount: _openLines.length,
                    itemBuilder: (_, i) {
                      final line = _openLines[i];
                      final isOpen = line.startsWith('OPEN');
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            if (isOpen) ...[
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: Text(
                                line,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: isOpen ? Colors.green : null,
                                  fontWeight: isOpen ? FontWeight.bold : null,
                                ),
                              ),
                            ),
                            if (isOpen)
                              IconButton(
                                icon: const Icon(Icons.copy, size: 14),
                                tooltip: l.copy,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                onPressed: () => Clipboard.setData(
                                  ClipboardData(text: line),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Port source
          Row(
            children: [
              Text(
                l.portsLabel,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              ChoiceChip(
                label: Text(l.wellKnown),
                selected: _useWellKnown,
                onSelected: (_) => setState(() => _useWellKnown = true),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text(l.rangeLabel),
                selected: !_useWellKnown,
                onSelected: (_) => setState(() => _useWellKnown = false),
              ),
            ],
          ),
          if (!_useWellKnown)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(l.fromLabel, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _portStartCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(l.toLabel, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _portEndCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          // Protocol
          Row(
            children: [
              Text(
                l.protocolLabel,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('TCP'),
                selected: _useTcp,
                onSelected: (v) => setState(() => _useTcp = v),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('UDP'),
                selected: _useUdp,
                onSelected: (v) => setState(() => _useUdp = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
