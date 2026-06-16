import 'package:flutter/material.dart';

class AnimatedCard extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedCard({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, c) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: c,
        ),
      ),
      child: child,
    );
  }
}
