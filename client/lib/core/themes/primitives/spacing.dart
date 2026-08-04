/// Zintra Design System — Spacing System
/// Source: Figma Section 4 — Mobile & Desktop Spacing Variants
/// Base unit: 4px (4dp grid)
///
/// Usage:
///   Padding(padding: EdgeInsets.all(ZintraSpacing.s4))
///   SizedBox(height: ZintraSpacing.s12)
///

library;

abstract class ZintraSpacing {
  // ─── Raw scale ──────────────────────────────────────────────
  static const double s0 = 0;
  static const double s1 = 2;
  static const double s2 = 4;
  static const double s3 = 6;
  static const double s4 = 8;
  static const double s5 = 10;
  static const double s6 = 12;
  static const double s7 = 14;
  static const double s8 = 16;
  static const double s9 = 18;
  static const double s10 = 20;
  static const double s12 = 24;
  static const double s14 = 28;
  static const double s16 = 32;
  static const double s18 = 36;
  static const double s20 = 40;
  static const double s24 = 48;
  static const double s28 = 56;
  static const double s32 = 64;
  static const double s36 = 72;
  static const double s40 = 80;
  static const double s48 = 96;
  static const double s56 = 112;
  static const double s64 = 128;

  // ─── Semantic aliases (mobile) ─────────────────────────────
  static const double none = s0;
  static const double xxs = s2; //  4
  static const double xs = s4; //  8
  static const double sm = s6; // 12
  static const double md = s8; // 16
  static const double lg = s12; // 24
  static const double xl = s16; // 32
  static const double xxl = s20; // 40
  static const double xxxl = s24; // 48

  // ─── Component-level tokens ────────────────────────────────
  static const double buttonPaddingH = s8; // 16 horizontal
  static const double buttonPaddingV = s4; //  8 vertical
  static const double inputPaddingH = s8; // 16
  static const double inputPaddingV = s6; // 12
  static const double cardPadding = s12; // 24
  static const double sectionGap = s20; // 40
  static const double itemGap = s8; // 16
  static const double iconGap = s4; //  8
  static const double pageMargin = s8; // 16
  static const double pageMarginDesk = s24; // 48 (desktop)

  // ─── Border radius ─────────────────────────────────────────
  static const double radiusNone = 0;
  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusXxl = 24;
  static const double radiusFull = 9999;

  // ─── Border width ──────────────────────────────────────────
  static const double borderThin = 1;
  static const double borderMedium = 2;
  static const double borderThick = 4;
}
