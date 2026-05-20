import 'package:flutter/material.dart';

/// Animation duration constants.
abstract class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 480);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration splash = Duration(milliseconds: 1600);
}

/// Animation curve shortcuts.
abstract class AppCurves {
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve spring = Curves.elasticOut;
}
