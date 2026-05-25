class LogEntry {
  final String id;
  final String function;
  final DateTime timestamp;
  final String filePath;
  final String summary;

  LogEntry({
    required this.id,
    required this.function,
    required this.timestamp,
    required this.filePath,
    this.summary = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'function': function,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'filePath': filePath,
        'summary': summary,
      };

  factory LogEntry.fromJson(Map<String, dynamic> j) => LogEntry(
        id: j['id'] as String,
        function: j['function'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(j['timestamp'] as int),
        filePath: j['filePath'] as String,
        summary: j['summary'] as String? ?? '',
      );
}
