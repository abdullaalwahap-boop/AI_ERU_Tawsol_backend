import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/shared/extensions/announcement_display_ext.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

class AnnounCardReadMoreButton extends StatelessWidget {
  final Announcement announcement;

  const AnnounCardReadMoreButton({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRouter.kContentDetailsView,
        extra: announcement.toDisplayItem(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Read more',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 10, color: AppColors.primary),
        ],
      ),
    );
  }
}
