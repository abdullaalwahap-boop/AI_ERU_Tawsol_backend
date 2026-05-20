import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography system.
///
/// All styles use Plus Jakarta Sans and expose named semantic tokens
/// so widgets say `AppTextStyles.bodyMedium` rather than repeating font params.
abstract class AppTextStyles {
  // ─── Display ──────────────────────────────────────────────────────────────
  static TextStyle get display => GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  // ─── Headings ─────────────────────────────────────────────────────────────
  static TextStyle get heading1 => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get heading2 => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get heading3 => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get heading4 => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // ─── Title ────────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // ─── Body ─────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ─── Label ────────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // ─── Caption / Meta ───────────────────────────────────────────────────────
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get overline => GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        height: 1.4,
      );

  // ─── Button ───────────────────────────────────────────────────────────────
  static TextStyle get buttonLarge => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.0,
      );

  static TextStyle get buttonMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.0,
      );

  static TextStyle get buttonSmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.0,
      );

  // ─── Badge / Chip ─────────────────────────────────────────────────────────
  static TextStyle get badgeText => GoogleFonts.plusJakartaSans(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        height: 1.0,
      );
}
