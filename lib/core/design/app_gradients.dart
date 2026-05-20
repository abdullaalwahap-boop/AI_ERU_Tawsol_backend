import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

/// Reusable gradient definitions.
abstract class AppGradients {
  // ─── Dark background (splash / onboarding) ────────────────────────────────
  static const LinearGradient darkBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.backgroundDark1,
      AppColors.backgroundDark2,
      AppColors.backgroundDark3,
      AppColors.backgroundDark4,
    ],
    stops: [0.0, 0.35, 0.70, 1.0],
  );

  // ─── Auth background ──────────────────────────────────────────────────────
  static const LinearGradient authBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.surfaceDark, AppColors.surfaceDarkCard],
  );

  // ─── Primary brand gradients ──────────────────────────────────────────────
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.accentLight, AppColors.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryDark = LinearGradient(
    colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentToWhite = LinearGradient(
    colors: [Colors.white, AppColors.accentGradientEnd],
  );

  // ─── Light background ─────────────────────────────────────────────────────
  static const LinearGradient lightBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.backgroundLight, Colors.white],
  );
}
