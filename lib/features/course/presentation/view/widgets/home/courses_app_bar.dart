import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class CoursesAppBar extends StatelessWidget {
  final CourseRole role;

  const CoursesAppBar({super.key, required this.role});

  String _subtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (role) {
      case CourseRole.student:
        return l10n.coursesSubtitleStudent;
      case CourseRole.doctor:
        return l10n.coursesSubtitleDoctor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: Color(0x33003096), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned(
              right: 0,
              top: -10,
              child: Opacity(
                opacity: 0.06,
                child:
                    Icon(Icons.school_rounded, size: 110, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.myCourses,
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  AppSpacing.h3,
                  Text(
                    _subtitle(context),
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
