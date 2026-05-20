import 'package:flutter/material.dart';

/// Border-radius scale — use these instead of hardcoded `BorderRadius.circular(n)`.
abstract class AppRadius {
  // ─── Raw values ───────────────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 20;
  static const double xxxl = 24;
  static const double full = 999;

  // ─── BorderRadius constants ───────────────────────────────────────────────
  static const BorderRadius xsmall = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlarge = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlarge = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius xxxlarge = BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius circular = BorderRadius.all(Radius.circular(full));

  // ─── Asymmetric presets ───────────────────────────────────────────────────
  static const BorderRadius bottomSheet = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
  static const BorderRadius topSheet = BorderRadius.vertical(
    bottom: Radius.circular(xxl),
  );
  static const BorderRadius messageSent = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(xs),
  );
  static const BorderRadius messageReceived = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
    bottomLeft: Radius.circular(xs),
    bottomRight: Radius.circular(lg),
  );
}
