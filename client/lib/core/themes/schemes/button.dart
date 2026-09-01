import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/schemes/color.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

extension ZintraButtonScheme on ButtonTheme {
  static final lightScheme = ZintraColorScheme.light();
  static final darkScheme = ZintraColorScheme.dark();

  // Default IconButtons stay transparent. Use IconButton.filled /
  // filledTonal only in empty action slots (send, banner shortcuts).
  static IconButtonThemeData lightIconButton(ColorScheme cs) =>
      IconButtonThemeData(style: _plainIconButton(cs));

  static IconButtonThemeData darkIconButton(ColorScheme cs) =>
      IconButtonThemeData(style: _plainIconButton(cs));

  static ButtonStyle _plainIconButton(ColorScheme cs) => IconButton.styleFrom(
    overlayColor: cs.primary.withValues(alpha: 0.08),
    padding: const EdgeInsets.all(ZintraSpacing.sm),
    minimumSize: const Size.square(40),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    iconSize: 20,
    shape: const CircleBorder(),
  );

  // ── ElevatedButton ────────────────────────────────────────
  static ElevatedButtonThemeData lightElevatedButton(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightScheme.primary,
          foregroundColor: lightScheme.onPrimary,
          disabledBackgroundColor: ZintraColors.textDisabled,
          disabledForegroundColor: ZintraColorPrimitives.neutral50,
          textStyle: ZintraTypography.bodyLargeSemiBold(cs),
          padding: const EdgeInsets.symmetric(
            horizontal: ZintraSpacing.lg,
            vertical: ZintraSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
          elevation: 0,
        ),
      );

  static ElevatedButtonThemeData darkElevatedButton(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkScheme.primary,
          foregroundColor: darkScheme.onPrimary,
          disabledBackgroundColor: ZintraColors.textDisabled,
          disabledForegroundColor: ZintraColorPrimitives.neutral50,
          textStyle: ZintraTypography.bodyLargeSemiBold(cs),
          padding: const EdgeInsets.symmetric(
            horizontal: ZintraSpacing.lg,
            vertical: ZintraSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
          elevation: 0,
        ),
      );

  // ── OutlinedButton ────────────────────────────────────────
  static OutlinedButtonThemeData lightOutlinedButtonTheme(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightScheme.primary,
          side: BorderSide(
            color: lightScheme.primary,
            width: ZintraSpacing.borderThin,
          ),
          textStyle: ZintraTypography.bodyLargeSemiBold(cs),
          padding: const EdgeInsets.symmetric(
            horizontal: ZintraSpacing.lg,
            vertical: ZintraSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
        ),
      );

  static OutlinedButtonThemeData darkOutlinedButtonTheme(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkScheme.primary,
          side: BorderSide(
            color: darkScheme.primary,
            width: ZintraSpacing.borderThin,
          ),
          textStyle: ZintraTypography.bodyLargeSemiBold(cs),
          padding: const EdgeInsets.symmetric(
            horizontal: ZintraSpacing.lg,
            vertical: ZintraSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
        ),
      );

  // ── TextButton ────────────────────────────────────────────
  static TextButtonThemeData lightTextButtonTheme(ColorScheme cs) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightScheme.onPrimary,
          backgroundColor: lightScheme.primary,
          textStyle: ZintraTypography.bodyLargeSemiBold(cs),
          padding: const EdgeInsets.symmetric(
            horizontal: ZintraSpacing.xl,
            vertical: ZintraSpacing.xs,
          ),
          shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
        ),
      );

  static TextButtonThemeData darkTextButtonTheme(ColorScheme cs) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkScheme.onPrimary,
          backgroundColor: darkScheme.primary,
          textStyle: ZintraTypography.bodyLargeSemiBold(cs),
          padding: const EdgeInsets.symmetric(
            horizontal: ZintraSpacing.xl,
            vertical: ZintraSpacing.xs,
          ),
          shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
        ),
      );
}
