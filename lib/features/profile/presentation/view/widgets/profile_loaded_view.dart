import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_header.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_about_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_help_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_info_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_logout_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileLoadedView extends StatelessWidget {
  final ProfileUser user;

  const ProfileLoadedView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileAppBar(),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: context.colorSurface,
              displacement: 20,
              onRefresh: () => context.read<ProfileCubit>().load(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProfileHeader(user: user),
                        AppSpacing.h8,
                        ProfileInfoSection(user: user),
                        AppSpacing.h4,
                        const ProfileSettingsSection(),
                        AppSpacing.h4,
                        const ProfileHelpSection(),
                        AppSpacing.h4,
                        const ProfileAboutSection(),
                        AppSpacing.h16,
                        const ProfileLogoutSection(),
                        AppSpacing.h32,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
