import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraDialogScheme on DialogThemeData {
  static DialogThemeData light(ColorScheme cs) => DialogThemeData(
    backgroundColor: ZintraColors.surfaceDefault,
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.xl),
    elevation: 8,
    titleTextStyle: ZintraTypography.h4Bold(cs),
    contentTextStyle: ZintraTypography.bodyLargeMedium(cs),
  );

  static DialogThemeData dark(ColorScheme cs) => DialogThemeData(
    backgroundColor: ZintraColorPrimitives.neutral800,
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.xl),
    elevation: 8,
    titleTextStyle: ZintraTypography.h4Bold(cs),
    contentTextStyle: ZintraTypography.bodyLargeMedium(cs),
  );
}
