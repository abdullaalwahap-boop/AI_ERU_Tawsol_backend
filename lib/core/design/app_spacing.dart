import 'package:flutter/material.dart';

/// Spacing scale — use these instead of hardcoded SizedBox or EdgeInsets values.
abstract class AppSpacing {
  // ─── Scale values ─────────────────────────────────────────────────────────
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

  // ─── Vertical SizedBox helpers ────────────────────────────────────────────
  static const Widget h2 = SizedBox(height: 2);
  static const Widget h3 = SizedBox(height: 3);
  static const Widget h4 = SizedBox(height: 4);
  static const Widget h5 = SizedBox(height: 5);
  static const Widget h6 = SizedBox(height: 6);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h10 = SizedBox(height: 10);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h14 = SizedBox(height: 14);
  static const Widget h16 = SizedBox(height: 16);
  static const Widget h18 = SizedBox(height: 18);
  static const Widget h20 = SizedBox(height: 20);
  static const Widget h24 = SizedBox(height: 24);
  static const Widget h28 = SizedBox(height: 28);
  static const Widget h32 = SizedBox(height: 32);
  static const Widget h36 = SizedBox(height: 36);
  static const Widget h40 = SizedBox(height: 40);
  static const Widget h48 = SizedBox(height: 48);
  static const Widget h56 = SizedBox(height: 56);
  static const Widget h64 = SizedBox(height: 64);

  // ─── Horizontal SizedBox helpers ──────────────────────────────────────────
  static const Widget w2 = SizedBox(width: 2);
  static const Widget w4 = SizedBox(width: 4);
  static const Widget w6 = SizedBox(width: 6);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w10 = SizedBox(width: 10);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w14 = SizedBox(width: 14);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w20 = SizedBox(width: 20);
  static const Widget w24 = SizedBox(width: 24);
  static const Widget w32 = SizedBox(width: 32);

  // ─── Common EdgeInsets presets ────────────────────────────────────────────
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets pagePaddingLg = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(xl);
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(md);
  static const EdgeInsets chipPadding =
      EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets chipPaddingSm =
      EdgeInsets.symmetric(horizontal: sm, vertical: 3);
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: sm);
}
