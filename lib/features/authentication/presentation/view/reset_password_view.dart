import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/reset_password/reset_password_listener.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key, required this.resetToken});

  /// The short-lived reset token returned by the OTP verification step.
  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(getIt<AuthRepo>()),
      child: AuthScaffold(
        body: ResetPasswordListener(resetToken: resetToken),
      ),
    );
  }
}
