import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/app_bar/announ_app_bar_trailing.dart';

class AnnounAppBar extends StatelessWidget {
  final AnnounRole role;

  const AnnounAppBar({super.key, required this.role});

  String get _subtitle {
    switch (role) {
      case AnnounRole.student:
        return 'Stay up to date with your courses';
      case AnnounRole.doctor:
        return 'Manage and view all announcements';
      case AnnounRole.admin:
        return 'University-wide announcements';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Positioned(
              right: -10,
              top: -8,
              child: Opacity(
                opacity: 0.06,
                child: const Icon(Icons.campaign_rounded,
                    size: 110, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Announcements',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        AppSpacing.h3,
                        Text(
                          _subtitle,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 12.5,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnnounAppBarTrailing(role: role),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
