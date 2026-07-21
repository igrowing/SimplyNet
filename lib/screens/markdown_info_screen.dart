import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Loads a bundled markdown asset and shows it nicely formatted with a back
/// button in the app bar. Handles: # headings, **bold**, `code`, - bullets,
/// --- rules, [text](url) links and plain paragraphs.
///
/// [assetName] is a bare file name (e.g. `ping_info.md`). The screen loads the
/// copy matching the active locale from `assets/help/<tag>/<name>`, falling
/// back to the English copy under `assets/help/en/<name>`.
class MarkdownInfoScreen extends StatefulWidget {
  final String title;
  final String assetName;
  const MarkdownInfoScreen({
    super.key,
    required this.title,
    required this.assetName,
  });

  @override
  State<MarkdownInfoScreen> createState() => _MarkdownInfoScreenState();
}

class _MarkdownInfoScreenState extends State<MarkdownInfoScreen> {
  String _raw = '';
  bool _failed = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _load();
  }

  Future<void> _load() async {
    final locale = Localizations.localeOf(context);
    final tag = locale.scriptCode == null
        ? locale.languageCode
        : '${locale.languageCode}_${locale.scriptCode}';
    final candidates = <String>[
      'assets/help/$tag/${widget.assetName}',
      'assets/help/en/${widget.assetName}',
    ];
    for (final path in candidates) {
      try {
        final s = await rootBundle.loadString(path);
        if (mounted) setState(() => _raw = s);
        return;
      } catch (_) {
        // try next candidate
      }
    }
    if (mounted) setState(() => _failed = true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _failed
          ? Center(child: Text(l.infoUnavailable))
          : _raw.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _MarkdownBody(markdown: _raw),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.ok),
          ),
        ),
      ),
    );
  }
}

// ── Lightweight markdown renderer ───────────────────────────────────────────

class _MarkdownBody extends StatelessWidget {
  final String markdown;
  const _MarkdownBody({required this.markdown});

  static final _tableSep = RegExp(r'^\s*\|?[\s:|-]*-{3,}[\s:|-]*\|?\s*$');

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final widgets = <Widget>[];
    final lines = markdown.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) {
        if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 6));
        continue;
      }

      // ── Markdown table: header row, separator row, then body rows ────────
      if (line.trim().startsWith('|') &&
          i + 1 < lines.length &&
          _tableSep.hasMatch(lines[i + 1])) {
        final rows = <String>[line];
        var j = i + 2;
        while (j < lines.length && lines[j].trim().startsWith('|')) {
          rows.add(lines[j]);
          j++;
        }
        widgets.add(_buildTable(context, rows));
        i = j - 1;
        continue;
      }

      if (RegExp(r'^-{3,}$').hasMatch(line.trim())) {
        widgets.add(const Divider());
        continue;
      }

      final h3 = RegExp(r'^### (.+)').firstMatch(line);
      if (h3 != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              _strip(h3.group(1)!),
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
        continue;
      }
      final h2 = RegExp(r'^## (.+)').firstMatch(line);
      if (h2 != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 4),
            child: Text(
              _strip(h2.group(1)!),
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
        continue;
      }
      final h1 = RegExp(r'^# (.+)').firstMatch(line);
      if (h1 != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              _strip(h1.group(1)!),
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
        continue;
      }

      final trimmed = line.trimLeft();
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        final indent = line.length - trimmed.length;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 12 + indent.toDouble(), bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•  ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: _inline(context, trimmed.substring(2))),
              ],
            ),
          ),
        );
        continue;
      }

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: _inline(context, line),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  static List<String> _cells(String line) {
    var t = line.trim();
    if (t.startsWith('|')) t = t.substring(1);
    if (t.endsWith('|')) t = t.substring(0, t.length - 1);
    return t.split('|').map((c) => c.trim()).toList();
  }

  Widget _buildTable(BuildContext context, List<String> rows) {
    final header = _cells(rows.first);
    final cols = header.length;
    final outline = Theme.of(context).colorScheme.outlineVariant;
    final headerBg = Theme.of(context).colorScheme.surfaceContainerHighest;

    List<Widget> rowCells(List<String> cells, {required bool head}) {
      final out = <Widget>[];
      for (var c = 0; c < cols; c++) {
        final text = c < cells.length ? cells[c] : '';
        out.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: head
                ? Text(
                    _strip(text),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : _inline(context, text),
          ),
        );
      }
      return out;
    }

    final tableRows = <TableRow>[
      TableRow(
        decoration: BoxDecoration(color: headerBg),
        children: rowCells(header, head: true),
      ),
      for (final r in rows.skip(1))
        TableRow(children: rowCells(_cells(r), head: false)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Table(
        border: TableBorder.all(color: outline),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {0: IntrinsicColumnWidth()},
        children: tableRows,
      ),
    );
  }

  Widget _inline(BuildContext context, String text) {
    final spans = <InlineSpan>[];
    final re = RegExp(r'\*\*(.+?)\*\*|`(.+?)`|\[([^\]]+)\]\(([^\)]+)\)');
    var pos = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > pos) {
        spans.add(TextSpan(text: text.substring(pos, m.start)));
      }
      if (m.group(1) != null) {
        spans.add(
          TextSpan(
            text: m.group(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (m.group(2) != null) {
        spans.add(
          TextSpan(
            text: m.group(2),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
            ),
          ),
        );
      } else if (m.group(3) != null && m.group(4) != null) {
        final url = m.group(4)!;
        spans.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _launch(url),
              child: Text(
                m.group(3)!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        );
      }
      pos = m.end;
    }
    if (pos < text.length) spans.add(TextSpan(text: text.substring(pos)));
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: spans,
      ),
    );
  }

  static String _strip(String t) => t
      .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m.group(1)!)
      .replaceAll('`', '');

  static Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
