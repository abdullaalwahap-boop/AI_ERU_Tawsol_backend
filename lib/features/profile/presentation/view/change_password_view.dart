import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_mode.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordView extends StatelessWidget {
  final ChangePasswordMode mode;

  /// Pass the logged-in user's ID when [mode] is [ChangePasswordMode.firstLogin]
  /// so the completion can be persisted per user.
  final int? userId;

  const ChangePasswordView({
    super.key,
    this.mode = ChangePasswordMode.profile,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(getIt<ProfileRepo>()),
      child: PopScope(
        // Prevent hardware-back and swipe-back in first-login mode.
        canPop: mode == ChangePasswordMode.profile,
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: ChangePasswordAppBar(mode: mode),
          body: ChangePasswordBody(mode: mode, userId: userId),
        ),
      ),
    );
  }
}
