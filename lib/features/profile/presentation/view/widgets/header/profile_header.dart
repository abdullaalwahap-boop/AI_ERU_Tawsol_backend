import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_avatar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_level_chip.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_role_badge.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileUser user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: AppRadius.xxlarge,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.38),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          _DecoCircle(top: -25, right: -25, size: 130, alpha: 0.06),
          _DecoCircle(bottom: -35, left: -15, size: 110, alpha: 0.05),
          _DecoCircle(top: 20, right: 60, size: 60, alpha: 0.04),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.xxl,
            ),
            child: Center(
              child: Column(
                children: [
                  ProfileAvatar(name: user.name, avatarUrl: user.avatarUrl),
                  AppSpacing.h16,
                  Text(
                    user.name,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textOnDark,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.h4,
                  Text(
                    user.email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.h14,
                  ProfileRoleBadge(role: user.role),
                  if (user.role == ProfileRole.student &&
                      user.level != null) ...[
                    AppSpacing.h8,
                    ProfileLevelChip(
                      level: user.level!,
                      department: user.department,
                    ),
                  ],
                  AppSpacing.h4,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecoCircle extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double alpha;

  const _DecoCircle({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}
