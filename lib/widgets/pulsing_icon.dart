import 'package:flutter/material.dart';

/// Wraps a child (typically a Rescan icon) and periodically draws attention to
/// it: the child stays still for ~4 seconds, then briefly scales up and back
/// during the 5th second. The cycle repeats while [enabled] is true.
class PulsingIcon extends StatefulWidget {
  final Widget child;
  final bool enabled;
  const PulsingIcon({super.key, required this.child, this.enabled = true});

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
      duration: const Duration(seconds: 5),
    );
    // 80% of the cycle (4 s) held still, then a quick grow/shrink over the
    // final second.
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 80),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
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
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
