import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

/// Reusable BoxDecoration presets.
abstract class AppDecorations {
  // ─── Cards ────────────────────────────────────────────────────────────────
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.xlarge,
        boxShadow: AppShadows.card,
      );

  static BoxDecoration get cardNoBorder => BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.xlarge,
        boxShadow: AppShadows.soft,
      );

  static BoxDecoration get cardLight => BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.xlarge,
        boxShadow: AppShadows.soft,
      );

  static BoxDecoration cardColored(Color color) => BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.xlarge,
        boxShadow: AppShadows.colorGlow(color, alpha: 0.07),
        border: Border.all(color: color.withValues(alpha: 0.12), width: 1),
      );

  // ─── Input ────────────────────────────────────────────────────────────────
  static BoxDecoration get input => BoxDecoration(
        color: AppColors.inputBgLight,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.dividerLight, width: 1),
      );

  static BoxDecoration get inputDark => BoxDecoration(
        color: AppColors.fieldDark,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.12),
          width: 1,
        ),
      );

  static BoxDecoration inputDarkFocused(Color glowColor) => BoxDecoration(
        color: AppColors.fieldDark,
        borderRadius: AppRadius.large,
        border: Border.all(color: glowColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: AppShadows.colorGlow(glowColor, alpha: 0.12),
      );

  // ─── Glass / Dark surfaces ────────────────────────────────────────────────
  static BoxDecoration get glass => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: AppRadius.xlarge,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      );

  static BoxDecoration get glassDark => BoxDecoration(
        color: AppColors.surfaceDarkCard.withValues(alpha: 0.8),
        borderRadius: AppRadius.xlarge,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.10),
          width: 1,
        ),
      );

  // ─── Chip / Badge ─────────────────────────────────────────────────────────
  static BoxDecoration chip(Color color) => BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: AppRadius.circular,
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      );

  static BoxDecoration chipSolid(Color color) => BoxDecoration(
        color: color,
        borderRadius: AppRadius.circular,
      );

  // ─── Avatar ───────────────────────────────────────────────────────────────
  static BoxDecoration avatarGradient(Color start, Color end) => BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [start, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static BoxDecoration avatarPrimary = const BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [AppColors.accentLight, AppColors.primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // ─── Button ───────────────────────────────────────────────────────────────
  static BoxDecoration get primaryButton => BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.primaryGlow,
      );

  static BoxDecoration get accentButton => BoxDecoration(
        color: AppColors.accent,
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.accentGlow,
      );
}
