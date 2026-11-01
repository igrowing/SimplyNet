import 'package:simply_net/services/mdns_discovery.dart';

/// An `MdnsBrowser` that answers from a fixed list, so tests never touch
/// the real multicast network.
class FakeMdnsBrowser implements MdnsBrowser {
  FakeMdnsBrowser([this.instances = const [], this.error]);

  /// Services returned by every `browse` call.
  final List<MdnsServiceInstance> instances;

  /// When set, `browse` throws it instead of returning `instances`.
  final MdnsException? error;

  /// Number of `browse` calls so far.
  int calls = 0;

  /// Service types requested by the last call.
  List<String> requestedTypes = const [];

  @override
  Future<List<MdnsServiceInstance>> browse(
    Iterable<String> serviceTypes, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    calls++;
    requestedTypes = serviceTypes.toList();
    final e = error;
    if (e != null) throw e;
    return instances;
  }
}
