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

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'mac': mac,
        'hostname': hostname,
        'manufacturer': manufacturer,
        'deviceType': deviceType,
        'isUp': isUp,
      };

  /// Rebuilds a [HostResult] from its [toJson] map.
  ///
  /// Throws [FormatException] when the mandatory `ip` field is missing or not a
  /// string — corrupt cache must fail loudly rather than yield a blank host.
  factory HostResult.fromJson(Map<String, dynamic> json) {
    final ip = json['ip'];
    if (ip is! String || ip.isEmpty) {
      throw const FormatException('HostResult.fromJson: missing "ip"');
    }
    return HostResult(
      ip: ip,
      mac: json['mac'] as String? ?? 'N/A',
      hostname: json['hostname'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      deviceType: json['deviceType'] as String? ?? '',
      isUp: json['isUp'] as bool? ?? true,
    );
  }
}
