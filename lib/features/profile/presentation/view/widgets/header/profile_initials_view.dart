import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileInitialsView extends StatelessWidget {
  final String name;
  final double size;

  const ProfileInitialsView({super.key, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: context.colorBackground,
      child: Center(
        child: Text(
          _initials(name),
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontSize: size * 0.32,
            height: 1,
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
