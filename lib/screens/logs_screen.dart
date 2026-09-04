import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/models/log_entry.dart';
import 'package:simply_net/providers/log_provider.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:simply_net/utils/log_sharing.dart';

final _fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<LogProvider>().loadLogs());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<LogProvider>();
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.logs, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l.deleteAllLogs,
            onPressed:
                prov.logs.isEmpty ? null : () => _confirmDeleteAll(context, prov),
          ),
        ],
      ),
      body: prov.logs.isEmpty
          ? const _EmptyLogs()
          : ListView.separated(
              itemCount: prov.logs.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, thickness: 0.5),
              itemBuilder: (ctx, i) => _LogTile(
                entry: prov.logs[i],
                onTap: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => _LogDetailScreen(entry: prov.logs[i]),
                  ),
                ),
                onDelete: () => _confirmDelete(ctx, prov, prov.logs[i]),
              ),
            ),
    );
  }

  void _confirmDeleteAll(BuildContext ctx, LogProvider prov) {
    final l = AppLocalizations.of(ctx);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(l.deleteAllLogsQ),
        content: Text(l.cannotBeUndone),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              prov.deleteAll();
            },
            child: Text(l.deleteAll,
                style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext ctx, LogProvider prov, LogEntry entry) {
    final l = AppLocalizations.of(ctx);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(l.deleteLogQ),
        content: Text(l.cannotBeUndone),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              prov.deleteLog(entry);
            },
            child: Text(l.delete,
                style: TextStyle(
                    color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final LogEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _LogTile(
      {required this.entry, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.description),
      title: Text(
        '${entry.function.toUpperCase()} — ${_fmt.format(entry.timestamp)}',
        style: const TextStyle(fontWeight: FontWeight.w500),
        // overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(entry.summary,
          maxLines: 2, // overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12)),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline,
            color: Theme.of(context).colorScheme.error),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}

class _EmptyLogs extends StatelessWidget {
  const _EmptyLogs();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.article,
              size: 72,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).noLogsYet,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

// ── Log detail ────────────────────────────────────────────────────────────────

class _LogDetailScreen extends StatefulWidget {
  final LogEntry entry;
  const _LogDetailScreen({required this.entry});

  @override
  State<_LogDetailScreen> createState() => _LogDetailScreenState();
}

class _LogDetailScreenState extends State<_LogDetailScreen> {
  String? _content;

  @override
  void initState() {
    super.initState();
    context.read<LogProvider>().readLog(widget.entry.filePath).then((c) {
      if (mounted) setState(() => _content = c);
    });
  }

  Future<void> _copy() async {
    if (_content == null) return;
    await Clipboard.setData(ClipboardData(text: _content!));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).copied)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.entry.function.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(_fmt.format(widget.entry.timestamp),
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: l.copy,
            onPressed: _content == null ? null : _copy,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: l.shareAction,
            onPressed: () => shareLog(widget.entry),
          ),
        ],
      ),
      body: _content == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _content!,
                style: const TextStyle(
                    fontFamily: 'monospace', fontSize: 12, height: 1.6),
              ),
            ),
    );
  }
}
