import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// BuildContext extensions for quick access to theme and screen info.
extension ContextExt on BuildContext {
  // ─── Theme shortcuts ──────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ─── Screen info ─────────────────────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);
  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;

  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isTablet => screenWidth >= 600;

  // ─── Helpers ─────────────────────────────────────────────────────────────
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ─── Dark mode ───────────────────────────────────────────────────────────
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ─── Adaptive semantic colors ─────────────────────────────────────────────
  // These automatically return the light or dark variant based on the current
  // ThemeMode so every widget stays in sync without any extra Cubit/BLoC.

  /// Scaffold / page background.
  Color get colorBackground =>
      isDark ? AppColors.backgroundDark1 : AppColors.backgroundLight;

  /// Card / sheet / dialog surface.
  Color get colorSurface =>
      isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

  /// Elevated card (one level above surface).
  Color get colorSurfaceCard =>
      isDark ? AppColors.surfaceDarkCard : AppColors.surfaceLight;

  /// Text-field / input background.
  Color get colorInputBg =>
      isDark ? AppColors.fieldDark : AppColors.inputBgLight;

  /// Horizontal / vertical dividers.
  Color get colorDivider =>
      isDark ? const Color(0xff1A2233) : AppColors.dividerLight;

  /// Thin borders around containers.
  Color get colorBorder =>
      isDark ? const Color(0xff1E2A40) : AppColors.borderLight;

  /// Primary body text.
  Color get colorTextPrimary =>
      isDark ? AppColors.textOnDark : AppColors.textPrimary;

  /// Secondary / supporting text.
  Color get colorTextSecondary =>
      isDark ? const Color(0xff8B9DC3) : AppColors.textSecondary;

  /// Hint / placeholder text.
  Color get colorTextHint =>
      isDark ? const Color(0xff6B7F9E) : AppColors.textHint;

  /// Disabled text.
  Color get colorTextDisabled =>
      isDark ? const Color(0xff3A4F6A) : AppColors.textDisabled;

  /// Received chat bubble background.
  Color get colorReceivedBubble =>
      isDark ? AppColors.surfaceDarkCard : AppColors.receivedBubble;
}
