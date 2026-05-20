import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

/// Thin alias layer — all values delegate to AppColors.
abstract class AuthColors {
  static const primary = AppColors.accent;
  static const primaryLight = AppColors.accentLight;
  static const fieldBackground = AppColors.fieldDark;
  static const error = AppColors.error;
  static const iconBlue = AppColors.accentSoft;
  static const gradientEnd = AppColors.accentGradientEnd;
  static const badgeGradientStart = AppColors.cardGradientStart;
  static const badgeGradientEnd = AppColors.cardGradientEnd;
}
