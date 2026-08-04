// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA DIVIDER
// ══════════════════════════════════════════════════════════════════════════════

import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:flutter/material.dart';

class ZintraDivider extends StatelessWidget {
  final String? label;
  final double thickness;
  final EdgeInsetsGeometry? margin;

  const ZintraDivider({super.key, this.label, this.thickness = 1, this.margin});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ZintraSpacing.sm),
            child: Text(
              label!,
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(100),
                fontSize: 12,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: thickness,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }
}
