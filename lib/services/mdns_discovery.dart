import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:simply_net/constants/iot_signatures.dart';
import 'package:simply_net/services/mdns_exception.dart';
import 'package:simply_net/services/multicast_lock.dart';

export 'package:simply_net/services/mdns_exception.dart';

/// One service announced over mDNS / DNS-SD.
@immutable
class MdnsServiceInstance {
  /// Creates an announced service.
  const MdnsServiceInstance({
    required this.serviceType,
    required this.instance,
    required this.hostname,
    required this.ip,
    required this.port,
  });

  /// Service type, e.g. `_matter._tcp`.
  final String serviceType;

  /// Instance name, e.g. `Living Room Plug`.
  final String instance;

  /// Host name from the SRV record without trailing dot (`plug-1.local`),
  /// or '' when unknown.
  final String hostname;

  /// IPv4 address the service answers on.
  final String ip;

  /// Service port.
  final int port;
}

/// Everything mDNS told us about one address.
@immutable
class MdnsHostInfo {
  /// Creates the per-address summary.
  const MdnsHostInfo({
    required this.ip,
    required this.hostname,
    required this.serviceTypes,
  });

  /// IPv4 address.
  final String ip;

  /// First non-empty host name announced, or ''.
  final String hostname;

  /// Announced service types, e.g. `{_matter._tcp, _hap._tcp}`.
  final Set<String> serviceTypes;
}

/// Source of mDNS service announcements. Abstracted so scans can be tested
/// without touching the multicast network.
abstract interface class MdnsBrowser {
  /// Browses [serviceTypes] and resolves every announced instance to an
  /// address. Throws [MdnsException] when mDNS cannot run.
  Future<List<MdnsServiceInstance>> browse(
    Iterable<String> serviceTypes, {
    Duration timeout = const Duration(seconds: 3),
  });
}

/// Finds smart-home devices by their mDNS / DNS-SD announcements.
///
/// This is the reliable way to find Matter devices: their transport is UDP,
/// so a TCP probe rarely sees them, but they always announce
/// `_matter._tcp` (commissioned) or `_matterc._udp` (commissionable).
class MdnsDiscovery {
  /// Creates a discovery using [browser], by default the real network one.
  MdnsDiscovery([MdnsBrowser? browser])
    : _browser = browser ?? MulticastDnsBrowser();

  final MdnsBrowser _browser;

  /// Service types to browse: every identifying type in the catalogue.
  static List<String> get serviceTypes =>
      IotSignatures.mdnsServices.keys.toList(growable: false);

  /// Browses all `serviceTypes` and groups the result by address.
  Future<Map<String, MdnsHostInfo>> browseHosts({
    Duration timeout = const Duration(seconds: 3),
  }) async => groupByIp(await _browser.browse(serviceTypes, timeout: timeout));

  /// Groups announced services by address; the hostname is the first
  /// non-empty one seen for that address.
  static Map<String, MdnsHostInfo> groupByIp(
    Iterable<MdnsServiceInstance> instances,
  ) {
    final types = <String, Set<String>>{};
    final names = <String, String>{};
    for (final i in instances) {
      types.putIfAbsent(i.ip, () => <String>{}).add(i.serviceType);
      if (i.hostname.isNotEmpty) names.putIfAbsent(i.ip, () => i.hostname);
    }
    return {
      for (final e in types.entries)
        e.key: MdnsHostInfo(
          ip: e.key,
          hostname: names[e.key] ?? '',
          serviceTypes: e.value,
        ),
    };
  }

  /// Drops the trailing dot of a fully qualified name
  /// (`ESP-E286C2.local.` → `ESP-E286C2.local`).
  static String normalizeHostname(String name) =>
      name.endsWith('.') ? name.substring(0, name.length - 1) : name;

  /// The instance part of a PTR target: `Plug._matter._tcp.local` for
  /// `_matter._tcp` is `Plug`. Returns [domainName] unchanged when it does
  /// not end with the service type.
  static String instanceName(String domainName, String serviceType) {
    final name = normalizeHostname(domainName);
    final suffix = '.$serviceType.local';
    return name.endsWith(suffix)
        ? name.substring(0, name.length - suffix.length)
        : domainName;
  }
}

/// `MdnsBrowser` backed by the `multicast_dns` package.
class MulticastDnsBrowser implements MdnsBrowser {
  /// Creates a browser. [clientFactory] builds the `MDnsClient`; tests
  /// substitute one with a failing socket.
  MulticastDnsBrowser({MDnsClient Function()? clientFactory})
    : _clientFactory = clientFactory ?? MDnsClient.new;

  final MDnsClient Function() _clientFactory;

  /// Time allowed to resolve one announced instance (SRV, then address).
  static const _resolveTimeout = Duration(seconds: 2);

  @override
  Future<List<MdnsServiceInstance>> browse(
    Iterable<String> serviceTypes, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    await MulticastLock.acquire();
    final client = _clientFactory();
    try {
      await client.start();
      final found = <MdnsServiceInstance>[];
      await Future.wait(
        serviceTypes.map((t) => _browseType(client, t, timeout, found)),
      );
      return found;
    } on MdnsException {
      rethrow;
      // dart:io reports multicast failures as SocketException or as a bare
      // OSError (e.g. `reusePort` is unsupported on Windows, errno 10042),
      // so every Exception is converted into the one type callers handle.
    } on Exception catch (e) {
      throw MdnsException('mDNS failed: $e');
    } finally {
      client.stop();
      await MulticastLock.release();
    }
  }

  Future<void> _browseType(
    MDnsClient client,
    String type,
    Duration timeout,
    List<MdnsServiceInstance> out,
  ) async {
    final resolutions = <Future<void>>[];
    await for (final ptr in client.lookup<PtrResourceRecord>(
      ResourceRecordQuery.serverPointer('$type.local'),
      timeout: timeout,
    )) {
      resolutions.add(_resolve(client, type, ptr.domainName, out));
    }
    await Future.wait(resolutions);
  }

  /// First element of [stream], or null when it ends empty. Leaving the
  /// loop cancels the underlying lookup.
  static Future<T?> _first<T>(Stream<T> stream) async {
    await for (final value in stream) {
      return value;
    }
    return null;
  }

  Future<void> _resolve(
    MDnsClient client,
    String type,
    String domainName,
    List<MdnsServiceInstance> out,
  ) async {
    final srv = await _first(
      client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(domainName),
        timeout: _resolveTimeout,
      ),
    );
    if (srv == null) return;
    final addr = await _first(
      client.lookup<IPAddressResourceRecord>(
        ResourceRecordQuery.addressIPv4(srv.target),
        timeout: _resolveTimeout,
      ),
    );
    if (addr == null) return;
    out.add(
      MdnsServiceInstance(
        serviceType: type,
        instance: MdnsDiscovery.instanceName(domainName, type),
        hostname: MdnsDiscovery.normalizeHostname(srv.target),
        ip: addr.address.address,
        port: srv.port,
      ),
    );
  }
}
