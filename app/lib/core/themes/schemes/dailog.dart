import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraDialogScheme on DialogThemeData {
  static DialogThemeData light() => DialogThemeData(
    backgroundColor: ZintraColors.surfaceDefault,
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.xl),
    elevation: 8,
    titleTextStyle: ZintraTypography.h4Bold.copyWith(
      color: ZintraColors.textDefault,
    ),
    contentTextStyle: ZintraTypography.bodyLargeMedium.copyWith(
      color: ZintraColors.textSubtle,
    ),
  );

  static DialogThemeData dark() => DialogThemeData(
    backgroundColor: ZintraColorPrimitives.neutral800,
    shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.xl),
    elevation: 8,
    titleTextStyle: ZintraTypography.h4Bold.copyWith(
      color: ZintraColorPrimitives.neutral50,
    ),
    contentTextStyle: ZintraTypography.bodyLargeMedium.copyWith(
      color: ZintraColorPrimitives.neutral300,
    ),
  );
}
