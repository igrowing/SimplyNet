import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Shared MQTT settings model
// ════════════════════════════════════════════════════════════════════════════

/// Persisted MQTT configuration.  Survives app restart via SharedPreferences.
class MqttSettings {
  final String  broker;
  final int     port;
  final String  username;
  final String  password;
  final bool    keepPassword;
  final String  topic;

  const MqttSettings({
    this.broker      = '',
    this.port        = 1883,
    this.username    = '',
    this.password    = '',
    this.keepPassword = false,
    this.topic       = '',
  });

  bool get isEmpty => broker.isEmpty;

  static const _kBroker      = 'mqtt_broker';
  static const _kPort        = 'mqtt_port';
  static const _kUsername    = 'mqtt_username';
  static const _kPassword    = 'mqtt_password';
  static const _kKeepPwd     = 'mqtt_keep_password';
  static const _kTopic       = 'mqtt_topic';

  static Future<MqttSettings> load() async {
    final p = await SharedPreferences.getInstance();
    final keepPwd = p.getBool(_kKeepPwd) ?? false;
    return MqttSettings(
      broker:       p.getString(_kBroker)   ?? '',
      port:         p.getInt(_kPort)        ?? 1883,
      username:     p.getString(_kUsername) ?? '',
      password:     keepPwd ? (p.getString(_kPassword) ?? '') : '',
      keepPassword: keepPwd,
      topic:        p.getString(_kTopic)    ?? '',
    );
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kBroker,   broker);
    await p.setInt   (_kPort,     port);
    await p.setString(_kUsername, username);
    await p.setBool  (_kKeepPwd,  keepPassword);
    if (keepPassword) {
      await p.setString(_kPassword, password);
    } else {
      await p.remove(_kPassword);
    }
    await p.setString(_kTopic, topic);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Screen keep-on helper
//  Reuses the existing MethodChannel already wired in MainActivity.kt.
// ════════════════════════════════════════════════════════════════════════════

class _ScreenKeepOn {
  static const _ch = MethodChannel('com.simplytools.simplynet/screen');

  static Future<void> enable()  async {
    try { await _ch.invokeMethod('setScreenTimeout', {'mode': 1}); } catch (_) {}
  }

