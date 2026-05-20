import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

/// Reusable shadow definitions.
abstract class AppShadows {
  // ─── Elevation ────────────────────────────────────────────────────────────
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.055),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get appBar => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.13),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get navBar => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];

  // ─── Glow ─────────────────────────────────────────────────────────────────
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.22),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get accentGlow => [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.22),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  /// Dynamic glow for content-type colors.
  static List<BoxShadow> colorGlow(Color color, {double alpha = 0.18}) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];
}
