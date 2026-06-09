import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_priority_ui_ext.dart';

class AddAnnounPriorityCard extends StatelessWidget {
  final AnnouncementPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const AddAnnounPriorityCard({
    super.key,
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? priority.color.withValues(alpha: 0.08)
              : context.colorInputBg,
          borderRadius: AppRadius.medium,
          border: Border.all(
            color: isSelected ? priority.color : context.colorDivider,
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected ? priority.color : context.colorDivider,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                priority.icon,
                size: 18,
                color: isSelected ? Colors.white : context.colorTextHint,
              ),
            ),
            AppSpacing.h4,
            Text(
              priority.label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? priority.color : context.colorTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
