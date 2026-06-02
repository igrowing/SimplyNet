import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays README.md with basic markdown-style formatting.
/// No external markdown package needed — we parse the most common
/// constructs ourselves to keep the dependency tree lean.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _raw = '';

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('README.md').then((s) {
      if (mounted) setState(() => _raw = s);
    }).catchError((_) {
      if (mounted) setState(() => _raw = '# SimplyNet\n\nREADME not available.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About SimplyNet',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _raw.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _MarkdownView(markdown: _raw),
            ),
    );
  }
}

// ── Lightweight markdown renderer ─────────────────────────────────────────────
// Handles: # h1, ## h2, ### h3, **bold**, `code`, - bullet, blank lines,
// horizontal rules (---), and plain text. Good enough for README display.

class _MarkdownView extends StatelessWidget {
  final String markdown;
  const _MarkdownView({required this.markdown});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final lines = markdown.split('\n');
    final widgets = <Widget>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Blank line → small spacer
      if (line.trim().isEmpty) {
        if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Horizontal rule
      if (RegExp(r'^-{3,}$').hasMatch(line.trim())) {
        widgets.add(const Divider());
        continue;
      }

      // Headings
      final h3 = RegExp(r'^### (.+)').firstMatch(line);
      if (h3 != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(_stripInline(h3.group(1)!),
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ));
        continue;
      }
      final h2 = RegExp(r'^## (.+)').firstMatch(line);
      if (h2 != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 4),
          child: Text(_stripInline(h2.group(1)!),
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ));
        continue;
      }
      final h1 = RegExp(r'^# (.+)').firstMatch(line);
      if (h1 != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(_stripInline(h1.group(1)!),
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ));
        continue;
      }

      // Bullet list
      if (line.trimLeft().startsWith('- ') || line.trimLeft().startsWith('* ')) {
        final content = line.trimLeft().substring(2);
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: _inlineText(context, content)),
            ],
          ),
        ));
        continue;
      }

      // Plain paragraph
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: _inlineText(context, line),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  /// Render a line that may contain **bold**, `code`, and plain text.
  Widget _inlineText(BuildContext context, String text) {
    final spans = <InlineSpan>[];
    final re = RegExp(r'\*\*(.+?)\*\*|`(.+?)`');
    int pos = 0;

    for (final m in re.allMatches(text)) {
      if (m.start > pos) {
        spans.add(TextSpan(text: text.substring(pos, m.start)));
      }
      if (m.group(1) != null) {
        // **bold**
        spans.add(TextSpan(
          text: m.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (m.group(2) != null) {
        // `code`
        spans.add(TextSpan(
          text: m.group(2),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ));
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

  String _stripInline(String text) =>
      text.replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1').replaceAll('`', '');
}
