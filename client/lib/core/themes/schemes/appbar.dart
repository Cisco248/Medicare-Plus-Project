import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

extension ZintraAppBarScheme on AppBarTheme {
  static AppBarTheme light(ColorScheme cs) => AppBarTheme(
    backgroundColor: ZintraColors.surfaceDefault,
    foregroundColor: ZintraColors.textDefault,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: ZintraTypography.h5SemiBold(cs),
  );

  static AppBarTheme dark(ColorScheme cs) => AppBarTheme(
    backgroundColor: ZintraColorPrimitives.neutral900,
    foregroundColor: ZintraColorPrimitives.neutral50,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: ZintraTypography.h5SemiBold(cs),
  );
}
