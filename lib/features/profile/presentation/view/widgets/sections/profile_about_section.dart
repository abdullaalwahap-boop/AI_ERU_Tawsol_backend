import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:flutter/material.dart';

class ProfileAboutSection extends StatelessWidget {
  const ProfileAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AppBannerCard(),
        ProfileSectionCard(
          title: 'App Info',
          titleIcon: Icons.info_outline_rounded,
          children: [
            _AboutRow(
              icon: Icons.tag_rounded,
              iconColor: AppColors.contentGreen,
              iconBg: AppColors.contentGreenLight,
              label: 'Version',
              value: '1.0.0-beta',
            ),
            _AboutRow(
              icon: Icons.business_rounded,
              iconColor: AppColors.contentAmber,
              iconBg: AppColors.contentAmberLight,
              label: 'Organization',
              value: 'Egyptian Russian University',
            ),
            _AboutRow(
              icon: Icons.code_rounded,
              iconColor: AppColors.accent,
              iconBg: AppColors.accentLight.withValues(alpha: 0.13),
              label: 'Built with',
              value: 'Flutter + FastAPI',
            ),
            _AboutRow(
              icon: Icons.verified_rounded,
              iconColor: AppColors.contentPurple,
              iconBg: AppColors.contentPurpleLight,
              label: 'Release',
              value: 'May 2026',
            ),
          ],
        ),
        _MissionCard(),
        _TeamCard(),
      ],
    );
  }
}

// ─── App Banner ───────────────────────────────────────────────────────────────

class _AppBannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.xlarge,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: AppRadius.large,
            ),
            child: const Icon(
              Icons.hub_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          AppSpacing.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ERU Tawasol',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textOnDark,
                    letterSpacing: 0.3,
                  ),
                ),
                AppSpacing.h4,
                Text(
                  'Connecting ERU community',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mission Card ─────────────────────────────────────────────────────────────

class _MissionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppRadius.xlarge,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary.withValues(alpha: 0.4),
            size: 32,
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Mission',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                AppSpacing.h6,
                Text(
                  'To bridge the gap between students and educators at ERU — '
                  'making academic communication seamless, transparent, and '
                  'empowering every member of the university community.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.65,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Team Card ────────────────────────────────────────────────────────────────

class _TeamCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'Development Team',
      titleIcon: Icons.groups_rounded,
      children: const [
        _TeamMember(name: 'Ziad Tamer', role: 'Flutter Developer'),
        _TeamMember(name: 'ERU CS Department', role: 'Backend & Architecture'),
      ],
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String role;

  const _TeamMember({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.medium,
            ),
            child: Center(
              child: Text(
                name[0],
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          AppSpacing.w12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                role,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── About Row ────────────────────────────────────────────────────────────────

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _AboutRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                BoxDecoration(color: iconBg, borderRadius: AppRadius.medium),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          AppSpacing.w12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
