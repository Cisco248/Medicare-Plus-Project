import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraCardScheme on CardTheme {
  static CardThemeData light() => CardThemeData(
    color: ZintraColors.surfaceDefault,
    elevation: 0,
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.lg),
    margin: const EdgeInsets.all(ZintraSpacing.xs),
  );

  static CardThemeData dark() => CardThemeData(
    color: ZintraColorPrimitives.neutral800,
    elevation: 0,
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.lg),
    margin: const EdgeInsets.all(ZintraSpacing.xs),
  );
}
