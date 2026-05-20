import 'package:flutter/material.dart';

/// BuildContext extensions for quick access to theme and screen info.
///
/// Usage:
///   context.screenWidth
///   context.isSmallScreen
///   context.safeArea
///   context.hideKeyboard()
extension ContextExt on BuildContext {
  // ─── Theme shortcuts ──────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ─── Screen info ──────────────────────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);
  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;

  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isTablet => screenWidth >= 600;

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
