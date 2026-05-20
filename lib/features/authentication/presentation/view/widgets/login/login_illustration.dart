import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/card/login_card.dart';
import 'package:flutter/material.dart';

class LoginIllustration extends StatelessWidget {
  const LoginIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 16).clamp(0.0, 290.0);
        final cardHeight = cardWidth * (185 / 300);
        return SizedBox(
          height: cardHeight + 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: cardWidth + 40,
                height: cardHeight + 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: const LoginCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}
