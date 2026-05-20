import 'package:flutter/material.dart';

/// Spacing scale — use these instead of hardcoded numbers.
abstract class AppSpacing {
  // ─── Scale ────────────────────────────────────────────────────────────────
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  // ─── Common SizedBox helpers ──────────────────────────────────────────────
  static const Widget h2 = SizedBox(height: xxs);
  static const Widget h4 = SizedBox(height: xs);
  static const Widget h6 = SizedBox(height: 6);
  static const Widget h8 = SizedBox(height: sm);
  static const Widget h12 = SizedBox(height: md);
  static const Widget h16 = SizedBox(height: lg);
  static const Widget h20 = SizedBox(height: xl);
  static const Widget h24 = SizedBox(height: xxl);
  static const Widget h32 = SizedBox(height: xxxl);

  static const Widget w4 = SizedBox(width: xs);
  static const Widget w6 = SizedBox(width: 6);
  static const Widget w8 = SizedBox(width: sm);
  static const Widget w12 = SizedBox(width: md);
  static const Widget w16 = SizedBox(width: lg);

  // ─── Common EdgeInsets presets ────────────────────────────────────────────
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets pagePaddingLg = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(xl);
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(md);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets chipPaddingSm = EdgeInsets.symmetric(horizontal: sm, vertical: 3);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
}
