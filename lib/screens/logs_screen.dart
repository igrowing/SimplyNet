import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/models/log_entry.dart';
import 'package:simply_net/providers/log_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: prov.logs.isEmpty
          ? const _EmptyLogs()
          : ListView.separated(
              itemCount: prov.logs.length,
              separatorBuilder: (_, __) =>
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

  void _confirmDelete(
      BuildContext ctx, LogProvider prov, LogEntry entry) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete log?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              prov.deleteLog(entry);
            },
            child: Text('Delete',
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
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(entry.summary,
          maxLines: 2, overflow: TextOverflow.ellipsis,
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text('No logs yet',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5))),
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
      setState(() => _content = c);
    });
  }

  @override
  Widget build(BuildContext context) {
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
