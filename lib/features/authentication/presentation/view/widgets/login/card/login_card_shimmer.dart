import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:flutter/material.dart';

class LoginCardShimmer extends StatefulWidget {
  const LoginCardShimmer({super.key});

  @override
  State<LoginCardShimmer> createState() => _LoginCardShimmerState();
}

class _LoginCardShimmerState extends State<LoginCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: AppRadius.xlarge,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(_animation.value - 1, 0),
                  end: Alignment(_animation.value, 0),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
