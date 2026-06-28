import 'package:flutter/material.dart';

/// Wraps a child (typically a Rescan icon) and periodically draws attention to
/// it: the child stays still for ~4 seconds, then briefly scales up and back
/// during the 5th second. The cycle repeats while [enabled] is true.
class PulsingIcon extends StatefulWidget {
  final Widget child;
  final bool enabled;
  /// Colour the icon takes at the peak of the pulse.
  final Color pulseColor;
 
  const PulsingIcon({
    super.key,
    required this.child,
    this.enabled = true,
    this.pulseColor = Colors.amber,
  });

  @override
  State<PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    // 80% of the cycle (4 s) held still, then a quick grow/shrink over the
    // final second.
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 80),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.4,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
    ]).animate(_controller);
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(PulsingIcon old) {
    super.didUpdateWidget(old);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        // Fade amber in/out in step with the scale: 1.0 = none, 1.4 = full.
        final amount = ((_scale.value - 1.0) / 0.4).clamp(0.0, 1.0);
        Widget c = child!;
        if (amount > 0) {
          final base = IconTheme.of(context).color;
          c = IconTheme.merge(
            data: IconThemeData(color: Color.lerp(base, widget.pulseColor, amount)),
            child: c,
          );
        }
        return Transform.scale(scale: _scale.value, child: c);
      },
      child: widget.child,
    );
  }
}
