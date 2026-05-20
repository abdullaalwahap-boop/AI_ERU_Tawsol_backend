import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/additional_pages_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_about_me_header.dart';
import 'package:flutter/material.dart';

class AppVersionViewBody extends StatelessWidget {
  const AppVersionViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdditionalPagesAppBar(title: 'App Version'),
        AppSpacing.h20,
        CustomAboutMeHeader(
          image: Placeholder(fallbackHeight: 200),
          title: 'App Version',
          subTitile: '1.0.0+1',
          paragraph: 'You are using the latest version of\nAI Connect.',
        ),
        AppSpacing.h20,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white70,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: AppRadius.xxlarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("What's New?", style: AppTextStyles.heading2),
                AppSpacing.h20,
                Row(
                  children: [
                    Text("• ", style: AppTextStyles.heading4),
                    Text(
                      " Performance improvements",
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppSpacing.h10,
                Row(
                  children: [
                    Text("• ", style: AppTextStyles.heading4),
                    Text(
                      " Bug fixes",
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppSpacing.h10,
                Row(
                  children: [
                    Text("• ", style: AppTextStyles.heading4),
                    Text(
                      " Better user experience",
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
