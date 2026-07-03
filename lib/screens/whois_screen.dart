import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/markdown_info_screen.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:simply_net/services/network_tools.dart';
import 'package:simply_net/widgets/history_field.dart';

// ════════════════════════════════════════════════════════════════════
//  4. WHOIS
// ════════════════════════════════════════════════════════════════════

// ── Who Is… Screen (WHOIS + DNS + nslookup combined) ─────────────────────────

class WhoisScreen extends StatefulWidget {
  final String? initialTarget;
  const WhoisScreen({super.key, this.initialTarget});
  @override
  State<WhoisScreen> createState() => _WhoisState();
}

class _WhoisState extends State<WhoisScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _buf = StringBuffer();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialTarget?.isNotEmpty == true) {
      _ctrl.text = widget.initialTarget!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookup());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final q = _ctrl.text.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _buf.clear();
    });

    final isIp = RegExp(r'^\\.?\\d{1,3}(\\.\\d{1,3}){3}$').hasMatch(q);

    // ── 1. DNS ─────────────────────────────────────────────────────────────
    _put('=== DNS Resolution ===');
    try {
      final addrs = await InternetAddress.lookup(
        q,
      ).timeout(const Duration(seconds: 5));
      for (final a in addrs) {
        _put(
          '${a.type == InternetAddressType.IPv6 ? "AAAA" : "A   "} : ${a.address}',
        );
      }
    } catch (e) {
      _put('Forward lookup failed: $e');
    }
    // Reverse PTR
    if (!isIp) {
      try {
        final addrs = await InternetAddress.lookup(
          q,
        ).timeout(const Duration(seconds: 3));
        if (addrs.isNotEmpty) {
          final rev = await addrs.first.reverse().timeout(
            const Duration(seconds: 3),
          );
          if (rev.host != addrs.first.address) _put('PTR : ${rev.host}');
        }
      } catch (_) {}
    } else {
      try {
        final rev = await InternetAddress(
          q,
        ).reverse().timeout(const Duration(seconds: 3));
        if (rev.host != q) _put('PTR : ${rev.host}');
      } catch (_) {}
    }
    setState(() {});

    // ── 2. RDAP / WHOIS ────────────────────────────────────────────────────
    _put('');
    _put('=== WHOIS / RDAP ===');
    try {
      final url = isIp
          ? 'https://rdap.org/ip/$q'
          : 'https://rdap.org/domain/$q';
      final resp = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        if (isIp) {
          _put('Range   : ${data['startAddress']} – ${data['endAddress']}');
          _put('Name    : ${data['name'] ?? '–'}');
          _put('Type    : ${data['type'] ?? '–'}');
          _put('Country : ${data['country'] ?? '–'}');
        } else {
          _put('Domain  : ${data['ldhName'] ?? q}');
          _put('Status  : ${(data['status'] as List?)?.join(', ') ?? '–'}');
          for (final e in (data['events'] as List?) ?? []) {
            _put('${e['eventAction']}: ${e['eventDate']}');
          }
          final ns = (data['nameservers'] as List?) ?? [];
          if (ns.isNotEmpty) {
            _put('');
            _put('Nameservers:');
            for (final n in ns) _put('  ${n['ldhName']}');
          }
        }
        for (final entity in (data['entities'] as List?) ?? []) {
          final roles = (entity['roles'] as List?) ?? [];
          final vcard = entity['vcardArray'] as List?;
          if (vcard != null && vcard.length > 1) {
            for (final f in vcard[1] as List) {
              if (f is List && f.length >= 4 && f[0] == 'fn') {
                _put('${roles.join('/')}: ${f[3]}');
              }
            }
          }
        }
      } else {
        _put('RDAP returned ${resp.statusCode}');
      }
    } catch (e) {
      _put('RDAP error: $e');
    }
    setState(() {});

    // ── 3. DNS detail via NetworkTools.nslookup ─────────────────────────────────
    // Reuse the well-tested NetworkTools.nslookup stream instead of
    // shelling out to the nslookup binary (which is not accessible on
    // many Android builds via /system/bin/sh).
    _put('');
    _put('=== DNS detail ===');
    try {
      await for (final line in NetworkTools.nslookup(
        q,
      ).timeout(const Duration(seconds: 10))) {
        if (line.trim().isNotEmpty) _put(line.trim());
      }
    } catch (e) {
      _put('DNS detail unavailable: $e');
    }

    setState(() {
      _loading = false;
    });
    // Log the lookup result
    if (context.mounted) {
      final settings = context.read<SettingsProvider>().settings;
      if (settings.loggingEnabled) {
        await LogService.createLog(
          function: 'whois',
          content: _buf.toString(),
          summary: 'Who Is → ${_ctrl.text.trim()}',
        );
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _put(String s) => _buf.writeln(s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Who Is…',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Who Is',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MarkdownInfoScreen(
                  title: 'About Who Is',
                  assetPath: 'assets/whois_info.md',
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
                    onSubmitted: (_) => _loading ? null : _lookup(),
                    enabled: !_loading,
                    decoration: InputDecoration(
                      hintText: 'Domain, IP address, or hostname',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _loading ? null : _lookup,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: Text(_loading ? 'Looking up…' : 'Look up'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buf.isEmpty && !_loading
                ? const Center(
                    child: Text(
                      'Enter a domain, IP, or hostname',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: SelectableText(
                      _buf.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

