import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

/// Extension to build a ColorScheme from Zintra tokens
extension ZintraColorScheme on ColorScheme {
  static ColorScheme light() => ColorScheme(
    brightness: Brightness.light,
    primary: ZintraColors.brand,
    onPrimary: ZintraColors.onBrand,
    primaryContainer: ZintraColors.brandLight,
    onPrimaryContainer: ZintraColors.brandDark,
    secondary: ZintraColorPrimitives.primary400,
    onSecondary: ZintraColors.onBrand,
    secondaryContainer: ZintraColorPrimitives.primary100,
    onSecondaryContainer: ZintraColorPrimitives.primary800,
    tertiary: ZintraColorPrimitives.lavendPurple500,
    onTertiary: ZintraColors.onBrand,
    error: ZintraColors.errorDefault,
    onError: ZintraColors.onBrand,
    surface: ZintraColors.surfaceDefault,
    onSurface: ZintraColors.textDefault,
    surfaceContainerHighest: ZintraColors.surfaceMuted,
    outline: ZintraColors.borderDefault,
    outlineVariant: ZintraColors.borderStrong,
    scrim: ZintraColors.overlayStrong,
    shadow: ZintraColorPrimitives.black,
  );

  static ColorScheme dark() => ColorScheme(
    brightness: Brightness.dark,
    primary: ZintraColorPrimitives.primary400,
    onPrimary: ZintraColorPrimitives.neutral900,
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
    onSurface: ZintraColorPrimitives.neutral50,
    surfaceContainerHighest: ZintraColorPrimitives.neutral800,
    outline: ZintraColorPrimitives.neutral700,
    outlineVariant: ZintraColorPrimitives.neutral600,
    scrim: ZintraColors.overlayStrong,
    shadow: ZintraColorPrimitives.black,
  );
}
