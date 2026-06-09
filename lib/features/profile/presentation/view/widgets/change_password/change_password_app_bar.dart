import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_mode.dart';
import 'package:flutter/material.dart';

class ChangePasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ChangePasswordMode mode;

  const ChangePasswordAppBar({
    super.key,
    this.mode = ChangePasswordMode.profile,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isProfile = mode == ChangePasswordMode.profile;

    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        boxShadow: AppShadows.appBar,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isProfile ? AppSpacing.sm : AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              if (isProfile) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: context.colorTextPrimary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AppSpacing.w4,
              ],
              Text(
                isProfile ? 'Change Password' : 'Set Your Password',
                style: AppTextStyles.heading4
                    .copyWith(color: context.colorTextPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
