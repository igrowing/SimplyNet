import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:simply_net/services/network_scanner.dart';

/// Quick socket sweep that finds the first host on a subnet answering on a
/// given TCP port — used to auto-discover an MQTT broker's IP address.
class MqttBrokerScanner {
  MqttBrokerScanner._();

  static const _timeout = Duration(milliseconds: 300);
  static const _parallelism = 64;

  /// Scan [cidr] for the lowest-numbered host that accepts a TCP connection on
  /// [port]. Returns that host's IP, or null when nothing answered (or when the
  /// inputs are invalid / running on web where raw sockets are unavailable).
  static Future<String?> findBroker(
    String cidr,
    int port, {
    Duration timeout = _timeout,
  }) async {
    if (kIsWeb) return null;
    if (port <= 0 || port > 65535) return null;
    final hosts = NetworkScanner.hostsInCidr(cidr);
    if (hosts.isEmpty) return null;

    // Probe in bounded-concurrency chunks. Hosts are in ascending-IP order, so
    // the first responding host within a chunk is the lowest-numbered one.
    for (var i = 0; i < hosts.length; i += _parallelism) {
      final chunk = hosts.skip(i).take(_parallelism).toList();
      final answered = await Future.wait(
        chunk.map((ip) => _probe(ip, port, timeout)),
      );
      for (var j = 0; j < chunk.length; j++) {
        if (answered[j]) return chunk[j];
      }
    }
    return null;
  }

  static Future<bool> _probe(String ip, int port, Duration timeout) async {
    try {
      final sock = await Socket.connect(ip, port, timeout: timeout);
      sock.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}
