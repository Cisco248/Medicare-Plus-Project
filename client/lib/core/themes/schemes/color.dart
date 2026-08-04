import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

extension ZintraColorScheme on ColorScheme {
  static ColorScheme light() => ColorScheme(
    brightness: Brightness.light,

    primary: ZintraColorPrimitives.primary500,
    onPrimary: ZintraColorPrimitives.neutral900,
    primaryContainer: ZintraColors.brandLight,
    onPrimaryContainer: ZintraColors.brandDark,

    secondary: ZintraColorPrimitives.primary400,
    onSecondary: ZintraColors.onBrand,
    secondaryContainer: ZintraColorPrimitives.primary100,
    onSecondaryContainer: ZintraColorPrimitives.primary800,

    tertiary: ZintraColorPrimitives.lavendPurple500,
    onTertiary: ZintraColors.onBrand,

    error: ZintraColors.errorDefault,
    errorContainer: ZintraColors.errorBorder,
    onError: ZintraColors.errorText,
    onErrorContainer: ZintraColorPrimitives.destructive400,

    surface: ZintraColorPrimitives.white,
    onSurface: ZintraColorPrimitives.black,
    surfaceTint: ZintraColorPrimitives.neutral200,
    surfaceDim: ZintraColorPrimitives.neutral300,
    surfaceContainer: ZintraColorPrimitives.neutral400,

    outline: ZintraColors.borderDefault,
    outlineVariant: ZintraColors.borderStrong,

    scrim: ZintraColors.overlayStrong,
    shadow: ZintraColorPrimitives.black,
  );

  static ColorScheme dark() => ColorScheme(
    brightness: Brightness.dark,

    primary: ZintraColorPrimitives.primary500,
    onPrimary: ZintraColorPrimitives.neutral300,
    primaryContainer: ZintraColorPrimitives.primary800,
    onPrimaryContainer: ZintraColorPrimitives.primary100,

    secondary: ZintraColorPrimitives.primary300,
    onSecondary: ZintraColorPrimitives.neutral900,
    secondaryContainer: ZintraColorPrimitives.primary700,
    onSecondaryContainer: ZintraColorPrimitives.primary50,

    tertiary: ZintraColorPrimitives.lavendPurple400,
    onTertiary: ZintraColorPrimitives.neutral900,

    error: ZintraColorPrimitives.destructive400,
    onError: ZintraColorPrimitives.neutral900,

    surface: ZintraColorPrimitives.neutral900,
    onSurface: ZintraColorPrimitives.white,
    surfaceTint: ZintraColorPrimitives.neutral700,
    surfaceDim: ZintraColorPrimitives.black,
    surfaceContainer: ZintraColorPrimitives.neutral800,

    outline: ZintraColorPrimitives.neutral700,
    outlineVariant: ZintraColorPrimitives.neutral600,
    scrim: ZintraColors.overlayStrong,
    shadow: ZintraColorPrimitives.black,
  );
}
