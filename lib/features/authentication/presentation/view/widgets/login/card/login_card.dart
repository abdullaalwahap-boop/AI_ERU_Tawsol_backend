import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/card/login_card_bottom_strip.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/card/login_card_chip.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/card/login_card_hub_badge.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/card/login_card_number_row.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/card/login_card_shimmer.dart';
import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final chipW = w * 0.127;
        final chipH = chipW * 0.74;
        final badgeSize = w * 0.167;
        final stripH = h * 0.228;
        final hPad = w * 0.053;
        final dotSize = (w * 0.017).clamp(3.0, 6.0);

        return Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.xlarge,
            gradient: const LinearGradient(
              colors: [Color(0xff1A2E5A), Color(0xff0D1A3A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff3D6FFF).withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              const LoginCardShimmer(),
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LoginCardChip(width: chipW, height: chipH),
                        LoginCardHubBadge(size: badgeSize),
                      ],
                    ),
                    const Spacer(),
                    LoginCardNumberRow(dotSize: dotSize, cardWidth: w),
                    SizedBox(height: stripH + 6),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: LoginCardBottomStrip(height: stripH, cardWidth: w),
              ),
            ],
          ),
        );
      },
    );
  }
}
