import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/login_form.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/login_header.dart';
import 'package:flutter/material.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          LoginHeader(),
          LoginForm(),
          AppSpacing.h32,
        ],
      ),
    );
  }
}
