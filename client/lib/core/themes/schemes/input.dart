import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraInputScheme on InputDecorationTheme {
  static InputDecorationTheme light(ColorScheme cs) => InputDecorationTheme(
    filled: true,
    fillColor: ZintraColors.surfaceSubtle,
    border: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.borderDefault,
        width: ZintraSpacing.borderThin,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.borderDefault,
        width: ZintraSpacing.borderThin,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.borderFocus,
        width: ZintraSpacing.borderMedium,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.errorDefault,
        width: ZintraSpacing.borderThin,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.errorDefault,
        width: ZintraSpacing.borderMedium,
      ),
    ),
    hintStyle: ZintraTypography.bodyLargeRegular(cs),
    labelStyle: ZintraTypography.bodyMediumMedium(cs),
    errorStyle: ZintraTypography.bodySmallMedium(cs),
  );

  static InputDecorationTheme dark(ColorScheme cs) => InputDecorationTheme(
    filled: true,
    fillColor: ZintraColorPrimitives.neutral900,

    border: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.borderDefault,
        width: ZintraSpacing.borderThin,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.borderDefault,
        width: ZintraSpacing.borderThin,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.borderFocus,
        width: ZintraSpacing.borderMedium,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.errorDefault,
        width: ZintraSpacing.borderThin,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: ZintraRadius.md,
      borderSide: BorderSide(
        color: ZintraColors.errorDefault,
        width: ZintraSpacing.borderMedium,
      ),
    ),
    hintStyle: ZintraTypography.bodyLargeRegular(cs),
    labelStyle: ZintraTypography.bodyMediumMedium(cs),
    errorStyle: ZintraTypography.bodySmallMedium(cs),
  );
}
