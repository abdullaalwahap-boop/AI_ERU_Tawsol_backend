import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileInfoSection extends StatefulWidget {
  final ProfileUser user;

  const ProfileInfoSection({super.key, required this.user});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'Account',
      titleIcon: Icons.person_rounded,
      children: [
        _InfoTile(
          label: 'Full Name',
          value: widget.user.name,
          icon: Icons.badge_outlined,
          iconColor: AppColors.accent,
          iconBg: AppColors.accentLight.withValues(alpha: 0.13),
          onTap: () => _showEditDialog(context),
        ),
        _divider(),
        _InfoTile(
          label: 'Email Address',
          value: widget.user.email,
          icon: Icons.alternate_email_rounded,
          iconColor: AppColors.contentGreen,
          iconBg: AppColors.contentGreenLight,
        ),
        _divider(),
        _InfoTile(
          label: 'University ID',
          value: widget.user.id,
          icon: Icons.numbers_rounded,
          iconColor: AppColors.contentAmber,
          iconBg: AppColors.contentAmberLight,
        ),
        _divider(),
        _PasswordTile(
          showPassword: _showPassword,
          onToggle: () => setState(() => _showPassword = !_showPassword),
          onChangePassword: () => context.push(AppRouter.kChangePasswordView),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final ctrl = TextEditingController(text: widget.user.name);
    final cubit = context.read<ProfileCubit>();
    showDialog(
      context: context,
      builder: (_) => _EditNameDialog(
        controller: ctrl,
        onSave: (name) {
          cubit.updateName(name);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.dividerLight,
        indent: AppSpacing.lg + 38 + AppSpacing.md,
      );
}

// ─── Info Tile ────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.large,
        onTap: onTap,
        child: Padding(
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
              Expanded(
                child: Column(
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
              ),
              if (onTap != null)
                Icon(Icons.edit_rounded, size: 16, color: AppColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Password Tile ────────────────────────────────────────────────────────────

class _PasswordTile extends StatelessWidget {
  final bool showPassword;
  final VoidCallback onToggle;
  final VoidCallback onChangePassword;

  const _PasswordTile({
    required this.showPassword,
    required this.onToggle,
    required this.onChangePassword,
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
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.09),
              borderRadius: AppRadius.medium,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      showPassword ? 'mypassword' : '••••••••••',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: showPassword ? 0 : 2.5,
                      ),
                    ),
                    AppSpacing.w8,
                    GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        showPassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChangePassword,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Change',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Name Dialog ─────────────────────────────────────────────────────────

class _EditNameDialog extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSave;

  const _EditNameDialog({required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlarge),
      title: Text(
        'Edit Name',
        style: AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Enter your full name',
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          filled: true,
          fillColor: AppColors.inputBgLight,
          border: OutlineInputBorder(
            borderRadius: AppRadius.large,
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) onSave(name);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            elevation: 0,
          ),
          child: Text(
            'Save',
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
