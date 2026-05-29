class HostResult {
  final String ip;
  String mac;
  final String hostname;
  String manufacturer;
  String deviceType;
  final bool isUp;

  HostResult({
    required this.ip,
    this.mac = 'N/A',
    this.hostname = '',
    this.manufacturer = '',
    this.deviceType = '',
    this.isUp = true,
  });

  HostResult copyWith({
    String? ip,
    String? mac,
    String? hostname,
    String? manufacturer,
    String? deviceType,
    bool? isUp,
  }) =>
      HostResult(
        ip: ip ?? this.ip,
        mac: mac ?? this.mac,
        hostname: hostname ?? this.hostname,
        manufacturer: manufacturer ?? this.manufacturer,
        deviceType: deviceType ?? this.deviceType,
        isUp: isUp ?? this.isUp,
      );
}
