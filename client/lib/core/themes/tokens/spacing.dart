import 'package:client/core/themes/primitives/spacing.dart';
import 'package:flutter/material.dart';

/// EdgeInsets helpers built from ZintraSpacing tokens
extension ZintraEdgeInsets on EdgeInsets {
  static EdgeInsets page({bool desktop = false}) => EdgeInsets.symmetric(
    horizontal: desktop
        ? ZintraSpacing.pageMarginDesk
        : ZintraSpacing.pageMargin,
    vertical: ZintraSpacing.md,
  );

  static EdgeInsets card() => const EdgeInsets.all(ZintraSpacing.cardPadding);

  static EdgeInsets button({bool large = false}) => EdgeInsets.symmetric(
    horizontal: large ? ZintraSpacing.lg : ZintraSpacing.buttonPaddingH,
    vertical: large ? ZintraSpacing.sm : ZintraSpacing.buttonPaddingV,
  );

  static EdgeInsets input() => const EdgeInsets.symmetric(
    horizontal: ZintraSpacing.inputPaddingH,
    vertical: ZintraSpacing.inputPaddingV,
  );
}

/// BorderRadius helpers built from ZintraSpacing tokens
abstract class ZintraRadius {
  static const BorderRadius none = BorderRadius.zero;
  static const BorderRadius xs = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusXs),
  );
  static const BorderRadius sm = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusSm),
  );
  static const BorderRadius md = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusMd),
  );
  static const BorderRadius lg = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusLg),
  );
  static const BorderRadius xl = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusXl),
  );
  static const BorderRadius xxl = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusXxl),
  );
  static const BorderRadius full = BorderRadius.all(
    Radius.circular(ZintraSpacing.radiusFull),
  );
}
