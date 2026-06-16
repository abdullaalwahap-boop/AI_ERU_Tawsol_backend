import 'package:flutter/material.dart';

class ProfileDecoCircle extends StatelessWidget {
  const ProfileDecoCircle({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.alpha,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}
