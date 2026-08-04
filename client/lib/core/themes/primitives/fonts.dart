/// Zintra Design System — Typography
/// Font: Poppins (add to pubspec.yaml under google_fonts or assets)
/// Source: Figma Zintra V1.1.0 — Section 3. Typography System
///
/// Scale (mobile-first, letter-spacing always -2%):
///   Display   52px  | Title   48px  | Subtitle 40px
///   H1 36px  | H2 32px  | H3 28px  | H4 24px  | H5 20px  | H6 16px
///   Body-L 16px | Body-M 14px | Body-S 12px
///   Label / Caption 16px / 14px (with Underline / Strikethrough variants)
///   Paragraph 16px (with larger line-height)
///
/// Weights map: Light→w300, Regular→w400, Medium→w500, SemiBold→w600, Bold→w700, ExtraBold→w800
library;

import 'package:flutter/material.dart';

class ZintraTypography {
  final ColorScheme cs;

  static const String _font = 'Poppins';

  static double _ls(double fontSize) => fontSize * -0.02;

  static TextStyle _builder({
    double? size,
    double? lineHeight,
    FontWeight? weight,
    TextDecoration? decoration,
    Color? color,
  }) => TextStyle(
    fontFamily: _font,
    fontSize: size,
    fontWeight: weight,
    height: lineHeight! / size!,
    letterSpacing: _ls(size),
    color: color,
    decoration: decoration,
  );

  // DISPLAY  (52px)
  static TextStyle displayRegular(ColorScheme cs) => _builder(
    size: 52,
    weight: FontWeight.w500,
    lineHeight: 44,
    color: cs.onPrimary,
  );
  static TextStyle displayMedium(ColorScheme cs) => _builder(
    size: 52,
    weight: FontWeight.w600,
    lineHeight: 44,
    color: cs.onPrimary,
  );
  static TextStyle displaySemiBold(ColorScheme cs) => _builder(
    size: 52,
    weight: FontWeight.w700,
    lineHeight: 44,
    color: cs.onPrimary,
  );
  static TextStyle displayBold(ColorScheme cs) => _builder(
    size: 52,
    weight: FontWeight.w800,
    lineHeight: 44,
    color: cs.onPrimary,
  );

