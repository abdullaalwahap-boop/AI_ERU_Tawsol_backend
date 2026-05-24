import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_snackbar.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/reset_password/reset_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordListener extends StatelessWidget {
  const ResetPasswordListener({super.key, required this.resetToken});

  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          AuthSnackbar.showError(context, state.errMessage);
        }
      },
      child: ResetPasswordViewBody(resetToken: resetToken),
    );
  }
}
