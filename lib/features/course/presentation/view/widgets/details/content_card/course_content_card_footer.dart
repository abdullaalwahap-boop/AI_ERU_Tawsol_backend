import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/content_card/course_content_card_attachment_chip.dart';

class CourseContentCardFooter extends StatelessWidget {
  final CourseContent content;

  const CourseContentCardFooter({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (content.attachments.isNotEmpty) ...[
          CourseContentCardAttachmentChip(count: content.attachments.length),
          AppSpacing.w8,
        ],
        const Spacer(),
        Text(
          AppLocalizations.of(context).viewDetails,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
        ),
        AppSpacing.w2,
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 10, color: AppColors.primary),
      ],
    );
  }
}
