import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_header.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_error_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_loading_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_about_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_help_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_info_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_logout_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/profile_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const ProfileLoadingView();
        }
        if (state is ProfileError) {
          return ProfileErrorView(
            message: state.message,
            onRetry: () => context.read<ProfileCubit>().load(),
          );
        }

        final user = switch (state) {
          ProfileLoaded s => s.user,
          ProfileUpdating s => s.user,
          ProfileUpdateSuccess s => s.user,
          _ => null,
        };

        if (user == null) return const ProfileLoadingView();
        return _ProfileLoadedView(user: user);
      },
    );
  }
}

class _ProfileLoadedView extends StatelessWidget {
  final ProfileUser user;

  const _ProfileLoadedView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileAppBar(),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceLight,
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
