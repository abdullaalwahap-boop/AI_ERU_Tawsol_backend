import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo_impl.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(ProfileRepoImpl()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _AppBar(),
        body: const ChangePasswordBody(),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        boxShadow: AppShadows.appBar,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                color: AppColors.textPrimary,
                onPressed: () => Navigator.of(context).pop(),
              ),
              AppSpacing.w4,
              Text(
                'Change Password',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
