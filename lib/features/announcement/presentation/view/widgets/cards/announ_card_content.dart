import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/shared/extensions/announcement_display_ext.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_footer.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_preview.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_title.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_top_row.dart';

class AnnounCardContent extends StatelessWidget {
  final Announcement announcement;

  const AnnounCardContent({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final typeColor = announcement.type.color;

    return GestureDetector(
      onTap: () => context.push(
        AppRouter.kContentDetailsView,
        extra: announcement.toDisplayItem(),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            ...AppShadows.card,
            BoxShadow(
              color: typeColor.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: typeColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnnounCardTopRow(announcement: announcement),
                        AppSpacing.h10,
                        AnnounCardTitle(title: announcement.title),
                        AppSpacing.h6,
                        AnnounCardPreview(body: announcement.body),
                        AppSpacing.h12,
                        AnnounCardFooter(announcement: announcement),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
