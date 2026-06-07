import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_net/services/log_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Shared MQTT connection settings (broker, auth).
//  Topic is NOT stored here — each screen keeps its own topic independently.
// ════════════════════════════════════════════════════════════════════════════

/// Persisted MQTT broker configuration.  Survives app restart via SharedPreferences.
/// Topic is intentionally absent — Sub and Pub each persist their own topic.
class MqttSettings {
  final String broker;
  final int    port;
  final String username;
  final String password;
  final bool   keepPassword;

  const MqttSettings({
    this.broker      = '',
    this.port        = 1883,
    this.username    = '',
    this.password    = '',
    this.keepPassword = false,
  });

  bool get isEmpty => broker.isEmpty;

  static const _kBroker   = 'mqtt_broker';
  static const _kPort     = 'mqtt_port';
  static const _kUsername = 'mqtt_username';
  static const _kPassword = 'mqtt_password';
  static const _kKeepPwd  = 'mqtt_keep_password';

  static Future<MqttSettings> load() async {
    final p = await SharedPreferences.getInstance();
    final keepPwd = p.getBool(_kKeepPwd) ?? false;
    return MqttSettings(
      broker:       p.getString(_kBroker)   ?? '',
      port:         p.getInt(_kPort)        ?? 1883,
      username:     p.getString(_kUsername) ?? '',
      password:     keepPwd ? (p.getString(_kPassword) ?? '') : '',
      keepPassword: keepPwd,
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
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Screen keep-on helper
//  Reuses the existing MethodChannel already wired in MainActivity.kt.
// ════════════════════════════════════════════════════════════════════════════

class _ScreenKeepOn {
  static const _ch = MethodChannel('com.simplytools.simplynet/screen');
  static Future<void> enable()         async =>
      _ch.invokeMethod('setScreenTimeout', {'mode': 1}).catchError((_) {});
  static Future<void> restore(int mode) async =>
      _ch.invokeMethod('setScreenTimeout', {'mode': mode}).catchError((_) {});
}

// ════════════════════════════════════════════════════════════════════════════
//  MQTT settings dialog (broker, port, auth only — no topic)
// ════════════════════════════════════════════════════════════════════════════

Future<MqttSettings?> showMqttSettingsDialog(
  BuildContext context,
  MqttSettings current,
) =>
    showModalBottomSheet<MqttSettings>(
      context:            context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _MqttSettingsSheet(current: current),
    );

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
    _keepPassword = s.keepPassword;
  }

  @override
  void dispose() {
    _brokerCtrl.dispose(); _portCtrl.dispose();
    _userCtrl.dispose();   _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final settings = MqttSettings(
      broker:      _brokerCtrl.text.trim(),
      port:        int.tryParse(_portCtrl.text.trim()) ?? 1883,
      username:    _userCtrl.text.trim(),
      password:    _pwdCtrl.text,
      keepPassword: _keepPassword,
    );
    await settings.save();
    if (mounted) Navigator.pop(context, settings);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: mq.viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.settings_input_antenna),
              const SizedBox(width: 10),
              Text('MQTT Settings',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 20),
            _field(controller: _brokerCtrl,
                label: 'Broker IP / FQDN',
                hint: 'e.g. 192.168.1.10 or broker.example.com',
                keyboard: TextInputType.url),
            const SizedBox(height: 12),
            _field(controller: _portCtrl,
                label: 'Port', hint: '1883',
                keyboard: TextInputType.number),
            const SizedBox(height: 12),
            _field(controller: _userCtrl,
                label: 'Username (optional)',
                hint: 'leave empty if not required'),
            const SizedBox(height: 12),
            TextField(
              controller:  _pwdCtrl,
              obscureText: _obscurePwd,
              decoration: InputDecoration(
                labelText: 'Password (optional)',
                hintText:  'leave empty if not required',
                border: OutlineInputBorder(
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
            const SizedBox(height: 24),
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
        controller:   controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          hintText:  hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
      );
}

// ════════════════════════════════════════════════════════════════════════════
//  Shared AppBar actions
// ════════════════════════════════════════════════════════════════════════════

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
//  Shared status-bar widget
// ════════════════════════════════════════════════════════════════════════════

class _MqttStatusBar extends StatelessWidget {
  final bool connected;
  final bool connecting;
  final String message;

  const _MqttStatusBar({
    required this.connected,
    required this.connecting,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final color = connected
        ? Colors.green
        : (connecting ? Colors.orange : Colors.red);
    return Container(
      color: color.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(children: [
        Icon(
          connected
              ? Icons.check_circle_outline
              : (connecting
                  ? Icons.hourglass_top_outlined
                  : Icons.error_outline),
          size: 16, color: color,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(message,
              style: TextStyle(fontSize: 12, color: color)),
        ),
        if (connecting)
          const SizedBox(width: 14, height: 14,
              child: CircularProgressIndicator(strokeWidth: 2)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  MQTT Subscribe screen
// ════════════════════════════════════════════════════════════════════════════

class MqttSubScreen extends StatefulWidget {
  final int appScreenTimeoutMode;
  const MqttSubScreen({super.key, this.appScreenTimeoutMode = 0});
  @override
  State<MqttSubScreen> createState() => _MqttSubScreenState();
}


class _MqttSubScreenState extends State<MqttSubScreen> {
  // ── Persistence keys ───────────────────────────────────────────────────
  static const _kSubTopic      = 'mqtt_sub_topic';
  static const _kSubPrettyJson = 'mqtt_sub_pretty_json';

  MqttSettings _cfg    = const MqttSettings();
  bool         _loaded = false;

  // ── Own topic ──────────────────────────────────────────────────────────
  final _topicCtrl = TextEditingController();

  // ── MQTT client ────────────────────────────────────────────────────────
  MqttServerClient? _client;
  StreamSubscription? _msgSub;

  bool   _listening  = false;   // true while actively connected + subscribed
  bool   _connecting = false;
  String _statusMsg  = '';

  // ── UI state ───────────────────────────────────────────────────────────
  // Messages are stored newest-first (index 0 = most recent).
  final List<String>    _messages   = [];
  final ScrollController _scroll    = ScrollController();
  bool _keepScreenOn = false;
  bool _prettyJson   = true;

  // ── Session log buffer — flushed to LogService on Stop ─────────────────
  final StringBuffer _sessionLog = StringBuffer();
  DateTime?          _sessionStart;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    // If the user backs out while listening, end the session and log it.
    if (_listening) _flushSessionLog();
    _cancelMsgSub();
    _disconnectClient();
    if (_keepScreenOn) _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    _topicCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ── Persistence ──────────────────────────────────────────────────────────

  Future<void> _loadPrefs() async {
    final p   = await SharedPreferences.getInstance();
    final cfg = await MqttSettings.load();
    if (!mounted) return;
    setState(() {
      _cfg            = cfg;
      _loaded         = true;
      _topicCtrl.text = p.getString(_kSubTopic)   ?? '';
      _prettyJson     = p.getBool(_kSubPrettyJson) ?? true;
    });
    // Open settings immediately if broker is not yet configured.
    // Do NOT auto-start listening — user controls that explicitly.
    if (cfg.isEmpty) await _openSettings();
  }

  Future<void> _saveTopic(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kSubTopic, v.trim());
  }

  Future<void> _savePrettyJson(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSubPrettyJson, v);
  }

  // ── Settings ─────────────────────────────────────────────────────────────

  Future<void> _openSettings() async {
    // Stop active session before changing connection params.
    if (_listening) await _stopListening();
    final updated = await showMqttSettingsDialog(context, _cfg);
    if (updated == null || !mounted) return;
    setState(() => _cfg = updated);
  }

  // ── Screen keep-on ────────────────────────────────────────────────────────

  Future<void> _toggleScreenOn() async {
    setState(() => _keepScreenOn = !_keepScreenOn);
    if (_keepScreenOn) {
      await _ScreenKeepOn.enable();
    } else {
      await _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    }
  }

  // ── Listen / Stop ─────────────────────────────────────────────────────────

  Future<void> _startListening() async {
    final topic = _topicCtrl.text.trim();
    if (_cfg.isEmpty) {
      await _openSettings();
      return;
    }
    if (topic.isEmpty) {
      setState(() => _statusMsg = 'Enter a topic first.');
      return;
    }
    _sessionLog.clear();
    _sessionStart = DateTime.now();
    _connect(topic);
  }

  Future<void> _stopListening() async {
    _cancelMsgSub();
    _disconnectClient();
    setState(() {
      _listening  = false;
      _connecting = false;
      _statusMsg  = 'Stopped.';
    });
    await _flushSessionLog();
  }

  void _toggleListening() {
    if (_listening || _connecting) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  // ── MQTT connection ───────────────────────────────────────────────────────

  void _connect(String topic) {
    setState(() { _connecting = true; _statusMsg = 'Connecting…'; });

    final clientId = 'sn_sub_${DateTime.now().millisecondsSinceEpoch}';
    final client   = MqttServerClient(_cfg.broker, clientId)
      ..port            = _cfg.port
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..onConnected     = () => _onConnected(topic)
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
      if (mounted) setState(() {
        _listening  = false;
        _connecting = false;
        _statusMsg  = 'Connection failed: $e';
      });
    });
  }

  void _onConnected(String topic) {
    if (!mounted) return;
    setState(() {
      _listening  = true;
      _connecting = false;
      _statusMsg  = 'Listening on "$topic"';
    });
    _client!.subscribe(topic, MqttQos.atLeastOnce);

    // Cancel any stale subscription before attaching the new one.
    _cancelMsgSub();
    _msgSub = _client!.updates!.listen(_onMessage);
  }

  void _onDisconnected() {
    // Only update UI if we didn't stop intentionally
    // (_stopListening sets _listening=false before disconnecting).
    if (!mounted) return;
    if (_listening) {
      setState(() => _statusMsg = 'Reconnecting…');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? msgs) {
    if (msgs == null || !mounted) return;
    for (final m in msgs) {
      final pub   = m.payload as MqttPublishMessage;
      final raw   = MqttPublishPayload.bytesToStringAsString(
                        pub.payload.message);
      final body  = _prettyJson ? _tryPrettyJson(raw) : raw;
      final entry = '[${_timestamp()}]  ${m.topic}\n$body';

      // Newest at top — insert at index 0.
      setState(() => _messages.insert(0, entry));

      // Accumulate into session buffer (chronological order for the log).
      _sessionLog.writeln(entry);
    }
  }

  void _cancelMsgSub() {
    _msgSub?.cancel();
    _msgSub = null;
  }

  void _disconnectClient() {
    _client?.disconnect();
    _client = null;
  }

  // ── Session logging ───────────────────────────────────────────────────────

  Future<void> _flushSessionLog() async {
    if (_sessionLog.isEmpty) return;
    final topic    = _topicCtrl.text.trim();
    final start    = _sessionStart;
    final duration = start == null
        ? ''
        : ' (${DateTime.now().difference(start).inSeconds}s)';
    await LogService.createLog(
      function: 'mqtt_sub',
      content:  _sessionLog.toString(),
      summary:  'MQTT Sub [$topic]$duration: ${_messages.length} message(s)',
    );
    _sessionLog.clear();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _tryPrettyJson(String raw) {
    try {
      return const JsonEncoder.withIndent('  ').convert(json.decode(raw));
    } catch (_) {
      return raw;
    }
  }

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
           '${now.minute.toString().padLeft(2, '0')}:'
           '${now.second.toString().padLeft(2, '0')}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isActive = _listening || _connecting;
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
                _MqttStatusBar(
                    connected: _listening,
                    connecting: _connecting,
                    message: _statusMsg),

                // ── Topic + Listen/Stop ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        controller:      _topicCtrl,
                        enabled:         !isActive,
                        textInputAction: TextInputAction.go,
                        onChanged:       _saveTopic,
                        onSubmitted:     (_) {
                          if (!isActive) _startListening();
                        },
                        decoration: InputDecoration(
                          labelText: 'Topic',
                          hintText:  'e.g. home/sensor/# or home/sensor/temp',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _toggleListening,
                      style: FilledButton.styleFrom(
                        backgroundColor: isActive
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(80, 40),
                      ),
                      icon: Icon(isActive ? Icons.stop : Icons.hearing),
                      label: Text(isActive ? 'Stop' : 'Listen'),
                    ),
                  ]),
                ),

                // ── Controls row ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  child: Row(children: [
                    Expanded(
                      child: CheckboxListTile(
                        value:    _prettyJson,
                        onChanged: (v) {
                          final val = v ?? true;
                          setState(() => _prettyJson = val);
                          _savePrettyJson(val);
                        },
                        title: const Text('Human-readable JSON',
                            style: TextStyle(fontSize: 13)),
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    if (_messages.isNotEmpty)
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _messages.clear()),
                        icon:  const Icon(Icons.clear_all, size: 18),
                        label: const Text('Clear'),
                      ),
                  ]),
                ),

                // ── Messages area (newest at top, scrollbar on right) ──────
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            isActive
                                ? 'Waiting for messages…'
                                : (_topicCtrl.text.trim().isEmpty
                                    ? 'Enter a topic and tap Listen'
                                    : 'Tap Listen to start receiving'),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.4)),
                          ),
                        )
                      : Scrollbar(
                          controller:    _scroll,
                          thumbVisibility: true,
                          child: ListView.separated(
                            controller:  _scroll,
                            padding: const EdgeInsets.fromLTRB(12, 4, 20, 12),
                            itemCount:   _messages.length,
                            separatorBuilder: (_, _2) =>
                                const Divider(height: 8, thickness: 0.5),
                            itemBuilder: (_, i) => SelectableText(
                              _messages[i],
                              style: const TextStyle(
                                  fontSize: 12, fontFamily: 'monospace'),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}


// ════════════════════════════════════════════════════════════════════════════
//  MQTT Publish screen
// ════════════════════════════════════════════════════════════════════════════

class MqttPubScreen extends StatefulWidget {
  final int appScreenTimeoutMode;
  const MqttPubScreen({super.key, this.appScreenTimeoutMode = 0});
  @override
  State<MqttPubScreen> createState() => _MqttPubScreenState();
}

class _MqttPubScreenState extends State<MqttPubScreen> {
  // ── Persistence keys ───────────────────────────────────────────────────
  static const _kPubTopic   = 'mqtt_pub_topic';
  static const _kPubMessage = 'mqtt_pub_message';
  static const _kPubRetain  = 'mqtt_pub_retain';

  MqttSettings _cfg    = const MqttSettings();
  bool         _loaded = false;

  // ── Own topic (separate from Sub) ──────────────────────────────────────
  final _topicCtrl = TextEditingController();
  final _msgCtrl   = TextEditingController();

  // ── MQTT client ────────────────────────────────────────────────────────
  MqttServerClient? _client;
  bool   _connected  = false;
  bool   _connecting = false;
  String _statusMsg  = '';

  // ── UI state ───────────────────────────────────────────────────────────
  bool _keepScreenOn = false;
  bool _retain       = false;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    _disconnectClient();
    if (_keepScreenOn) _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    _topicCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  // ── Persistence ──────────────────────────────────────────────────────────

  Future<void> _loadPrefs() async {
    final p   = await SharedPreferences.getInstance();
    final cfg = await MqttSettings.load();
    if (!mounted) return;
    setState(() {
      _cfg             = cfg;
      _loaded          = true;
      _topicCtrl.text  = p.getString(_kPubTopic)   ?? '';
      _msgCtrl.text    = p.getString(_kPubMessage)  ?? '';
      _retain          = p.getBool(_kPubRetain)     ?? false;
    });
    if (cfg.isEmpty) {
      await _openSettings();
    } else {
      _connect();
    }
  }

  Future<void> _saveTopic(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kPubTopic, v.trim());
  }

  Future<void> _saveMessage(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kPubMessage, v);
  }

  Future<void> _saveRetain(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kPubRetain, v);
  }

  // ── Settings ─────────────────────────────────────────────────────────────

  Future<void> _openSettings() async {
    final updated = await showMqttSettingsDialog(context, _cfg);
    if (updated == null || !mounted) return;
    setState(() => _cfg = updated);
    _disconnectClient();
    _connect();
  }

  // ── Screen keep-on ────────────────────────────────────────────────────────

  Future<void> _toggleScreenOn() async {
    setState(() => _keepScreenOn = !_keepScreenOn);
    if (_keepScreenOn) {
      await _ScreenKeepOn.enable();
    } else {
      await _ScreenKeepOn.restore(widget.appScreenTimeoutMode);
    }
  }

  // ── MQTT connection ───────────────────────────────────────────────────────

  void _connect() {
    if (_cfg.isEmpty) return;
    setState(() { _connecting = true; _statusMsg = 'Connecting…'; });

    final clientId = 'sn_pub_${DateTime.now().millisecondsSinceEpoch}';
    final client   = MqttServerClient(_cfg.broker, clientId)
      ..port            = _cfg.port
      ..keepAlivePeriod = 20
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
      if (mounted) setState(() {
        _connecting = false;
        _statusMsg  = 'Connection failed: $e';
      });
    });
  }

  void _onConnected() {
    if (!mounted) return;
    final topic = _topicCtrl.text.trim();
    setState(() {
      _connected  = true;
      _connecting = false;
      _statusMsg  = topic.isEmpty
          ? 'Connected — enter a topic below'
          : 'Connected — topic: "$topic"';
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

  void _disconnectClient() {
    _client?.disconnect();
    _client = null;
  }

  // ── Publish ───────────────────────────────────────────────────────────────

  Future<void> _publish() async {
    if (!_connected || _client == null) return;
    final topic = _topicCtrl.text.trim();
    final msg   = _msgCtrl.text;
    if (topic.isEmpty || msg.isEmpty) return;

    final builder = MqttClientPayloadBuilder()..addString(msg);
    _client!.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: _retain,
    );

    // Log the publish action
    await LogService.createLog(
      function: 'mqtt_pub',
      content:  msg,
      summary:  'MQTT Pub [$topic]${_retain ? " (retained)" : ""}',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Published to "$topic"'),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _MqttStatusBar(
                      connected: _connected,
                      connecting: _connecting,
                      message: _statusMsg),
                  const SizedBox(height: 12),

                  // ── Topic (editable, per-screen) ───────────────────────
                  TextField(
                    controller:      _topicCtrl,
                    textInputAction: TextInputAction.next,
                    onChanged:       _saveTopic,
                    onEditingComplete: () {
                      final topic = _topicCtrl.text.trim();
                      if (mounted && _connected) {
                        setState(() => _statusMsg =
                            topic.isEmpty
                                ? 'Connected — enter a topic below'
                                : 'Connected — topic: "$topic"');
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Topic',
                      hintText:  'e.g. home/light/switch',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Message ────────────────────────────────────────────
                  TextField(
                    controller: _msgCtrl,
                    maxLines:   5,
                    onChanged:  _saveMessage,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      hintText:  'Enter payload…',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ── Retain ─────────────────────────────────────────────
                  CheckboxListTile(
                    value:    _retain,
                    onChanged: (v) {
                      final val = v ?? false;
                      setState(() => _retain = val);
                      _saveRetain(val);
                    },
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

                  // ── Publish button ─────────────────────────────────────
                  FilledButton.icon(
                    onPressed: (_connected &&
                                _topicCtrl.text.trim().isNotEmpty &&
                                _msgCtrl.text.isNotEmpty)
                        ? _publish
                        : null,
                    icon:  const Icon(Icons.send_outlined),
                    label: const Text('Publish'),
                  ),
                ],
              ),
            ),
    );
  }
}
