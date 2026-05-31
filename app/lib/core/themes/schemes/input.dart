import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraInputScheme on InputDecorationTheme {
  static InputDecorationTheme light() => InputDecorationTheme(
    filled: true,
    fillColor: ZintraColors.surfaceSubtle,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: ZintraSpacing.inputPaddingH,
      vertical: ZintraSpacing.inputPaddingV,
    ),
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
    hintStyle: ZintraTypography.bodyLargeRegular.copyWith(
      color: ZintraColors.textMuted,
    ),
    labelStyle: ZintraTypography.bodyMediumMedium.copyWith(
      color: ZintraColors.textSubtle,
    ),
    errorStyle: ZintraTypography.bodySmallMedium.copyWith(
      color: ZintraColors.errorText,
    ),
  );

  static InputDecorationTheme dark() => InputDecorationTheme(
    filled: true,
    fillColor: ZintraColorPrimitives.neutral900,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: ZintraSpacing.inputPaddingH,
      vertical: ZintraSpacing.inputPaddingV,
    ),
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
    hintStyle: ZintraTypography.bodyLargeRegular.copyWith(
      color: ZintraColors.textMuted,
    ),
    labelStyle: ZintraTypography.bodyMediumMedium.copyWith(
      color: ZintraColors.textSubtle,
    ),
    errorStyle: ZintraTypography.bodySmallMedium.copyWith(
      color: ZintraColors.errorText,
    ),
  );
}
