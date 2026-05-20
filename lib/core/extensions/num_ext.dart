import 'package:flutter/material.dart';

/// Numeric extensions for concise spacing widgets.
///
/// Usage:
///   16.h   → SizedBox(height: 16)
///   12.w   → SizedBox(width: 12)
///   EdgeInsets.all(16) → 16.insets
extension NumSpacingExt on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());

  EdgeInsets get insets => EdgeInsets.all(toDouble());
  EdgeInsets get insetsH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get insetsV => EdgeInsets.symmetric(vertical: toDouble());
}
