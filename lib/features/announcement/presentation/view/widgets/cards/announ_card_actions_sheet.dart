import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_action_tile.dart';


enum AnnounCardAction { edit, delete }

class AnnounCardActionsSheet extends StatelessWidget {
  final String announcementTitle;

  const AnnounCardActionsSheet({super.key, required this.announcementTitle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              AnnounActionTile(
                icon: Icons.edit_rounded,
                label: l10n.editAnnouncement,
                color: AppColors.primary,
                onTap: () => Navigator.pop(context, AnnounCardAction.edit),
              ),
              AnnounActionTile(
                icon: Icons.delete_outline_rounded,
                label: l10n.deleteAnnouncement,
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
