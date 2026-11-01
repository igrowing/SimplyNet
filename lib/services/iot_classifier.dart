import 'package:flutter/foundation.dart';
import 'package:simply_net/constants/iot_signatures.dart';
import 'package:simply_net/services/network_scanner.dart';

/// Outcome of classifying one host as an IoT device.
@immutable
class IotClassification {
  /// Creates a classification result.
  const IotClassification({
    required this.label,
    required this.confidence,
    required this.method,
  });

  /// Category or firmware shown to the user, e.g. `Tasmota`.
  final String label;

  /// How certain the classification is.
  final IotConfidence confidence;

  /// Human-readable evidence, e.g. `hostname + port 22`.
  final String method;
}

/// Pure evidence-scoring classifier for IoT devices.
///
/// Combines independent signals — hostname signature, MAC in the hostname,
/// IoT vendor (OUI), open ports and HTTP fingerprint — into a label and a
/// confidence. One signal is `possible`, two are `probable`, three or a
/// conclusive signal (HTTP fingerprint, hostname equal to the MAC, or a
/// signature's definite port) are `definite`.
abstract final class IotClassifier {
  static final _nonAlnum = RegExp('[^a-z0-9]+');

  /// Lower-cased alphanumeric tokens of the leftmost DNS label.
  static List<String> hostnameTokens(String hostname) => hostname
      .trim()
      .toLowerCase()
      .split('.')
      .first
      .split(_nonAlnum)
      .where((t) => t.isNotEmpty)
      .toList();

  /// True when [token] equals [keyword] or is [keyword] followed by a digit.
  /// Keywords of four or more letters also match their `-s`/`-es` plural,
  /// optionally followed by digits (`lights`, `switches`, `plugs2`); shorter
  /// ones do not, so `ha` never matches `has`.
  static bool tokenMatches(String token, String keyword) {
    if (token == keyword) return true;
    if (token.length <= keyword.length || !token.startsWith(keyword)) {
      return false;
    }
    var rest = token.substring(keyword.length);
    if (keyword.length >= 4) {
      final plural = rest.startsWith('es')
          ? 2
          : rest.startsWith('s')
          ? 1
          : 0;
      rest = rest.substring(plural);
      if (rest.isEmpty) return true;
    }
    final next = rest.codeUnitAt(0);
    return next >= 0x30 && next <= 0x39;
  }

  /// Classifies a host from the evidence gathered by the scanner.
  ///
  /// [mac] is the device MAC from any source (`''` or `N/A` when unknown),
  /// [vendor] its OUI vendor name (`''` when unknown) and [httpProtocol] the
  /// firmware recognised from its web page, if any. Returns null when there
  /// is no IoT evidence at all.
  static IotClassification? classify({
    required String hostname,
    required String mac,
    required String vendor,
    required List<int> openPorts,
    String? httpProtocol,
  }) {
    final lowerHost = hostname.trim().toLowerCase();
    final tokens = hostnameTokens(hostname);
    final ports = openPorts.toSet();
    final evidence = <String>[];
    var score = 0;
    var conclusive = false;

    // HTTP fingerprint — conclusive, and the most specific label.
    String? label = httpProtocol;
    if (httpProtocol != null) {
      conclusive = true;
      evidence.add('HTTP/$httpProtocol');
    }

    // Best hostname signature.
    final best = _bestSignature(lowerHost, tokens, ports);
    if (best != null) {
      label ??= best.signature.label;
      score += best.score;
      conclusive = conclusive || best.definite;
      evidence.addAll(best.evidence);
    }

    // Device MAC embedded anywhere in the hostname.
    final macHex = mac.replaceAll(':', '').toLowerCase();
    final macInHost =
        RegExp(r'^[0-9a-f]{12}$').hasMatch(macHex) &&
        lowerHost.contains(macHex);
    if (macInHost) {
      conclusive = true;
      label ??= IotSignatures.smartPlug.label;
      evidence.add('MAC in hostname');
    } else if (NetworkScanner.macFromHostname(hostname) != null) {
      score++;
      label ??= IotSignatures.smartPlug.label;
      evidence.add('MAC in hostname');
    }

    // IoT chip or brand vendor from the OUI database.
    if (NetworkScanner.detectDeviceType(vendor) == 'IoT Device') {
      score++;
      evidence.add('OUI');
    }

    // Tasmota rule: an Espressif/Beken device with port 80 open.
    final lowerVendor = vendor.toLowerCase();
    final espOrBeken =
        best?.signature == IotSignatures.espressif ||
        best?.signature == IotSignatures.beken ||
        (best == null &&
            (lowerVendor.contains('espressif') ||
                lowerVendor.contains('beken')));
    if (httpProtocol == null && espOrBeken && ports.contains(80)) {
      label = IotSignatures.tasmota.label;
      score++;
      evidence.add('port 80');
    }

    // A port that identifies an IoT service on its own.
    if (label == null) {
      for (final entry in IotSignatures.identifyingPorts.entries) {
        if (ports.contains(entry.key)) {
          label = entry.value;
          score += IotSignatures.probablePorts.contains(entry.key) ? 2 : 1;
          evidence.add('port ${entry.key}');
          break;
        }
      }
    }

    // Matter over TCP — conclusive, combined with any other label.
    if (ports.any(IotSignatures.matterPorts.contains)) {
      conclusive = true;
      label = label == null ? 'Matter device' : '$label + Matter';
      evidence.add('Matter port');
    }

    if (score == 0 && !conclusive) return null;
    final confidence = conclusive || score >= 3
        ? IotConfidence.definite
        : score == 2
        ? IotConfidence.probable
        : IotConfidence.possible;
    return IotClassification(
      label: label ?? 'IoT device',
      confidence: confidence,
      method: evidence.join(' + '),
    );
  }

  /// The signature with the strongest hostname match, or null. Ranks a
  /// definite-port match first, then the higher score; ties keep the
  /// catalogue order.
  static _SignatureMatch? _bestSignature(
    String lowerHost,
    List<String> tokens,
    Set<int> ports,
  ) {
    bool anyToken(Set<String> keywords) =>
        tokens.any((t) => keywords.any((k) => tokenMatches(t, k)));

    _SignatureMatch? best;
    for (final sig in IotSignatures.all) {
      final definite = ports.any(sig.definitePorts.contains);
      final hit =
          sig.substrings.any(lowerHost.contains) ||
          anyToken(sig.tokens) ||
          (definite && anyToken(sig.portGatedTokens));
      if (!hit) continue;

      final evidence = ['hostname'];
      final support = sig.supportPorts.where(ports.contains).toList();
      if (support.isNotEmpty) evidence.add('port ${support.first}');
      if (definite) {
        evidence.add('port ${sig.definitePorts.firstWhere(ports.contains)}');
      }
      final match = _SignatureMatch(
        signature: sig,
        score: support.isEmpty ? 1 : 2,
        definite: definite,
        evidence: evidence,
      );
      if (best == null || match._outranks(best)) best = match;
    }
    return best;
  }
}

/// A hostname signature hit with its port corroboration.
@immutable
class _SignatureMatch {
  const _SignatureMatch({
    required this.signature,
    required this.score,
    required this.definite,
    required this.evidence,
  });

  final IotSignature signature;
  final int score;
  final bool definite;
  final List<String> evidence;

  bool _outranks(_SignatureMatch other) {
    if (definite != other.definite) return definite;
    return score > other.score;
  }
}
