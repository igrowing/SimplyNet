import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simply_net/models/log_entry.dart';

final _shareTsFmt = DateFormat('yyyy-MM-dd HH:mm:ss');

/// The share-sheet payload for a saved log: the log file plus a subject line
/// matching how the log is titled in the UI. Pure — no platform calls — so it
/// can be unit-tested.
ShareParams logShareParams(LogEntry entry) => ShareParams(
      files: [XFile(entry.filePath)],
      subject:
          '${entry.function.toUpperCase()} — ${_shareTsFmt.format(entry.timestamp)}',
    );

/// Opens the OS share sheet for [entry]'s log file.
Future<void> shareLog(LogEntry entry) =>
    SharePlus.instance.share(logShareParams(entry));
