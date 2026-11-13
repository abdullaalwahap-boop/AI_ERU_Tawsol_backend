import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_tile.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_display_data.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/content_file_type_chip.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/generate_quiz_button.dart';

class CourseFileTile extends StatelessWidget {
  final CourseContent content;

  const CourseFileTile({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final attachment =
        content.attachments.isNotEmpty ? content.attachments.first : null;
    final fileType = attachment?.fileType ?? ContentFileType.other;

    final session = getIt<SessionCubit>().state;
    final isStudent = session is SessionAuthenticated &&
        session.role == AppRole.student;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.xlarge,
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xlarge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppColors.accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ContentFileTypeChip(fileType: fileType),
                          AppSpacing.w8,
                          Expanded(
                            child: Text(
                              content.title,
                              style: AppTextStyles.titleSmall
                                  .copyWith(color: context.colorTextPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      if (content.body.isNotEmpty) ...[
                        AppSpacing.h6,
                        Text(
                          content.body,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: context.colorTextHint,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      if (attachment != null && attachment.url != null) ...[
                        AppSpacing.h10,
                        AttachmentTile(
                          attachment: _toDisplayData(attachment),
                          primaryColor: AppColors.accent,
                        ),
                      ],

                      AppSpacing.h10,

                      Row(
                        children: [
                          Icon(Icons.schedule_rounded,
                              size: 13, color: context.colorTextHint),
                          AppSpacing.w4,
                          Text(
                            content.timeAgo,
                            style: AppTextStyles.labelSmall
                                .copyWith(color: context.colorTextHint),
                          ),
                          const Spacer(),

                          if (content.isQuizEligible)
                            GenerateQuizButton(content: content),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AttachmentDisplayData _toDisplayData(ContentAttachment a) {
    final (icon, color) = switch (a.fileType) {
      ContentFileType.pdf => (Icons.picture_as_pdf_rounded, const Color(0xffDC2626)),
      ContentFileType.doc => (Icons.description_rounded, const Color(0xff2563EB)),
      ContentFileType.image => (Icons.image_rounded, const Color(0xff059669)),
      ContentFileType.other => (Icons.attach_file_rounded, AppColors.textSecondary),
    };
    return AttachmentDisplayData(
      name: a.name,
      sizeLabel: a.sizeLabel,
      icon: icon,
      iconColor: color,
      url: a.url,
      isImage: a.isImage,
    );
  }
}
