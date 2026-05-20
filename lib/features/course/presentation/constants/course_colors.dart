import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Thin alias layer — all values delegate to AppColors.
abstract class CourseColors {
  static const Color primary = AppColors.primary;
  static const Color primaryDark = AppColors.primaryDark;
  static const Color background = AppColors.backgroundLight;
  static const Color surface = AppColors.surfaceLight;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textHint = AppColors.textHint;
  static const Color divider = AppColors.dividerLight;
  static const Color inputBg = AppColors.inputBgLight;
  static const Color cardShadow = Color(0x0D000000);
}
