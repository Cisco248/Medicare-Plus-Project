import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

extension ZintraNavigationScheme on NavigationBarThemeData {
  static BottomNavigationBarThemeData lightBottomNavigation(ColorScheme cs) =>
      BottomNavigationBarThemeData(
        backgroundColor: ZintraColors.surfaceDefault,
        selectedItemColor: cs.primary,
        unselectedItemColor: ZintraColors.iconSubtle,
        selectedLabelStyle: ZintraTypography.bodySmallSemiBold(cs),
        unselectedLabelStyle: ZintraTypography.bodySmallRegular(cs),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static BottomNavigationBarThemeData darkBottomNavigation(ColorScheme cs) =>
      BottomNavigationBarThemeData(
        backgroundColor: ZintraColorPrimitives.neutral900,
        selectedItemColor: cs.primary,
        unselectedItemColor: ZintraColors.iconSubtle,
        selectedLabelStyle: ZintraTypography.bodySmallSemiBold(cs),
        unselectedLabelStyle: ZintraTypography.bodySmallRegular(cs),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static NavigationBarThemeData lightNavigationBar(ColorScheme cs) =>
      NavigationBarThemeData(
        backgroundColor: ZintraColors.surfaceDefault,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ZintraTypography.bodySmallSemiBold(cs);
          }
          return ZintraTypography.bodySmallRegular(cs);
        }),
      );

  static NavigationBarThemeData darkNavigationBar(ColorScheme cs) =>
      NavigationBarThemeData(
        backgroundColor: ZintraColorPrimitives.neutral900,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ZintraTypography.bodySmallSemiBold(cs);
          }
          return ZintraTypography.bodySmallRegular(cs);
        }),
      );
}
