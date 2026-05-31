import 'package:app/core/themes/primitives/shadow.dart';
import 'package:flutter/material.dart';

abstract class ZintraShadows {
  // ══════════════════════════════════════════════════════════════
  // DROP SHADOWS  (dsh-*)
  // Figma uses symmetrical offset: e.g. (+4,+4) and (-4,-4) for both sides.
  // Flutter BoxShadow doesn't support negative-offset bilateral shadows natively,
  // so we provide both a positive and negative variant per size, plus a combined list.
  // ══════════════════════════════════════════════════════════════

  /// xs: radius 8, offset ±4
  static const List<BoxShadow> dropShadowXs = [
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 8,
      offset: Offset(4, 4),
    ),
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 8,
      offset: Offset(-4, -4),
    ),
  ];

  /// s: radius 12, offset ±8
  static const List<BoxShadow> dropShadowS = [
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 12,
      offset: Offset(8, 8),
    ),
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 12,
      offset: Offset(-8, -8),
    ),
  ];

  /// m: radius 16, offset ±12
  static const List<BoxShadow> dropShadowM = [
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 16,
      offset: Offset(12, 12),
    ),
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 16,
      offset: Offset(-12, -12),
    ),
  ];

  /// l: radius 20, offset ±16
  static const List<BoxShadow> dropShadowL = [
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 20,
      offset: Offset(16, 16),
    ),
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 20,
      offset: Offset(-16, -16),
    ),
  ];

  /// xl: radius 24, offset ±20
  static const List<BoxShadow> dropShadowXl = [
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 24,
      offset: Offset(20, 20),
    ),
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 24,
      offset: Offset(-20, -20),
    ),
  ];

  /// 2xl: radius 28, offset ±24
  static const List<BoxShadow> dropShadow2xl = [
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 28,
      offset: Offset(24, 24),
    ),
    BoxShadow(
      color: ShadowPrimitives.dropShadowColor,
      blurRadius: 28,
      offset: Offset(-24, -24),
    ),
  ];

  // ══════════════════════════════════════════════════════════════
  // STANDARD (single-direction) DROP SHADOWS — for cards/modals
  // ══════════════════════════════════════════════════════════════

  static const List<BoxShadow> cardShadowSm = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> cardShadowMd = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> cardShadowLg = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> modalShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 40, offset: Offset(0, 16)),
  ];

  // ══════════════════════════════════════════════════════════════
  // INNER SHADOWS  (ish-*)
  // Flutter doesn't natively support inner shadows in BoxDecoration.
  // Use these values with a CustomPainter or the `inner_shadow` package.
  // ══════════════════════════════════════════════════════════════

  static const ZintraInnerShadow innerShadowXs = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 8,
    offset: Offset(4, 4),
  );
  static const ZintraInnerShadow innerShadowXsN = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 8,
    offset: Offset(-4, -4),
  );
  static const ZintraInnerShadow innerShadowS = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 12,
    offset: Offset(8, 8),
  );
  static const ZintraInnerShadow innerShadowSN = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 12,
    offset: Offset(-8, -8),
  );
  static const ZintraInnerShadow innerShadowM = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 16,
    offset: Offset(12, 12),
  );
  static const ZintraInnerShadow innerShadowMN = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 16,
    offset: Offset(-12, -12),
  );
  static const ZintraInnerShadow innerShadowL = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 20,
    offset: Offset(16, 16),
  );
  static const ZintraInnerShadow innerShadowLN = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 20,
    offset: Offset(-16, -16),
  );
  static const ZintraInnerShadow innerShadowXl = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 24,
    offset: Offset(20, 20),
  );
  static const ZintraInnerShadow innerShadowXlN = ZintraInnerShadow(
    color: ShadowPrimitives.innerShadowColor,
    blurRadius: 24,
    offset: Offset(-20, -20),
  );
}

@immutable
class ZintraInnerShadow {
  final Color color;
  final double blurRadius;
  final Offset offset;

  const ZintraInnerShadow({
    required this.color,
    required this.blurRadius,
    required this.offset,
  });

  @override
  String toString() =>
      'ZintraInnerShadow(blurRadius: $blurRadius, offset: $offset)';
}
