import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_tile.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_display_data.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/quiz_view.dart';

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
                      // ── Type chip + title ─────────────────────────────────
                      Row(
                        children: [
                          _FileTypeChip(fileType: fileType),
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

                      // ── Body ─────────────────────────────────────────────
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

                      // ── Open file button ──────────────────────────────────
                      if (attachment != null && attachment.url != null) ...[
                        AppSpacing.h10,
                        AttachmentTile(
                          attachment: _toDisplayData(attachment),
                          primaryColor: AppColors.accent,
                        ),
                      ],

                      AppSpacing.h10,

                      // ── Footer row ────────────────────────────────────────
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

                          // Generate Quiz — students only, DR/TA files only
                          if (isStudent && content.isQuizEligible)
                            _GenerateQuizButton(content: content),
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

class _GenerateQuizButton extends StatelessWidget {
  final CourseContent content;
  const _GenerateQuizButton({required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRouter.kQuizView,
        extra: QuizArgs(
          fileId: content.fileIdInt!,
          lectureTitle: content.title,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                size: 13, color: Colors.white),
            AppSpacing.w4,
            Text(
              AppLocalizations.of(context).generateQuiz,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileTypeChip extends StatelessWidget {
  final ContentFileType fileType;
  const _FileTypeChip({required this.fileType});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (fileType) {
      ContentFileType.pdf => ('PDF', const Color(0xffDC2626)),
      ContentFileType.doc => ('DOC', const Color(0xff2563EB)),
      ContentFileType.image => ('IMG', const Color(0xff059669)),
      ContentFileType.other => ('FILE', context.colorTextSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
