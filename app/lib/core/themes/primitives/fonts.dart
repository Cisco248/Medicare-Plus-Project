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
  // ── Letter spacing helper: -2% of fontSize ─────────────────
  static double _ls(double fontSize) => fontSize * -0.02;

  // ─── Font family ────────────────────────────────────────────
  static const String _font = 'Poppins';

  // ════════════════════════════════════════════════════════════
  // DISPLAY  (52px)
  // ════════════════════════════════════════════════════════════
  static TextStyle displayRegular = TextStyle(
    fontFamily: _font,
    fontSize: 52,
    fontWeight: FontWeight.w500,
    height: 44 / 52,
    letterSpacing: _ls(52),
  );
  static TextStyle displayMedium = TextStyle(
    fontFamily: _font,
    fontSize: 52,
    fontWeight: FontWeight.w600,
    height: 44 / 52,
    letterSpacing: _ls(52),
  );
  static TextStyle displaySemiBold = TextStyle(
    fontFamily: _font,
    fontSize: 52,
    fontWeight: FontWeight.w700,
    height: 44 / 52,
    letterSpacing: _ls(52),
  );
  static TextStyle displayBold = TextStyle(
    fontFamily: _font,
    fontSize: 52,
    fontWeight: FontWeight.w800,
    height: 44 / 52,
    letterSpacing: _ls(52),
  );

  // ════════════════════════════════════════════════════════════
  // TITLE  (48px)
  // ════════════════════════════════════════════════════════════
  static TextStyle titleRegular = TextStyle(
    fontFamily: _font,
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 40 / 48,
    letterSpacing: _ls(48),
  );
  static TextStyle titleMedium = TextStyle(
    fontFamily: _font,
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 40 / 48,
    letterSpacing: _ls(48),
  );
  static TextStyle titleSemiBold = TextStyle(
    fontFamily: _font,
    fontSize: 48,
    fontWeight: FontWeight.w500,
    height: 40 / 48,
    letterSpacing: _ls(48),
  );
  static TextStyle titleBold = TextStyle(
    fontFamily: _font,
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 40 / 48,
    letterSpacing: _ls(48),
  );

  // ════════════════════════════════════════════════════════════
  // SUBTITLE  (40px)
  // ════════════════════════════════════════════════════════════
  static TextStyle subtitleRegular = TextStyle(
    fontFamily: _font,
    fontSize: 40,
    fontWeight: FontWeight.w300,
    height: 36 / 40,
    letterSpacing: _ls(40),
  );
  static TextStyle subtitleMedium = TextStyle(
    fontFamily: _font,
    fontSize: 40,
    fontWeight: FontWeight.w400,
    height: 36 / 40,
    letterSpacing: _ls(40),
  );
  static TextStyle subtitleSemiBold = TextStyle(
    fontFamily: _font,
    fontSize: 40,
    fontWeight: FontWeight.w500,
    height: 36 / 40,
    letterSpacing: _ls(40),
  );
  static TextStyle subtitleBold = TextStyle(
    fontFamily: _font,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 36 / 40,
    letterSpacing: _ls(40),
  );

  // ════════════════════════════════════════════════════════════
  // HEADING  (mobile)
  // ════════════════════════════════════════════════════════════

  // H1 — 36px / lh44
  static TextStyle h1Regular = _heading(36, 44, FontWeight.w300);
  static TextStyle h1Medium = _heading(36, 44, FontWeight.w400);
  static TextStyle h1SemiBold = _heading(36, 44, FontWeight.w500);
  static TextStyle h1Bold = _heading(36, 44, FontWeight.w600);

  // H2 — 32px / lh40
  static TextStyle h2Regular = _heading(32, 40, FontWeight.w300);
  static TextStyle h2Medium = _heading(32, 40, FontWeight.w400);
  static TextStyle h2SemiBold = _heading(32, 40, FontWeight.w500);
  static TextStyle h2Bold = _heading(32, 40, FontWeight.w600);

  // H3 — 28px / lh36
  static TextStyle h3Regular = _heading(28, 36, FontWeight.w300);
  static TextStyle h3Medium = _heading(28, 36, FontWeight.w400);
  static TextStyle h3SemiBold = _heading(28, 36, FontWeight.w500);
  static TextStyle h3Bold = _heading(28, 36, FontWeight.w600);

  // H4 — 24px / lh32
  static TextStyle h4Regular = _heading(24, 32, FontWeight.w300);
  static TextStyle h4Medium = _heading(24, 32, FontWeight.w400);
  static TextStyle h4SemiBold = _heading(24, 32, FontWeight.w500);
  static TextStyle h4Bold = _heading(24, 32, FontWeight.w600);

  // H5 — 20px / lh28
  static TextStyle h5Regular = _heading(20, 28, FontWeight.w300);
  static TextStyle h5Medium = _heading(20, 28, FontWeight.w400);
  static TextStyle h5SemiBold = _heading(20, 28, FontWeight.w500);
  static TextStyle h5Bold = _heading(20, 28, FontWeight.w600);

  // H6 — 16px / lh24
  static TextStyle h6Regular = _heading(16, 24, FontWeight.w300);
  static TextStyle h6Medium = _heading(16, 24, FontWeight.w400);
  static TextStyle h6SemiBold = _heading(16, 24, FontWeight.w500);
  static TextStyle h6Bold = _heading(16, 24, FontWeight.w600);

  static TextStyle _heading(double size, double lh, FontWeight w) => TextStyle(
    fontFamily: _font,
    fontSize: size,
    fontWeight: w,
    height: lh / size,
    letterSpacing: _ls(size),
  );

  // ════════════════════════════════════════════════════════════
  // BODY  (mobile)
  // ════════════════════════════════════════════════════════════

  // Large — 16px / lh20
  static TextStyle bodyLargeRegular = _body(16, 20, FontWeight.w300);
  static TextStyle bodyLargeMedium = _body(16, 20, FontWeight.w400);
  static TextStyle bodyLargeSemiBold = _body(16, 20, FontWeight.w500);
  static TextStyle bodyLargeBold = _body(16, 20, FontWeight.w600);
  static TextStyle bodyLargeExtraBold = _body(16, 20, FontWeight.w700);

  // Medium — 14px / lh18
  static TextStyle bodyMediumRegular = _body(14, 18, FontWeight.w300);
  static TextStyle bodyMediumMedium = _body(14, 18, FontWeight.w400);
  static TextStyle bodyMediumSemiBold = _body(14, 18, FontWeight.w500);
  static TextStyle bodyMediumBold = _body(14, 18, FontWeight.w600);
  static TextStyle bodyMediumExtraBold = _body(14, 18, FontWeight.w700);

  // Small — 12px / lh16
  static TextStyle bodySmallRegular = _body(12, 16, FontWeight.w300);
  static TextStyle bodySmallMedium = _body(12, 16, FontWeight.w400);
  static TextStyle bodySmallSemiBold = _body(12, 16, FontWeight.w500);
  static TextStyle bodySmallBold = _body(12, 16, FontWeight.w600);
  static TextStyle bodySmallExtraBold = _body(12, 16, FontWeight.w700);

  static TextStyle _body(double size, double lh, FontWeight w) => TextStyle(
    fontFamily: _font,
    fontSize: size,
    fontWeight: w,
    height: lh / size,
    letterSpacing: _ls(size),
  );

  // ════════════════════════════════════════════════════════════
  // LABEL  (16px / lh20)  — Underline / Strikethrough / Case variants
  // ════════════════════════════════════════════════════════════
  static TextStyle labelUnderlineRegular = _label(
    FontWeight.w300,
    TextDecoration.underline,
  );
  static TextStyle labelUnderlineMedium = _label(
    FontWeight.w400,
    TextDecoration.underline,
  );
  static TextStyle labelUnderlineSemiBold = _label(
    FontWeight.w500,
    TextDecoration.underline,
  );
  static TextStyle labelUnderlineBold = _label(
    FontWeight.w600,
    TextDecoration.underline,
  );
  static TextStyle labelUnderlineExtraBold = _label(
    FontWeight.w700,
    TextDecoration.underline,
  );
  static TextStyle labelUnderlineBlack = _label(
    FontWeight.w800,
    TextDecoration.underline,
  );

  static TextStyle labelStrikeRegular = _label(
    FontWeight.w300,
    TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeMedium = _label(
    FontWeight.w400,
    TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeSemiBold = _label(
    FontWeight.w500,
    TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeBold = _label(
    FontWeight.w600,
    TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeExtraBold = _label(
    FontWeight.w700,
    TextDecoration.lineThrough,
  );
  static TextStyle labelStrikeBlack = _label(
    FontWeight.w800,
    TextDecoration.lineThrough,
  );

  static TextStyle labelUpperRegular = _label(FontWeight.w300);
  static TextStyle labelUpperMedium = _label(FontWeight.w400);
  static TextStyle labelUpperSemiBold = _label(FontWeight.w500);
  static TextStyle labelUpperBold = _label(FontWeight.w600);
  static TextStyle labelUpperExtraBold = _label(FontWeight.w700);
  static TextStyle labelUpperBlack = _label(FontWeight.w800);

  static TextStyle _label([
    FontWeight w = FontWeight.w400,
    TextDecoration? dec,
  ]) => TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: w,
    height: 20 / 16,
    letterSpacing: _ls(16),
    decoration: dec,
  );

  // ════════════════════════════════════════════════════════════
  // CAPTION  (14px / lh20)
  // ════════════════════════════════════════════════════════════
  static TextStyle captionUnderlineRegular = _caption(
    FontWeight.w300,
    TextDecoration.underline,
  );
  static TextStyle captionUnderlineMedium = _caption(
    FontWeight.w400,
    TextDecoration.underline,
  );
  static TextStyle captionUnderlineSemiBold = _caption(
    FontWeight.w500,
    TextDecoration.underline,
  );
  static TextStyle captionUnderlineBold = _caption(
    FontWeight.w600,
    TextDecoration.underline,
  );
  static TextStyle captionUnderlineExtraBold = _caption(
    FontWeight.w700,
    TextDecoration.underline,
  );
  static TextStyle captionUnderlineBlack = _caption(
    FontWeight.w800,
    TextDecoration.underline,
  );

  static TextStyle captionStrikeRegular = _caption(
    FontWeight.w300,
    TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeMedium = _caption(
    FontWeight.w400,
    TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeSemiBold = _caption(
    FontWeight.w500,
    TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeBold = _caption(
    FontWeight.w600,
    TextDecoration.lineThrough,
  );
  static TextStyle captionStrikeExtraBold = _caption(
    FontWeight.w700,
    TextDecoration.lineThrough,
  );

  static TextStyle captionUpperRegular = _caption(FontWeight.w300);
  static TextStyle captionUpperMedium = _caption(FontWeight.w400);
  static TextStyle captionUpperSemiBold = _caption(FontWeight.w500);
  static TextStyle captionUpperBold = _caption(FontWeight.w600);

  static TextStyle _caption([
    FontWeight w = FontWeight.w400,
    TextDecoration? dec,
  ]) => TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: w,
    height: 20 / 14,
    letterSpacing: _ls(14),
    decoration: dec,
  );

  // ════════════════════════════════════════════════════════════
  // PARAGRAPH  (16px / lh28 — more generous line height)
  // ════════════════════════════════════════════════════════════
  static TextStyle paragraphRegular = _para(FontWeight.w300);
  static TextStyle paragraphMedium = _para(FontWeight.w400);
  static TextStyle paragraphSemiBold = _para(FontWeight.w500);
  static TextStyle paragraphBold = _para(FontWeight.w600);
  static TextStyle paragraphExtraBold = _para(FontWeight.w700);

  static TextStyle _para([FontWeight w = FontWeight.w400]) => TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: w,
    height: 28 / 16,
    letterSpacing: _ls(16),
  );
}
