import 'package:flutter/material.dart';

export 'package:ai_eru_tawasol/core/extensions/context_ext.dart';

/// Single source of truth for all app colors.
///
/// Light palette  — post-login screens (home, chat, announcement, course, profile)
/// Dark palette   — pre-login screens (splash, onboarding, auth)
abstract class AppColors {
  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xff003096);
  static const Color primaryDark = Color(0xff001E6B);
  static const Color accent = Color(0xff3D6FFF);
  static const Color accentLight = Color(0xff4A7AFF);
  static const Color accentSoft = Color(0xff6B9FFF);
  static const Color accentGradientEnd = Color(0xffA8C8FF);

  // ─── Light surface / background ───────────────────────────────────────────
  static const Color backgroundLight = Color(0xffF0F4FF);
  static const Color surfaceLight = Colors.white;
  static const Color inputBgLight = Color(0xffF1F5F9);
  static const Color dividerLight = Color(0xffE2E8F0);
  static const Color borderLight = Color(0xffE8EDFB);

  // ─── Dark surface / background ────────────────────────────────────────────
  static const Color backgroundDark1 = Color(0xff000D24);
  static const Color backgroundDark2 = Color(0xff001440);
  static const Color backgroundDark3 = Color(0xff001E6B);
  static const Color backgroundDark4 = Color(0xff000A1A);
  static const Color surfaceDark = Color(0xff0A0E1A);
  static const Color surfaceDarkCard = Color(0xff0D1730);
  static const Color fieldDark = Color(0xff0D1F3C);
  static const Color cardGradientStart = Color(0xff1A3A7A);
  static const Color cardGradientEnd = Color(0xff0D1F40);

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xff1E293B);
  static const Color textSecondary = Color(0xff64748B);
  static const Color textHint = Color(0xffA0AABB);
  static const Color textDisabled = Color(0xffCBD5E1);
  static const Color textOnDark = Colors.white;
  static const Color textOnPrimary = Colors.white;

  // ─── Status ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xff10B981);
  static const Color successLight = Color(0xffD1FAE5);
  static const Color error = Color(0xffFF4757);
  static const Color errorLight = Color(0xffFEE2E2);
  static const Color warning = Color(0xffF59E0B);
  static const Color warningLight = Color(0xffFEF3C7);
  static const Color info = Color(0xff2563EB);
  static const Color infoLight = Color(0xffDCEBFF);
  static const Color online = Color(0xff10B981);

  // ─── Chat ─────────────────────────────────────────────────────────────────
  static const Color sentBubble = primary;
  static const Color receivedBubble = Color(0xffF1F5F9);
  static const Color sentBubbleText = Colors.white;
  static const Color receivedBubbleText = textPrimary;

  // ─── Role / content-type palette ─────────────────────────────────────────
  static const Color roleStudent = Color(0xff2563EB);
  static const Color roleStudentLight = Color(0xffDCEBFF);
  static const Color roleDoctor = Color(0xff7C3AED);
  static const Color roleDoctorLight = Color(0xffEDE9FE);
  static const Color roleAdmin = Color(0xffDC2626);
  static const Color roleAdminLight = Color(0xffFEE2E2);

  static const Color contentGreen = Color(0xff059669);
  static const Color contentGreenLight = Color(0xffD1FAE5);
  static const Color contentAmber = Color(0xffF59E0B);
  static const Color contentAmberLight = Color(0xffFEF3C7);
  static const Color contentCyan = Color(0xff0EA5E9);
  static const Color contentCyanLight = Color(0xffE0F2FE);
  static const Color contentTeal = Color(0xff0891B2);
  static const Color contentTealLight = Color(0xffCFFAFE);
  static const Color contentOrange = Color(0xffEA580C);
  static const Color contentOrangeLight = Color(0xffFED7AA);
  static const Color contentPurple = Color(0xff7C3AED);
  static const Color contentPurpleLight = Color(0xffEDE9FE);
}