  static Future<void> restore(int appMode) async {
    try { await _ch.invokeMethod('setScreenTimeout', {'mode': appMode}); } catch (_) {}
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  MQTT settings dialog
// ════════════════════════════════════════════════════════════════════════════

/// Shows a modal bottom-sheet with all MQTT configuration fields.
/// Returns the saved [MqttSettings] or null if the user dismissed without saving.
Future<MqttSettings?> showMqttSettingsDialog(
  BuildContext context,
  MqttSettings current,
) async {
  return showModalBottomSheet<MqttSettings>(
    context:       context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _MqttSettingsSheet(current: current),
  );
}

class _MqttSettingsSheet extends StatefulWidget {
  final MqttSettings current;
  const _MqttSettingsSheet({required this.current});

  @override
  State<_MqttSettingsSheet> createState() => _MqttSettingsSheetState();
}

class _MqttSettingsSheetState extends State<_MqttSettingsSheet> {
  late final TextEditingController _brokerCtrl;
  late final TextEditingController _portCtrl;
  late final TextEditingController _userCtrl;
  late final TextEditingController _pwdCtrl;
  late final TextEditingController _topicCtrl;
  late bool _keepPassword;
  bool _obscurePwd = true;

  @override
  void initState() {
    super.initState();
    final s = widget.current;
    _brokerCtrl   = TextEditingController(text: s.broker);
    _portCtrl     = TextEditingController(text: s.port.toString());
    _userCtrl     = TextEditingController(text: s.username);
    _pwdCtrl      = TextEditingController(text: s.password);
    _topicCtrl    = TextEditingController(text: s.topic);
    _keepPassword = s.keepPassword;
  }

  @override
  void dispose() {
    _brokerCtrl.dispose(); _portCtrl.dispose(); _userCtrl.dispose();
    _pwdCtrl.dispose();    _topicCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final settings = MqttSettings(
      broker:      _brokerCtrl.text.trim(),
      port:        int.tryParse(_portCtrl.text.trim()) ?? 1883,
      username:    _userCtrl.text.trim(),
      password:    _pwdCtrl.text,
      keepPassword: _keepPassword,
      topic:       _topicCtrl.text.trim(),
    );
    await settings.save();
    if (mounted) Navigator.pop(context, settings);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Padding(
      // Push content above keyboard
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: mq.viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(children: [
              const Icon(Icons.settings_input_antenna),
              const SizedBox(width: 10),
              Text('MQTT Settings',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 20),

            // Broker
            _field(controller: _brokerCtrl,
                   label: 'Broker IP / FQDN',
                   hint:  'e.g. 192.168.1.10 or broker.example.com',
                   keyboard: TextInputType.url),
            const SizedBox(height: 12),

            // Port
            _field(controller: _portCtrl,
                   label: 'Port',
                   hint:  '1883',
                   keyboard: TextInputType.number),
            const SizedBox(height: 12),

            // Username (optional)
            _field(controller: _userCtrl,
                   label: 'Username (optional)',
                   hint:  'leave empty if not required'),
            const SizedBox(height: 12),

            // Password (optional)
            TextField(
              controller:    _pwdCtrl,
              obscureText:   _obscurePwd,
              decoration: InputDecoration(
                labelText:   'Password (optional)',
                hintText:    'leave empty if not required',
                border:      OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePwd
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () =>
                      setState(() => _obscurePwd = !_obscurePwd),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Keep password checkbox
            CheckboxListTile(
              value:    _keepPassword,
              onChanged: (v) => setState(() => _keepPassword = v ?? false),
              title: const Text('Keep password (not recommended)',
                  style: TextStyle(fontSize: 13)),
              subtitle: const Text(
                  'Password is stored in plain text in app storage.',
                  style: TextStyle(fontSize: 11)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: 12),

            // Topic
            _field(controller: _topicCtrl,
                   label: 'Topic',
                   hint:  'e.g. home/sensor/temperature'),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon:  const Icon(Icons.save_outlined),
                label: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) =>
      TextField(
        controller:  controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          hintText:  hint,
          border:    OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
      );
}

// ════════════════════════════════════════════════════════════════════════════
//  AppBar actions shared by both Pub and Sub screens
// ════════════════════════════════════════════════════════════════════════════

/// Builds the two right-hand AppBar actions (keep-screen-on toggle + gear).
List<Widget> mqttAppBarActions({
  required bool keepScreenOn,
  required VoidCallback onToggleScreen,
  required VoidCallback onSettings,
}) =>
    [
      IconButton(
        icon: Icon(
          keepScreenOn ? Icons.light_mode : Icons.light_mode_outlined,
          color: keepScreenOn ? Colors.amber : null,
        ),
        tooltip: keepScreenOn ? 'Screen stays on' : 'Screen may sleep',
        onPressed: onToggleScreen,
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        tooltip: 'MQTT settings',
        onPressed: onSettings,
      ),
    ];

// ════════════════════════════════════════════════════════════════════════════
//  MQTT Subscriber screen
// ════════════════════════════════════════════════════════════════════════════

class MqttSubScreen extends StatefulWidget {
  /// App-level screen-timeout mode index (from AppSettings.screenTimeout).
  final int appScreenTimeoutMode;

  const MqttSubScreen({super.key, this.appScreenTimeoutMode = 0});

  @override
  State<MqttSubScreen> createState() => _MqttSubScreenState();
}

class _MqttSubScreenState extends State<MqttSubScreen> {
  MqttSettings  _cfg         = const MqttSettings();
  bool          _loaded       = false;

  MqttServerClient? _client;
  bool   _connected   = false;
  bool   _connecting  = false;
  String _statusMsg   = '';
  final  List<String> _messages = [];
  final  ScrollController _scroll = ScrollController();

  bool   _keepScreenOn  = false;
  bool   _prettyJson    = true;   // "Human-readable JSON" checkbox

  @override
  void initState() {
    super.initState();
    _loadAndConnect();
  }

  @override
  void dispose() {
    _disconnect();
    if (_keepScreenOn) {
      _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    }
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadAndConnect() async {
    final cfg = await MqttSettings.load();
    if (!mounted) return;
    setState(() { _cfg = cfg; _loaded = true; });
    if (cfg.isEmpty) {
      // No broker configured yet — open settings immediately
      await _openSettings();
    } else {
      _connect();
    }
  }

  Future<void> _openSettings() async {
    final updated = await showMqttSettingsDialog(context, _cfg);
    if (updated == null || !mounted) return;
    setState(() => _cfg = updated);
    _disconnect();
    _connect();
  }

  Future<void> _toggleScreenOn() async {
    setState(() => _keepScreenOn = !_keepScreenOn);
    if (_keepScreenOn) {
      await _ScreenKeepOn.enable();
    } else {
      await _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    }
  }

  void _connect() {
    if (_cfg.isEmpty) return;
    setState(() { _connecting = true; _statusMsg = 'Connecting…'; });

    final clientId = 'simplynet_sub_${DateTime.now().millisecondsSinceEpoch}';
    final client = MqttServerClient(_cfg.broker, clientId)
      ..port           = _cfg.port
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..onConnected    = _onConnected
      ..onDisconnected = _onDisconnected
      ..onAutoReconnect  = () {
          if (mounted) setState(() => _statusMsg = 'Reconnecting…');
        }
      ..autoReconnect  = true;

    final connMsg = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    if (_cfg.username.isNotEmpty) {
      connMsg.authenticateAs(_cfg.username, _cfg.password);
    }

    client.connectionMessage = connMsg;
    _client = client;

    client.connect().catchError((e) {
      if (mounted) {
        setState(() {
          _connecting = false;
          _statusMsg  = 'Connection failed: $e';
        });
      }
    });
  }

  void _onConnected() {
    if (!mounted) return;
    setState(() {
      _connected  = true;
      _connecting = false;
      _statusMsg  = 'Subscribed to "${_cfg.topic}"';
    });
    _client!.subscribe(_cfg.topic, MqttQos.atLeastOnce);
    _client!.updates!.listen(_onMessage);
  }

  void _onDisconnected() {
    if (!mounted) return;
    setState(() {
      _connected  = false;
      _connecting = false;
      _statusMsg  = 'Disconnected';
    });
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? msgs) {
    if (msgs == null || !mounted) return;
    for (final m in msgs) {
      final pub     = m.payload as MqttPublishMessage;
      final raw     = MqttPublishPayload.bytesToStringAsString(
                          pub.payload.message);
      final display = _prettyJson ? _tryPrettyJson(raw) : raw;
      setState(() {
        _messages.add('[${_timestamp()}]  ${m.topic}\n$display');
      });
    }
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve:    Curves.easeOut);
      }
    });
  }

  String _tryPrettyJson(String raw) {
    try {
      final decoded = json.decode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2,'0')}:'
           '${now.minute.toString().padLeft(2,'0')}:'
           '${now.second.toString().padLeft(2,'0')}';
  }

  void _disconnect() {
    _client?.disconnect();
    _client = null;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _connected
        ? Colors.green
        : (_connecting ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Subscribe',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: mqttAppBarActions(
          keepScreenOn:   _keepScreenOn,
          onToggleScreen: _toggleScreenOn,
          onSettings:     _openSettings,
        ),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Status bar ─────────────────────────────────────────────
                Container(
                  color: statusColor.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  child: Row(children: [
                    Icon(
                      _connected
                          ? Icons.check_circle_outline
                          : (_connecting
                              ? Icons.hourglass_top_outlined
                              : Icons.error_outline),
                      size: 16, color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_statusMsg,
                          style: TextStyle(fontSize: 12,
                              color: statusColor)),
                    ),
                    if (_connecting)
                      const SizedBox(width: 14, height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                  ]),
                ),

                // ── Controls row ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: Row(children: [
                    // Human-readable JSON
                    Expanded(
                      child: CheckboxListTile(
                        value:    _prettyJson,
                        onChanged: (v) =>
                            setState(() => _prettyJson = v ?? true),
                        title: const Text('Human-readable JSON',
                            style: TextStyle(fontSize: 13)),
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    // Clear button
                    if (_messages.isNotEmpty)
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _messages.clear()),
                        icon:  const Icon(Icons.clear_all, size: 18),
                        label: const Text('Clear'),
                      ),
                  ]),
                ),

                // ── Messages area ──────────────────────────────────────────
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            _connected
                                ? 'Waiting for messages…'
                                : 'Not connected',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.4)),
                          ),
                        )
                      : ListView.separated(
                          controller:  _scroll,
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                          itemCount:   _messages.length,
                          separatorBuilder: (_, _2) =>
                              const Divider(height: 8, thickness: 0.5),
                          itemBuilder: (_, i) => SelectableText(
                            _messages[i],
                            style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace'),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  MQTT Publisher screen
// ════════════════════════════════════════════════════════════════════════════

class MqttPubScreen extends StatefulWidget {
  /// App-level screen-timeout mode index (from AppSettings.screenTimeout).
  final int appScreenTimeoutMode;

  const MqttPubScreen({super.key, this.appScreenTimeoutMode = 0});

  @override
  State<MqttPubScreen> createState() => _MqttPubScreenState();
}

class _MqttPubScreenState extends State<MqttPubScreen> {
  MqttSettings  _cfg    = const MqttSettings();
  bool          _loaded  = false;

  MqttServerClient? _client;
  bool   _connected  = false;
  bool   _connecting = false;
  String _statusMsg  = '';

  bool   _keepScreenOn = false;
  bool   _retain       = false;

  final _msgCtrl    = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAndConnect();
  }

  @override
  void dispose() {
    _disconnect();
    if (_keepScreenOn) {
      _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    }
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAndConnect() async {
    final cfg = await MqttSettings.load();
    if (!mounted) return;
    setState(() { _cfg = cfg; _loaded = true; });
    if (cfg.isEmpty) {
      await _openSettings();
    } else {
      _connect();
    }
  }

  Future<void> _openSettings() async {
    final updated = await showMqttSettingsDialog(context, _cfg);
    if (updated == null || !mounted) return;
    setState(() => _cfg = updated);
    _disconnect();
    _connect();
  }

  Future<void> _toggleScreenOn() async {
    setState(() => _keepScreenOn = !_keepScreenOn);
    if (_keepScreenOn) {
      await _ScreenKeepOn.enable();
    } else {
      await _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    }
  }

  void _connect() {
    if (_cfg.isEmpty) return;
    setState(() { _connecting = true; _statusMsg = 'Connecting…'; });

    final clientId = 'simplynet_pub_${DateTime.now().millisecondsSinceEpoch}';
    final client = MqttServerClient(_cfg.broker, clientId)
      ..port            = _cfg.port
      ..keepAlivePeriod  = 20
      ..logging(on: false)
      ..onConnected     = _onConnected
      ..onDisconnected  = _onDisconnected
      ..onAutoReconnect = () {
          if (mounted) setState(() => _statusMsg = 'Reconnecting…');
        }
      ..autoReconnect   = true;

    final connMsg = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    if (_cfg.username.isNotEmpty) {
      connMsg.authenticateAs(_cfg.username, _cfg.password);
    }

    client.connectionMessage = connMsg;
    _client = client;

    client.connect().catchError((e) {
      if (mounted) {
        setState(() {
          _connecting = false;
          _statusMsg  = 'Connection failed: $e';
        });
      }
    });
  }

  void _onConnected() {
    if (!mounted) return;
    setState(() {
      _connected  = true;
      _connecting = false;
      _statusMsg  = 'Connected — topic: "${_cfg.topic}"';
    });
  }

  void _onDisconnected() {
    if (!mounted) return;
    setState(() {
      _connected  = false;
      _connecting = false;
      _statusMsg  = 'Disconnected';
    });
  }

  void _publish() {
    if (!_connected || _client == null) return;
    final msg = _msgCtrl.text;
    if (msg.isEmpty) return;

    final builder = MqttClientPayloadBuilder()..addString(msg);
    _client!.publishMessage(
      _cfg.topic,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: _retain,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Published to "${_cfg.topic}"'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _disconnect() {
    _client?.disconnect();
    _client = null;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _connected
        ? Colors.green
        : (_connecting ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Publish',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: mqttAppBarActions(
          keepScreenOn:   _keepScreenOn,
          onToggleScreen: _toggleScreenOn,
          onSettings:     _openSettings,
        ),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Status bar ─────────────────────────────────────────────
                Container(
                  color: statusColor.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  child: Row(children: [
                    Icon(
                      _connected
                          ? Icons.check_circle_outline
                          : (_connecting
                              ? Icons.hourglass_top_outlined
                              : Icons.error_outline),
                      size: 16, color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_statusMsg,
                          style: TextStyle(fontSize: 12,
                              color: statusColor)),
                    ),
                    if (_connecting)
                      const SizedBox(width: 14, height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                  ]),
                ),

                // ── Publish form ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Topic display (read-only, from settings)
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Topic',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                          suffixIcon: Icon(Icons.lock_outline,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4)),
                        ),
                        child: Text(_cfg.topic.isEmpty ? '(not set)' : _cfg.topic,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: _cfg.topic.isEmpty
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.4)
                                  : null,
                            )),
                      ),
                      const SizedBox(height: 12),

                      // Message input
                      TextField(
                        controller: _msgCtrl,
                        maxLines:   5,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          hintText:  'Enter payload…',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Retain checkbox
                      CheckboxListTile(
                        value:    _retain,
                        onChanged: (v) =>
                            setState(() => _retain = v ?? false),
                        title: const Text('Retain',
                            style: TextStyle(fontSize: 13)),
                        subtitle: const Text(
                            'Broker keeps the last message for new subscribers.',
                            style: TextStyle(fontSize: 11)),
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                      const SizedBox(height: 12),

                      // Publish button
                      FilledButton.icon(
                        onPressed: _connected ? _publish : null,
                        icon:  const Icon(Icons.send_outlined),
                        label: const Text('Publish'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
