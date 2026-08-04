import 'package:client/core/themes/schemes/appbar.dart';
import 'package:client/core/themes/schemes/button.dart';
import 'package:client/core/themes/schemes/card.dart';
import 'package:client/core/themes/schemes/chip.dart';
import 'package:client/core/themes/schemes/color.dart';
import 'package:client/core/themes/schemes/dailog.dart';
import 'package:client/core/themes/schemes/divider.dart';
import 'package:client/core/themes/schemes/input.dart';
import 'package:client/core/themes/schemes/navigation.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';
import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';

class ZintraTextTheme {
  static TextTheme build(ColorScheme cs) => TextTheme(
    // Display
    displayLarge: ZintraTypography.displayBold(cs),
    displayMedium: ZintraTypography.displaySemiBold(cs),
    displaySmall: ZintraTypography.displayMedium(cs),
    // Headline → Title/Subtitle
    headlineLarge: ZintraTypography.titleBold(cs),
    headlineMedium: ZintraTypography.subtitleBold(cs),
    headlineSmall: ZintraTypography.h1Bold(cs),
    // Title → H2-H4
    titleLarge: ZintraTypography.h2Bold(cs),
    titleMedium: ZintraTypography.h3SemiBold(cs),
    titleSmall: ZintraTypography.h4SemiBold(cs),
    // Body
    bodyLarge: ZintraTypography.bodyLargeMedium(cs),
    bodyMedium: ZintraTypography.bodyMediumMedium(cs),
    bodySmall: ZintraTypography.bodySmallMedium(cs),
    // Label
    labelLarge: ZintraTypography.labelUpperSemiBold(cs),
    labelMedium: ZintraTypography.captionUpperSemiBold(cs),
    labelSmall: ZintraTypography.bodySmallRegular(cs),
  );
}

class ZintraTheme {
  // ──────────────────────────────────────────────────────────────
  // LIGHT THEME
  // ──────────────────────────────────────────────────────────────
  static ThemeData light() {
    final colorScheme = ZintraColorScheme.light();
    return _buildTheme(colorScheme, Brightness.light);
  }

  // ──────────────────────────────────────────────────────────────
  // DARK THEME  (semantic remapping of the same primitives)
  // ──────────────────────────────────────────────────────────────
  static ThemeData dark() {
    final colorScheme = ZintraColorScheme.dark();
    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ──────────────────────────────────────────────────────────────
  // INTERNAL BUILDER
  // ──────────────────────────────────────────────────────────────
  static ThemeData _buildTheme(ColorScheme cs, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: brightness,
      fontFamily: 'Poppins',
      textTheme: ZintraTextTheme.build(cs),

      // ── Scaffold ──────────────────────────────────────────────
      scaffoldBackgroundColor: isLight
          ? ZintraColors.background
          : ZintraColorPrimitives.neutral900,

      // ── AppBar ────────────────────────────────────────────────
      appBarTheme: isLight
          ? ZintraAppBarScheme.light(cs)
          : ZintraAppBarScheme.dark(cs),

      // -- Button ------------------------------------------------
      elevatedButtonTheme: isLight
          ? ZintraButtonScheme.lightElevatedButton(cs)
          : ZintraButtonScheme.darkElevatedButton(cs),

      outlinedButtonTheme: isLight
          ? ZintraButtonScheme.lightOutlinedButtonTheme(cs)
          : ZintraButtonScheme.darkOutlinedButtonTheme(cs),

      textButtonTheme: isLight
          ? ZintraButtonScheme.lightTextButtonTheme(cs)
          : ZintraButtonScheme.darkTextButtonTheme(cs),

      iconButtonTheme: isLight
          ? ZintraButtonScheme.lightIconButton()
          : ZintraButtonScheme.darkIconButton(),

      // ── InputDecoration ───────────────────────────────────────
      inputDecorationTheme: isLight
          ? ZintraInputScheme.light(cs)
          : ZintraInputScheme.dark(cs),

      // ── Card ──────────────────────────────────────────────────
      cardTheme: isLight ? ZintraCardScheme.light() : ZintraCardScheme.dark(),

      // ── Chip ──────────────────────────────────────────────────
      chipTheme: isLight
          ? ZintraChipScheme.light(cs)
          : ZintraChipScheme.dark(cs),

      // ── Dialog ────────────────────────────────────────────────
      dialogTheme: isLight
          ? ZintraDialogScheme.light(cs)
          : ZintraDialogScheme.dark(cs),

      // ── BottomNavigationBar ───────────────────────────────────
      bottomNavigationBarTheme: isLight
          ? ZintraNavigationScheme.lightBottomNavigation(cs)
          : ZintraNavigationScheme.darkBottomNavigation(cs),

      // ── NavigationBar (M3) ────────────────────────────────────
      navigationBarTheme: isLight
          ? ZintraNavigationScheme.lightNavigationBar(cs)
          : ZintraNavigationScheme.darkNavigationBar(cs),

      // ── Divider ───────────────────────────────────────────────
      dividerTheme: isLight
          ? ZintraDividerScheme.light()
          : ZintraDividerScheme.dark(),

      // ── Switch ────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.onPrimary;
          return ZintraColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          return ZintraColors.borderStrong;
        }),
      ),

      // ── Checkbox ──────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(cs.onPrimary),
        shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.xs),
        side: BorderSide(
          color: ZintraColors.borderStrong,
          width: ZintraSpacing.borderMedium,
        ),
      ),

      // ── Radio ─────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cs.primary;
          return ZintraColors.borderStrong;
        }),
      ),

      // ── SnackBar ──────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ZintraColorPrimitives.neutral800,
        contentTextStyle: ZintraTypography.bodyMediumMedium(cs),
        shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Tooltip ───────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ZintraColorPrimitives.neutral800.withValues(alpha: 0.9),
          borderRadius: ZintraRadius.sm,
        ),
        textStyle: ZintraTypography.bodySmallMedium(cs),
        padding: const EdgeInsets.symmetric(
          horizontal: ZintraSpacing.sm,
          vertical: ZintraSpacing.xxs,
        ),
      ),

      // ── ProgressIndicator ─────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.primaryContainer,
      ),

      // ── Slider ────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.primaryContainer,
        thumbColor: cs.primary,
        overlayColor: cs.primary.withValues(alpha: 0.12),
        valueIndicatorColor: cs.primary,
        valueIndicatorTextStyle: ZintraTypography.bodySmallSemiBold(cs),
      ),

      // ── TabBar ────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: cs.primary,
        unselectedLabelColor: ZintraColors.textMuted,
        indicatorColor: cs.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: ZintraTypography.bodyMediumSemiBold(cs),
        unselectedLabelStyle: ZintraTypography.bodyMediumRegular(cs),
        dividerColor: ZintraColors.borderDefault,
      ),

      // ── FloatingActionButton ──────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: const CircleBorder(),
        elevation: 4,
      ),

      // ── ListTile ──────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ZintraSpacing.md,
          vertical: ZintraSpacing.xs,
        ),
        titleTextStyle: ZintraTypography.bodyLargeMedium(cs),
        subtitleTextStyle: ZintraTypography.bodyMediumRegular(cs),
        iconColor: ZintraColors.iconDefault,
        shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
      ),

      // ── BottomSheet ───────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight
            ? ZintraColors.surfaceDefault
            : ZintraColorPrimitives.neutral800,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ZintraSpacing.radiusXxl),
          ),
        ),
        elevation: 16,
        dragHandleColor: ZintraColors.borderStrong,
      ),
    );
  }
}
