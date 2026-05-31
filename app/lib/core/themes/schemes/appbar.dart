import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

extension ZintraAppBarScheme on AppBarTheme {
  static AppBarTheme light() => AppBarTheme(
    backgroundColor: ZintraColors.surfaceDefault,
    foregroundColor: ZintraColors.textDefault,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: ZintraTypography.h5SemiBold.copyWith(
      color: ZintraColors.textDefault,
    ),
  );

  static AppBarTheme dark() => AppBarTheme(
    backgroundColor: ZintraColorPrimitives.neutral900,
    foregroundColor: ZintraColorPrimitives.neutral50,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: ZintraTypography.h5SemiBold.copyWith(
      color: ZintraColorPrimitives.neutral50,
    ),
  );
}