  // TITLE  (48px)
  static TextStyle titleRegular(ColorScheme cs) => _builder(
    size: 48,
    weight: FontWeight.w300,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle titleMedium(ColorScheme cs) => _builder(
    size: 48,
    weight: FontWeight.w400,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle titleSemiBold(ColorScheme cs) => _builder(
    size: 48,
    weight: FontWeight.w500,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle titleBold(ColorScheme cs) => _builder(
    size: 48,
    weight: FontWeight.w600,
    lineHeight: 40,
    color: cs.onPrimary,
  );

  // SUBTITLE  (40px)
  static TextStyle subtitleRegular(ColorScheme cs) => _builder(
    size: 40,
    weight: FontWeight.w300,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle subtitleMedium(ColorScheme cs) => _builder(
    size: 40,
    weight: FontWeight.w400,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle subtitleSemiBold(ColorScheme cs) => _builder(
    size: 40,
    weight: FontWeight.w500,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle subtitleBold(ColorScheme cs) => _builder(
    size: 40,
    weight: FontWeight.w600,
    lineHeight: 40,
    color: cs.onPrimary,
  );

  // HEADING  (mobile)
  // H1 — 36px / lh44
  static TextStyle h1Regular(ColorScheme cs) => _builder(
    size: 36,
    weight: FontWeight.w300,
    lineHeight: 44,
    color: cs.onPrimary,
  );
  static TextStyle h1Medium(ColorScheme cs) => _builder(
    size: 36,
    weight: FontWeight.w400,
    lineHeight: 44,
    color: cs.onPrimary,
  );
  static TextStyle h1SemiBold(ColorScheme cs) => _builder(
    size: 36,
    weight: FontWeight.w500,
    lineHeight: 44,
    color: cs.onPrimary,
  );
  static TextStyle h1Bold(ColorScheme cs) => _builder(
    size: 36,
    weight: FontWeight.w600,
    lineHeight: 44,
    color: cs.onPrimary,
  );

  // H2 — 32px / lh40
  static TextStyle h2Regular(ColorScheme cs) => _builder(
    size: 32,
    weight: FontWeight.w300,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle h2Medium(ColorScheme cs) => _builder(
    size: 32,
    weight: FontWeight.w400,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle h2SemiBold(ColorScheme cs) => _builder(
    size: 32,
    weight: FontWeight.w500,
    lineHeight: 40,
    color: cs.onPrimary,
  );
  static TextStyle h2Bold(ColorScheme cs) => _builder(
    size: 32,
    weight: FontWeight.w600,
    lineHeight: 40,
    color: cs.onPrimary,
  );

  // H3 — 28px / lh36
  static TextStyle h3Regular(ColorScheme cs) => _builder(
    size: 28,
    weight: FontWeight.w300,
    lineHeight: 36,
    color: cs.onPrimary,
  );
  static TextStyle h3Medium(ColorScheme cs) => _builder(
    size: 28,
    weight: FontWeight.w400,
    lineHeight: 36,
    color: cs.onPrimary,
  );
  static TextStyle h3SemiBold(ColorScheme cs) => _builder(
    size: 28,
    weight: FontWeight.w500,
    lineHeight: 36,
    color: cs.onPrimary,
  );
  static TextStyle h3Bold(ColorScheme cs) => _builder(
    size: 28,
    weight: FontWeight.w600,
    lineHeight: 36,
    color: cs.onPrimary,
  );

  // H4 — 24px / lh32
  static TextStyle h4Regular(ColorScheme cs) => _builder(
    size: 24,
    weight: FontWeight.w300,
    lineHeight: 32,
    color: cs.onPrimary,
  );
  static TextStyle h4Medium(ColorScheme cs) => _builder(
    size: 24,
    weight: FontWeight.w400,
    lineHeight: 32,
    color: cs.onPrimary,
  );
  static TextStyle h4SemiBold(ColorScheme cs) => _builder(
    size: 24,
    weight: FontWeight.w500,
    lineHeight: 32,
    color: cs.onPrimary,
  );
  static TextStyle h4Bold(ColorScheme cs) => _builder(
    size: 24,
    weight: FontWeight.w600,
    lineHeight: 32,
    color: cs.onPrimary,
  );

  // H5 — 20px / lh28
  static TextStyle h5Regular(ColorScheme cs) => _builder(
    size: 20,
    weight: FontWeight.w300,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle h5Medium(ColorScheme cs) => _builder(
    size: 20,
    weight: FontWeight.w400,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle h5SemiBold(ColorScheme cs) => _builder(
    size: 20,
    weight: FontWeight.w500,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle h5Bold(ColorScheme cs) => _builder(
    size: 20,
    weight: FontWeight.w600,
    lineHeight: 28,
    color: cs.onPrimary,
  );

  // H6 — 16px / lh24
  static TextStyle h6Regular(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w300,
    lineHeight: 24,
    color: cs.onPrimary,
  );
  static TextStyle h6Medium(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 24,
    color: cs.onPrimary,
  );
  static TextStyle h6SemiBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w500,
    lineHeight: 24,
    color: cs.onPrimary,
  );
  static TextStyle h6Bold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 24,
    color: cs.onPrimary,
  );

  // BODY  (mobile)
  // Large — 16px / lh20
  static TextStyle bodyLargeRegular(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w300,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle bodyLargeMedium(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle bodyLargeSemiBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle bodyLargeBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle bodyLargeExtraBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
  );

  // Medium — 14px / lh18
  static TextStyle bodyMediumRegular(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w300,
    lineHeight: 18,
    color: cs.onPrimary,
  );
  static TextStyle bodyMediumMedium(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w400,
    lineHeight: 18,
    color: cs.onPrimary,
  );
  static TextStyle bodyMediumSemiBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 18,
    color: cs.onPrimary,
  );
  static TextStyle bodyMediumBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w600,
    lineHeight: 18,
    color: cs.onPrimary,
  );
  static TextStyle bodyMediumExtraBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w700,
    lineHeight: 18,
    color: cs.onPrimary,
  );

  // Small — 12px / lh16
  static TextStyle bodySmallRegular(ColorScheme cs) => _builder(
    size: 12,
    weight: FontWeight.w300,
    lineHeight: 16,
    color: cs.onPrimary,
  );
  static TextStyle bodySmallMedium(ColorScheme cs) => _builder(
    size: 12,
    weight: FontWeight.w400,
    lineHeight: 16,
    color: cs.onPrimary,
  );
  static TextStyle bodySmallSemiBold(ColorScheme cs) => _builder(
    size: 12,
    weight: FontWeight.w500,
    lineHeight: 16,
    color: cs.onPrimary,
  );
  static TextStyle bodySmallBold(ColorScheme cs) => _builder(
    size: 12,
    weight: FontWeight.w600,
    lineHeight: 16,
    color: cs.onPrimary,
  );
  static TextStyle bodySmallExtraBold(ColorScheme cs) => _builder(
    size: 12,
    weight: FontWeight.w700,
    lineHeight: 16,
    color: cs.onPrimary,
  );

  // LABEL  (16px / lh20) — Underline
  static TextStyle labelUnderlineRegular(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w300,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle labelUnderlineMedium(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle labelUnderlineSemiBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle labelUnderlineBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle labelUnderlineExtraBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle labelUnderlineBlack(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w800,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );

  // LABEL  (16px / lh20) — Strikethrough
  static TextStyle labelStrikeRegular(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w300,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeMedium(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeSemiBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeExtraBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeBlack(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w800,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );

  // LABEL  (16px / lh20) — Upper
  static TextStyle labelUpperRegular(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w300,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle labelUpperMedium(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle labelUpperSemiBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle labelUpperBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle labelUpperExtraBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle labelUpperBlack(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w800,
    lineHeight: 20,
    color: cs.onPrimary,
  );

  // CAPTION  (14px / lh20)
  static TextStyle captionUnderlineRegular(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w300,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle captionUnderlineMedium(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle captionUnderlineSemiBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle captionUnderlineBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle captionUnderlineExtraBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );
  static TextStyle captionUnderlineBlack(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w800,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.underline,
  );

  static TextStyle captionStrikeRegular(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w300,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeMedium(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeSemiBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeExtraBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle captionUpperRegular(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w400,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle captionUpperMedium(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle captionUpperSemiBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w600,
    lineHeight: 20,
    color: cs.onPrimary,
  );
  static TextStyle captionUpperBold(ColorScheme cs) => _builder(
    size: 14,
    weight: FontWeight.w700,
    lineHeight: 20,
    color: cs.onPrimary,
  );

  // PARAGRAPH  16px / lh28
  static TextStyle paragraphRegular(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w300,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle paragraphMedium(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle paragraphSemiBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w500,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle paragraphBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 28,
    color: cs.onPrimary,
  );
  static TextStyle paragraphExtraBold(ColorScheme cs) => _builder(
    size: 16,
    weight: FontWeight.w700,
    lineHeight: 28,
    color: cs.onPrimary,
  );

  ZintraTypography({required this.cs});
}
