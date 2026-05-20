import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class PasswordRequirementItem extends StatelessWidget {
  final String label;
  final bool met;

  const PasswordRequirementItem({
    super.key,
    required this.label,
    required this.met,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: _Row(key: ValueKey(met), label: label, met: met),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final bool met;

  const _Row({super.key, required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.success : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              met ? Icons.check_rounded : Icons.close_rounded,
              color: color,
              size: 11,
            ),
          ),
          AppSpacing.w8,
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
