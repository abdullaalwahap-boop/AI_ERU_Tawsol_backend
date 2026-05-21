import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileShimmer extends StatefulWidget {
  final EdgeInsets margin;
  final double height;
  final double radius;

  const ProfileShimmer({
    super.key,
    required this.margin,
    required this.height,
    required this.radius,
  });

  @override
  State<ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: widget.margin,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.dividerLight.withValues(alpha: _anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
