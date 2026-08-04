/// Zintra Design System — Semantic Color Tokens
/// Use these in widgets instead of raw primitives.
/// Supports Light and Dark themes.
///
library;

import 'package:client/core/themes/primitives/colors.dart';
import 'package:flutter/material.dart';

abstract class ZintraColors {
  // ─── Brand / Interactive ────────────────────────────────────
  static const Color brand = ZintraColorPrimitives.primary500;
  static const Color brandLight = ZintraColorPrimitives.primary100;
  static const Color brandDark = ZintraColorPrimitives.primary800;
  static const Color brandSubtle = ZintraColorPrimitives.primary50;
  static const Color onBrand = ZintraColorPrimitives.white;

  // ─── Surface ───────────────────────────────────────────────
  static const Color surfaceDefault = ZintraColorPrimitives.white;
  static const Color surfaceSubtle = ZintraColorPrimitives.neutral50;
  static const Color surfaceMuted = ZintraColorPrimitives.neutral100;
  static const Color surfaceElevated = ZintraColorPrimitives.white;

  // ─── Background ────────────────────────────────────────────
  static const Color background = ZintraColorPrimitives.neutral50;
  static const Color backgroundPage = ZintraColorPrimitives.white;

  // ─── Text ──────────────────────────────────────────────────
  static const Color textDefault = ZintraColorPrimitives.neutral900;
  static const Color textSubtle = ZintraColorPrimitives.neutral700;
  static const Color textMuted = ZintraColorPrimitives.neutral500;
  static const Color textDisabled = ZintraColorPrimitives.neutral400;
  static const Color textInverse = ZintraColorPrimitives.white;
  static const Color textBrand = ZintraColorPrimitives.primary600;

  // ─── Border ────────────────────────────────────────────────
  static const Color borderDefault = ZintraColorPrimitives.neutral200;
  static const Color borderStrong = ZintraColorPrimitives.neutral300;
  static const Color borderFocus = ZintraColorPrimitives.primary500;
  static const Color borderBrand = ZintraColorPrimitives.primary600;

  // ─── Status: Success ───────────────────────────────────────
  static const Color successDefault = ZintraColorPrimitives.success500;
  static const Color successSubtle = ZintraColorPrimitives.success50;
  static const Color successText = ZintraColorPrimitives.success700;
  static const Color successBorder = ZintraColorPrimitives.success200;

  // ─── Status: Warning ───────────────────────────────────────
  static const Color warningDefault = ZintraColorPrimitives.warning500;
  static const Color warningSubtle = ZintraColorPrimitives.warning50;
  static const Color warningText = ZintraColorPrimitives.warning700;
  static const Color warningBorder = ZintraColorPrimitives.warning200;

  // ─── Status: Error / Destructive ───────────────────────────
  static const Color errorDefault = ZintraColorPrimitives.destructive400;
  static const Color errorSubtle = ZintraColorPrimitives.destructive50;
  static const Color errorText = ZintraColorPrimitives.destructive700;
  static const Color errorBorder = ZintraColorPrimitives.destructive200;

  // ─── Icon ──────────────────────────────────────────────────
  static const Color iconDefault = ZintraColorPrimitives.neutral700;
  static const Color iconSubtle = ZintraColorPrimitives.neutral500;
  static const Color iconBrand = ZintraColorPrimitives.primary600;
  static const Color iconInverse = ZintraColorPrimitives.white;
  static const Color iconDisabled = ZintraColorPrimitives.neutral400;

  // ─── Overlay ───────────────────────────────────────────────
  static const Color overlayLight = Color(0x0A000000); // 4%
  static const Color overlayMedium = Color(0x1A000000); // 10%
  static const Color overlayStrong = Color(0x4D000000); // 30%
}
