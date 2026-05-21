import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
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

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const _LoadingView();
        }
        if (state is ProfileError) {
          return _ErrorView(
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

        if (user == null) return const _LoadingView();
        return _LoadedView(user: user);
      },
    );
  }
}

// ─── Loaded View ──────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  final ProfileUser user;

  const _LoadedView({required this.user});

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

// ─── Loading State ────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

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
                _Shimmer(
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  height: 260,
                  radius: 20,
                ),
                AppSpacing.h12,
                for (var i = 0; i < 3; i++) ...[
                  _Shimmer(
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

class _Shimmer extends StatefulWidget {
  final EdgeInsets margin;
  final double height;
  final double radius;

  const _Shimmer({
    required this.margin,
    required this.height,
    required this.radius,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: widget.margin,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.dividerLight.withValues(alpha: _anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// ─── Error State ──────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 32,
                ),
              ),
              AppSpacing.h16,
              Text(
                'Failed to load profile',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.h8,
              Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.h24,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
