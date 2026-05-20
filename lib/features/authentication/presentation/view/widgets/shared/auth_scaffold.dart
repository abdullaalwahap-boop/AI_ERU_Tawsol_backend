import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_back_button.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_background.dart';
import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.body,
    this.showBackButton = true,
  });

  final Widget body;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.surfaceDarkCard,
      appBar: showBackButton
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const AuthBackButton(),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(child: body),
        ],
      ),
    );
  }
}
