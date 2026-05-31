// # Design Mobile Application Configuration and values
import 'package:app/core/themes/schemes/appbar.dart';
import 'package:app/core/themes/schemes/button.dart';
import 'package:app/core/themes/schemes/card.dart';
import 'package:app/core/themes/schemes/chip.dart';
import 'package:app/core/themes/schemes/color.dart';
import 'package:app/core/themes/schemes/dailog.dart';
import 'package:app/core/themes/schemes/divider.dart';
import 'package:app/core/themes/schemes/input.dart';
import 'package:app/core/themes/schemes/navigation.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';
import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';

/// Zintra Design System — ThemeData Builder
///
/// Usage:
///   MaterialApp(
///     theme: ZintraTheme.light(),
///     darkTheme: ZintraTheme.dark(),
///   )
///
///

/// Maps Zintra text styles to Flutter's [TextTheme].
/// Apply via: ThemeData(textTheme: ZintraTextTheme.build())
class ZintraTextTheme {
  static TextTheme build() => TextTheme(
    // Display
    displayLarge: ZintraTypography.displayBold,
    displayMedium: ZintraTypography.displaySemiBold,
    displaySmall: ZintraTypography.displayMedium,
    // Headline → Title/Subtitle
    headlineLarge: ZintraTypography.titleBold,
    headlineMedium: ZintraTypography.subtitleBold,
    headlineSmall: ZintraTypography.h1Bold,
    // Title → H2-H4
    titleLarge: ZintraTypography.h2Bold,
    titleMedium: ZintraTypography.h3SemiBold,
    titleSmall: ZintraTypography.h4SemiBold,
    // Body
    bodyLarge: ZintraTypography.bodyLargeMedium,
    bodyMedium: ZintraTypography.bodyMediumMedium,
    bodySmall: ZintraTypography.bodySmallMedium,
    // Label
    labelLarge: ZintraTypography.labelUpperSemiBold,
    labelMedium: ZintraTypography.captionUpperSemiBold,
    labelSmall: ZintraTypography.bodySmallRegular,
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
      textTheme: ZintraTextTheme.build(),

      // ── Scaffold ──────────────────────────────────────────────
      scaffoldBackgroundColor: isLight
          ? ZintraColors.background
          : ZintraColorPrimitives.neutral900,

      // ── AppBar ────────────────────────────────────────────────
      appBarTheme: isLight
          ? ZintraAppBarScheme.light()
          : ZintraAppBarScheme.dark(),

      // -- Button ------------------------------------------------
      elevatedButtonTheme: isLight
          ? ZintraButtonScheme.lightElevatedButton()
          : ZintraButtonScheme.darkElevatedButton(),

      outlinedButtonTheme: isLight
          ? ZintraButtonScheme.lightOutlinedButtonTheme()
          : ZintraButtonScheme.darkOutlinedButtonTheme(),

      textButtonTheme: isLight
          ? ZintraButtonScheme.lightTextButtonTheme()
          : ZintraButtonScheme.darkTextButtonTheme(),

      iconButtonTheme: isLight
          ? ZintraButtonScheme.lightIconButton()
          : ZintraButtonScheme.darkIconButton(),

      // ── InputDecoration ───────────────────────────────────────
      inputDecorationTheme: isLight
          ? ZintraInputScheme.light()
          : ZintraInputScheme.dark(),

      // ── Card ──────────────────────────────────────────────────
      cardTheme: isLight ? ZintraCardScheme.light() : ZintraCardScheme.dark(),

      // ── Chip ──────────────────────────────────────────────────
      chipTheme: isLight
          ? ZintraChipScheme.light(cs)
          : ZintraChipScheme.dark(cs),

      // ── Dialog ────────────────────────────────────────────────
      dialogTheme: isLight
          ? ZintraDialogScheme.light()
          : ZintraDialogScheme.dark(),

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
        contentTextStyle: ZintraTypography.bodyMediumMedium.copyWith(
          color: ZintraColorPrimitives.neutral50,
        ),
        shape: const RoundedRectangleBorder(borderRadius: ZintraRadius.md),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Tooltip ───────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ZintraColorPrimitives.neutral800.withValues(alpha: 0.9),
          borderRadius: ZintraRadius.sm,
        ),
        textStyle: ZintraTypography.bodySmallMedium.copyWith(
          color: ZintraColorPrimitives.neutral50,
        ),
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
        valueIndicatorTextStyle: ZintraTypography.bodySmallSemiBold.copyWith(
          color: cs.onPrimary,
        ),
      ),

      // ── TabBar ────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: cs.primary,
        unselectedLabelColor: ZintraColors.textMuted,
        indicatorColor: cs.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: ZintraTypography.bodyMediumSemiBold,
        unselectedLabelStyle: ZintraTypography.bodyMediumRegular,
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
        titleTextStyle: ZintraTypography.bodyLargeMedium,
        subtitleTextStyle: ZintraTypography.bodyMediumRegular.copyWith(
          color: ZintraColors.textSubtle,
        ),
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
