import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// Singleton service that manages persistent MQTT Sub connection.
/// The connection survives screen navigation and only closes when:
/// 1. User clicks Stop button
/// 2. App terminates
class MqttSubService {
  static final MqttSubService _instance = MqttSubService._internal();

  factory MqttSubService() {
    return _instance;
  }

  MqttSubService._internal();

  MqttServerClient? _client;
  StreamSubscription? _msgSub;

  MqttServerClient? get client => _client;

  StreamSubscription? get msgSub => _msgSub;

  /// Check if there's an active MQTT connection
  bool get isConnected =>
      _client != null &&
      _client!.connectionStatus?.state == MqttConnectionState.connected;

  void setClient(MqttServerClient client) {
    _client = client;
  }

  void setMsgSubscription(StreamSubscription? sub) {
    _msgSub = sub;
  }

  void cancelMsgSub() {
    _msgSub?.cancel();
    _msgSub = null;
  }

  void disconnect() {
    _msgSub?.cancel();
    _msgSub = null;
    _client?.disconnect();
    _client = null;
  }
}
