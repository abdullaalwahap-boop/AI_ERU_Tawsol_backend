import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_snackbar.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/login_cubit/login_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginListener extends StatelessWidget {
  const LoginListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: _onStateChange,
      child: const LoginViewBody(),
    );
  }

  Future<void> _onStateChange(BuildContext context, LoginState state) async {
    if (state is LoginSuccess) {
      getIt<SessionCubit>().initFromAuth(
        typeCode: state.user.typeCode,
        userId: state.user.userId,
      );
      await _persistSession();
      if (!context.mounted) return;
      context.go(AppRouter.kHomeView);
    } else if (state is LoginPasswordChangeRequired) {
      getIt<SessionCubit>().initFromAuth(
        typeCode: state.user.typeCode,
        userId: state.user.userId,
      );
      await _persistSession();
      if (!context.mounted) return;
      context.go(
        AppRouter.kFirstLoginChangePasswordView,
        extra: state.user.userId,
      );
    } else if (state is LoginFailure) {
      AuthSnackbar.showError(context, state.errMessage);
    }
  }

  Future<void> _persistSession() async {
    final storage = LocalStorageService();
    final rememberMe = await storage.getRememberMe();
    if (rememberMe) await storage.saveIsLoggedIn(true);
  }
}
