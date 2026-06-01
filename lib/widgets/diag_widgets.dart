/// Shared diagnostic widgets used by both HostScreen and the standalone
/// Network Tools screens (Ping, NSLookup, Traceroute).
///
/// Exported surface:
///   - DiagOutputPanel   — black terminal pane that switches between the
///                         ping graph and plain-text output automatically.
///   - PingGraphWidget   — mini graph of ping RTT samples (ms vs index).
///   - PingGraphPainter  — CustomPainter backing PingGraphWidget.
///   - parsePingTimings  — pure function: extracts ms values from ping text.
library diag_widgets;

import 'dart:math' as math;
import 'package:flutter/material.dart';

// ── Regex ─────────────────────────────────────────────────────────────────────
// Matches Android "time=1.23 ms", iOS "time=1.234 ms", Windows "time=1ms" / "time<1ms".
final _pingRegex = RegExp(
  r'time[=<](\d+(?:\.\d+)?)\s*ms',
  caseSensitive: false,
);

/// Extract all ping RTT values (ms) from a text chunk.
/// [previousLength] — how many characters of [fullText] were already scanned.
/// Returns (newTimings, newParsedLength) so callers can advance their cursor.
(List<double>, int) parsePingTimings(
  String fullText,
  int previousLength,
) {
  final newText = fullText.substring(previousLength);
  final timings = <double>[];
  for (final m in _pingRegex.allMatches(newText)) {
    final ms = double.tryParse(m.group(1)!) ?? 0.0;
    if (ms > 0) timings.add(ms);
  }
  // Advance cursor to end of last complete line to avoid chunk-boundary splits.
  final lastNl = newText.lastIndexOf('\n');
  final newParsedLength = previousLength + (lastNl >= 0 ? lastNl + 1 : 0);
  return (timings, newParsedLength);
}

// ════════════════════════════════════════════════════════════════════════════
//  DiagOutputPanel
//
//  A self-contained output pane:
//  • When [isPing] is true and [pingTimings] is non-empty → shows PingGraphWidget.
//  • Otherwise → shows the text [output] in a green-on-black terminal style.
//  • Title bar shows the tool name + target, a spinner while running, and
//    a Stop button when [onStop] is provided and [isRunning] is true.
// ════════════════════════════════════════════════════════════════════════════

class DiagOutputPanel extends StatelessWidget {
  final String toolLabel;   // e.g. "PING", "TRACEROUTE"
  final String target;      // IP or hostname being probed
  final String output;      // full accumulated text output
  final bool isRunning;
  final bool isPing;
  final List<double> pingTimings;
  final ScrollController? scrollController;
  final VoidCallback? onStop;

  const DiagOutputPanel({
    super.key,
    required this.toolLabel,
    required this.target,
    required this.output,
    required this.isRunning,
    this.isPing = false,
    this.pingTimings = const [],
    this.scrollController,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final showGraph = isPing && pingTimings.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Title bar ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '— $toolLabel $target —',
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isRunning) ...[
                const SizedBox(
                  width: 12, height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
              ],
              if (isRunning && onStop != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    icon: const Icon(Icons.stop_rounded),
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onStop,
                    tooltip: 'Stop',
                  ),
                ),
            ],
          ),
        ),

        // ── Output area ──────────────────────────────────────────────────────
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: showGraph
                ? PingGraphWidget(timings: pingTimings)
                : SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      output.isEmpty && isRunning ? 'Running…' : output,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PingGraphWidget
// ════════════════════════════════════════════════════════════════════════════

class PingGraphWidget extends StatelessWidget {
  final List<double> timings;

  const PingGraphWidget({super.key, required this.timings});

  @override
  Widget build(BuildContext context) {
    if (timings.isEmpty) {
      return const Center(
        child: Text(
          'Waiting for ping results…',
          style: TextStyle(color: Colors.lightGreenAccent, fontSize: 12),
        ),
      );
    }

    final maxMs = timings.reduce(math.max);
    final minMs = timings.reduce(math.min);
    final avgMs = timings.reduce((a, b) => a + b) / timings.length;
    final lost  = timings.where((t) => t <= 0).length;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats bar
          Text(
            'Min: ${minMs.toStringAsFixed(1)}ms'
            '  Avg: ${avgMs.toStringAsFixed(1)}ms'
            '  Max: ${maxMs.toStringAsFixed(1)}ms'
            '  Sent: ${timings.length}'
            '${lost > 0 ? "  Lost: $lost" : ""}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.lightGreenAccent,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: CustomPaint(
              painter: PingGraphPainter(timings: timings),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PingGraphPainter
// ════════════════════════════════════════════════════════════════════════════

class PingGraphPainter extends CustomPainter {
  final List<double> timings; // 0 or negative = timeout/lost packet

  const PingGraphPainter({required this.timings});

  @override
  void paint(Canvas canvas, Size size) {
    if (timings.isEmpty) return;

    final valid = timings.where((t) => t > 0).toList();
    if (valid.isEmpty) return;

    final maxMs = valid.reduce(math.max) * 1.1; // 10% headroom
    final minMs = 0.0;

    final linePaint = Paint()
      ..color = Colors.lightGreenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint     = Paint()..color = Colors.lightGreenAccent;
    final timeoutPaint = Paint()..color = Colors.redAccent;
    final gridPaint    = Paint()
      ..color = Colors.lightGreenAccent.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    const leftPad  = 38.0;
    const bottomPad = 6.0;
    final chartW = size.width - leftPad - 4;
    final chartH = size.height - bottomPad;

    // Grid + Y labels (4 horizontal lines)
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i <= 4; i++) {
      final y = chartH * (1 - i / 4);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - 4, y), gridPaint);
      final label = (maxMs * i / 4).toStringAsFixed(0);
      tp
        ..text = TextSpan(
            text: '${label}ms',
            style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 8))
        ..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Plot
    final n    = timings.length;
    final step = n > 1 ? chartW / (n - 1) : chartW / 2;
    final path = Path();
    bool pathStarted = false;

    for (var i = 0; i < n; i++) {
      final x = leftPad + i * step;
      final t = timings[i];

      if (t <= 0) {
        // Lost packet — red X marker
        canvas.drawLine(Offset(x - 4, chartH * 0.5 - 4),
            Offset(x + 4, chartH * 0.5 + 4), timeoutPaint);
        canvas.drawLine(Offset(x + 4, chartH * 0.5 - 4),
            Offset(x - 4, chartH * 0.5 + 4), timeoutPaint);
        pathStarted = false; // break the line
        continue;
      }

      final frac = maxMs > 0 ? (t - minMs) / (maxMs - minMs) : 0.5;
      final y    = chartH * (1 - frac.clamp(0.0, 1.0));

      if (!pathStarted) {
        path.moveTo(x, y);
        pathStarted = true;
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  // The list is mutated in-place (.add()), so reference equality is always
  // true. Return true unconditionally — Flutter's raster cache avoids
  // unnecessary GPU work when the pixels haven't changed.
  bool shouldRepaint(PingGraphPainter _) => true;
}
