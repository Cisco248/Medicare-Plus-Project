import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraChipScheme on ChipThemeData {
  static ChipThemeData light(ColorScheme cs) => ChipThemeData(
    backgroundColor: ZintraColors.surfaceMuted,
    selectedColor: cs.primaryContainer,
    labelStyle: ZintraTypography.bodySmallSemiBold,
    padding: const EdgeInsets.symmetric(
      horizontal: ZintraSpacing.sm,
      vertical: ZintraSpacing.xxs,
    ),
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.full),
    side: BorderSide.none,
  );

  static ChipThemeData dark(ColorScheme cs) => ChipThemeData(
    backgroundColor: ZintraColorPrimitives.neutral700,
    selectedColor: cs.primaryContainer,
    labelStyle: ZintraTypography.bodySmallSemiBold,
    padding: const EdgeInsets.symmetric(
      horizontal: ZintraSpacing.sm,
      vertical: ZintraSpacing.xxs,
    ),
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.full),
    side: BorderSide.none,
  );
}
