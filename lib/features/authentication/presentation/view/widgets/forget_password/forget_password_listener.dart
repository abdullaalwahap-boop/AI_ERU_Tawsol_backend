import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_snackbar.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/forget_password/forget_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordListener extends StatelessWidget {
  const ForgetPasswordListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          context.push(
            AppRouter.kOtpView,
            extra: {
              'email': state.email,
              'otp': state.otp,
            },
          );
        } else if (state is ForgetPasswordFailure) {
          AuthSnackbar.showError(context, state.errMessage);
        }
      },
      child: const ForgetPasswordViewBody(),
    );
  }
}
