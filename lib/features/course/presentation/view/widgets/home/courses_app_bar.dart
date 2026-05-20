import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class CoursesAppBar extends StatelessWidget {
  final CourseRole role;

  const CoursesAppBar({super.key, required this.role});

  String get _subtitle {
    switch (role) {
      case CourseRole.student:
        return 'Your enrolled courses this semester';
      case CourseRole.doctor:
        return 'Courses you are currently teaching';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'My Courses',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  AppSpacing.h3,
                  Text(
                    _subtitle,
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
