import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileAppBar(),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AppSpacing.h16,
                ProfileShimmer(
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  height: 260,
                  radius: 20,
                ),
                AppSpacing.h12,
                for (var i = 0; i < 3; i++) ...[
                  ProfileShimmer(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    height: 140,
                    radius: 16,
                  ),
                  AppSpacing.h8,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
