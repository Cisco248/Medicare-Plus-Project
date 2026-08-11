import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

extension ZintraDividerScheme on DividerThemeData {
  static DividerThemeData light() => DividerThemeData(
    color: ZintraColors.borderDefault,
    thickness: ZintraSpacing.borderThin,
    space: ZintraSpacing.md,
  );

  static DividerThemeData dark() => DividerThemeData(
    color: ZintraColors.overlayLight,
    thickness: ZintraSpacing.borderThin,
    space: ZintraSpacing.md,
  );
}
