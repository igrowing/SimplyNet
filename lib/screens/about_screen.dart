import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simply_net/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays README.md with markdown-style formatting.
/// Handles: # headings, **bold**, `code`, - bullets, ---, plain text.
/// Special: [![...](img)](url) and [text](url) → tappable links / buttons.
/// Buy Me a Coffee badge → rendered as a real tappable FilledButton.
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
        title: Text(AppLocalizations.of(context).aboutSimplyNet,
            style: const TextStyle(fontWeight: FontWeight.bold)),
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

class _MarkdownView extends StatelessWidget {
  final String markdown;
  const _MarkdownView({required this.markdown});

  @override
  Widget build(BuildContext context) {
    final tt    = Theme.of(context).textTheme;
    final lines = markdown.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      // Blank line → spacer
      if (line.trim().isEmpty) {
        if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Horizontal rule
      if (RegExp(r'^-{3,}$').hasMatch(line.trim())) {
        widgets.add(const Divider());
        continue;
      }

      // ── Buy Me a Coffee badge ─────────────────────────────────────────────
      // Matches:  <a href="URL"><img ...alt="Buy Me A Coffee"...></a>
      // or the markdown image-link: [![alt](img)](url)
      if (line.contains('buymeacoffee') || line.contains('Buy Me')) {
        // Extract the href URL
        final hrefMatch = RegExp(r'href="([^"]+)"').firstMatch(line);
        final mdLinkMatch = RegExp(r'\[!\[([^\]]*)\]\([^\)]*\)\]\(([^\)]+)\)').firstMatch(line);
        final url = hrefMatch?.group(1) ?? mdLinkMatch?.group(2) ?? 'https://www.buymeacoffee.com/igrowing';
        widgets.add(_CoffeeButton(url: url));
        continue;
      }

      // ── Generic markdown image-link: [![alt](img)](url) → tappable button ──
      final imgLink = RegExp(r'\[!\[([^\]]*)\]\([^\)]*\)\]\(([^\)]+)\)').firstMatch(line);
      if (imgLink != null) {
        final alt = imgLink.group(1) ?? 'Open link';
        final url = imgLink.group(2) ?? '';
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.open_in_new, size: 16),
            label: Text(alt),
            onPressed: () => _launch(url),
          ),
        ));
        continue;
      }

      // ── Headings ──────────────────────────────────────────────────────────
      final h3 = RegExp(r'^### (.+)').firstMatch(line);
      if (h3 != null) {
        widgets.add(Padding(padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(_stripInline(h3.group(1)!),
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold))));
        continue;
      }
      final h2 = RegExp(r'^## (.+)').firstMatch(line);
      if (h2 != null) {
        widgets.add(Padding(padding: const EdgeInsets.only(top: 14, bottom: 4),
          child: Text(_stripInline(h2.group(1)!),
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold))));
        continue;
      }
      final h1 = RegExp(r'^# (.+)').firstMatch(line);
      if (h1 != null) {
        widgets.add(Padding(padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(_stripInline(h1.group(1)!),
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold))));
        continue;
      }

      // Skip raw HTML tags (<a …>, </a>, <img …>) that we already handled
      if (RegExp(r'^\s*<[a-zA-Z/]').hasMatch(line)) continue;

      // ── Bullet list ───────────────────────────────────────────────────────
      if (line.trimLeft().startsWith('- ') || line.trimLeft().startsWith('* ')) {
        final content = line.trimLeft().substring(2);
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 3),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: _inlineText(context, content)),
          ]),
        ));
        continue;
      }

      // ── Plain paragraph ───────────────────────────────────────────────────
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: _inlineText(context, line),
      ));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  /// Inline: **bold**, `code`, [text](url) — everything else is plain text.
  Widget _inlineText(BuildContext context, String text) {
    final spans = <InlineSpan>[];
    // Combined regex: **bold**, `code`, [text](url)
    final re = RegExp(r'\*\*(.+?)\*\*|`(.+?)`|\[([^\]]+)\]\(([^\)]+)\)');
    int pos = 0;

    for (final m in re.allMatches(text)) {
      if (m.start > pos) {
        spans.add(TextSpan(text: text.substring(pos, m.start)));
      }
      if (m.group(1) != null) {
        spans.add(TextSpan(text: m.group(1),
            style: const TextStyle(fontWeight: FontWeight.bold)));
      } else if (m.group(2) != null) {
        spans.add(TextSpan(text: m.group(2),
            style: TextStyle(fontFamily: 'monospace', fontSize: 12,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest)));
      } else if (m.group(3) != null && m.group(4) != null) {
        final url = m.group(4)!;
        spans.add(WidgetSpan(child: GestureDetector(
          onTap: () => _launch(url),
          child: Text(m.group(3)!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline)),
        )));
      }
      pos = m.end;
    }
    if (pos < text.length) spans.add(TextSpan(text: text.substring(pos)));

    return RichText(
        text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: spans));
  }

  static String _stripInline(String t) =>
      t.replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m.group(1)!).replaceAll('`', '');

  static Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

// ── Buy Me a Coffee button widget ─────────────────────────────────────────────

class _CoffeeButton extends StatelessWidget {
  final String url;
  const _CoffeeButton({required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF813F), // BuyMeACoffee orange
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Text('☕', style: TextStyle(fontSize: 20)),
        label: const Text('Buy me a coffee',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
