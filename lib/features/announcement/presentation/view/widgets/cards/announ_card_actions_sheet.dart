import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

enum AnnounCardAction { edit, delete }

class AnnounCardActionsSheet extends StatelessWidget {
  final String announcementTitle;

  const AnnounCardActionsSheet({super.key, required this.announcementTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.bottomSheet,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorDivider,
                  borderRadius: AppRadius.xsmall,
                ),
              ),
              AppSpacing.h16,
              Text(
                announcementTitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colorTextHint,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              AppSpacing.h12,
              Divider(height: 1, color: context.colorDivider),
              AppSpacing.h8,
              _ActionTile(
                icon: Icons.edit_rounded,
                label: 'Edit Announcement',
                color: AppColors.primary,
                onTap: () => Navigator.pop(context, AnnounCardAction.edit),
              ),
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                label: 'Delete Announcement',
                color: const Color(0xffDC2626),
                onTap: () => Navigator.pop(context, AnnounCardAction.delete),
              ),
              AppSpacing.h8,
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.medium,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorTextPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}
