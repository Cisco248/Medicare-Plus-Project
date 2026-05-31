/// ZINTRA BADGE / CHIP
///
library;

import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

class ZintraBadge extends StatelessWidget {
  final String label;
  final ZintraBadgeVariant variant;
  final bool dot;

  const ZintraBadge({
    super.key,
    required this.label,
    this.variant = ZintraBadgeVariant.primary,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      ZintraBadgeVariant.primary => (
        ZintraColors.brandSubtle,
        ZintraColors.textBrand,
      ),
      ZintraBadgeVariant.success => (
        ZintraColors.successSubtle,
        ZintraColors.successText,
      ),
      ZintraBadgeVariant.warning => (
        ZintraColors.warningSubtle,
        ZintraColors.warningText,
      ),
      ZintraBadgeVariant.danger => (
        ZintraColors.errorSubtle,
        ZintraColors.errorText,
      ),
      ZintraBadgeVariant.neutral => (
        ZintraColors.surfaceMuted,
        ZintraColors.textSubtle,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ZintraSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: ZintraRadius.full),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: ZintraSpacing.xxs),
          ],
          Text(
            label,
            style: ZintraTypography.bodySmallSemiBold.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

enum ZintraBadgeVariant { primary, success, warning, danger, neutral }
