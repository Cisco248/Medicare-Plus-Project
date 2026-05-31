// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA DIVIDER
// ══════════════════════════════════════════════════════════════════════════════

import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

class ZintraDivider extends StatelessWidget {
  final String? label;
  final double thickness;
  final EdgeInsetsGeometry? margin;

  const ZintraDivider({super.key, this.label, this.thickness = 1, this.margin});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Padding(
        padding:
            margin ?? const EdgeInsets.symmetric(vertical: ZintraSpacing.sm),
        child: Divider(
          thickness: thickness,
          color: ZintraColors.borderDefault,
          height: thickness,
        ),
      );
    }
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: ZintraSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: thickness,
              color: ZintraColors.borderDefault,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ZintraSpacing.sm),
            child: Text(
              label!,
              style: ZintraTypography.bodySmallMedium.copyWith(
                color: ZintraColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: thickness,
              color: ZintraColors.borderDefault,
            ),
          ),
        ],
      ),
    );
  }
}
