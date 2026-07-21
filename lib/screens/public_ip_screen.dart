import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/widgets/pulsing_icon.dart';

// ════════════════════════════════════════════════════════════════════
//  2. PUBLIC IP
// ════════════════════════════════════════════════════════════════════

class PublicIpScreen extends StatefulWidget {
  const PublicIpScreen({super.key});
  @override
  State<PublicIpScreen> createState() => _PublicIpState();
}

class _PublicIpState extends State<PublicIpScreen> {
  Map<String, String>? _info;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('https://ipinfo.io/json'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        setState(() {
          _info = data.map((k, v) => MapEntry(k, v.toString()));
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'HTTP ${res.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.myPublicIp,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: PulsingIcon(
              enabled: !_loading,
              child: const Icon(Icons.refresh),
            ),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('${l.errorLabel}: $_error'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: (_info ?? {}).entries
                  .expand(
                    (e) => [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SelectableText(
                          e.value,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  )
                  .toList(),
            ),
    );
  }
}

