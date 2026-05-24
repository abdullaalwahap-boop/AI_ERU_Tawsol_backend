import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_snackbar.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/otp_cubit/otp_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/otp/otp_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpListener extends StatelessWidget {
  const OtpListener({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          // Forward the reset_token (not the email) to the next screen.
          context.push(AppRouter.kResetPasswordView, extra: state.resetToken);
        } else if (state is OtpFailure) {
          AuthSnackbar.showError(context, state.errMessage);
        }
      },
      child: OtpViewBody(email: email),
    );
  }
}
