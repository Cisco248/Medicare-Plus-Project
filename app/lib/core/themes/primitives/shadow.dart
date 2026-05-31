import 'package:app/core/themes/primitives/colors.dart';
import 'package:flutter/material.dart';

/// Zintra Design System — Effects System
/// Source: Figma Section 6 — Design Effects System
///
/// Drop Shadows use a Neutral-300 color (both positive and negative offsets = neumorphic)
/// Inner Shadows use Neutral-700
/// Background Blur & Layer Blur are provided as blur radius constants
///

class ShadowPrimitives {
  // ─── Shadow color constants ────────────────────────────────────────────────────
  static const Color dropShadowColor =
      ZintraColorPrimitives.neutral300; // #DDE2E6
  static const Color innerShadowColor =
      ZintraColorPrimitives.neutral700; // #495057

  // ══════════════════════════════════════════════════════════════
  // BLUR RADII  (use with BackdropFilter / ImageFilter)
  // ══════════════════════════════════════════════════════════════

  /// Background blur (bgb-1 → bgb-6): 10, 20, 30, 40, 50, 60
  static const double backgroundBlur1 = 10;
  static const double backgroundBlur2 = 20;
  static const double backgroundBlur3 = 30;
  static const double backgroundBlur4 = 40;
  static const double backgroundBlur5 = 50;
  static const double backgroundBlur6 = 60;

  /// Layer blur (lb-1 → lb-6): 10, 20, 30, 40, 50, 60
  static const double layerBlur1 = 10;
  static const double layerBlur2 = 20;
  static const double layerBlur3 = 30;
  static const double layerBlur4 = 40;
  static const double layerBlur5 = 50;
  static const double layerBlur6 = 60;

  /// A data class describing an inner shadow for use with custom painters.
  /// See package:inner_shadow_widget or build your own CustomPainter.
}
