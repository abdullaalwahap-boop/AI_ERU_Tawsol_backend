import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/logout/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileLogoutSection extends StatelessWidget {
  const ProfileLogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: Text(
            AppLocalizations.of(context).logout,
            style: AppTextStyles.buttonMedium.copyWith(color: AppColors.error),
          ),
          onPressed: () => _confirm(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.35)),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          ),
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ProfileLogoutDialog(),
    );
    if (confirmed != true || !context.mounted) return;

    // Blacklist JWT on server + wipe secure storage.
    await getIt<AuthRepo>().logout();

    // Clear non-sensitive session flag.
    await LocalStorageService().clearIsLoggedIn();

    // Clear in-memory session state.
    getIt<SessionCubit>().clear();

    if (context.mounted) context.go(AppRouter.kLoginView);
  }
}
