// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA STATUS BANNER  (success | warning | error | info)
// ══════════════════════════════════════════════════════════════════════════════


import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

class ZintraStatusBanner extends StatelessWidget {
  final String message;
  final ZintraStatusType type;
  final String? title;
  final VoidCallback? onDismiss;

  const ZintraStatusBanner({
    super.key,
    required this.message,
    this.type = ZintraStatusType.info,
    this.title,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (bg, border, icon, iconColor, textColor) = switch (type) {
      ZintraStatusType.success => (
        ZintraColors.successSubtle,
        ZintraColors.successBorder,
        Icons.check_circle_outline,
        ZintraColors.successDefault,
        ZintraColors.successText,
      ),
      ZintraStatusType.warning => (
        ZintraColors.warningSubtle,
        ZintraColors.warningBorder,
        Icons.warning_amber_outlined,
        ZintraColors.warningDefault,
        ZintraColors.warningText,
      ),
      ZintraStatusType.error => (
        ZintraColors.errorSubtle,
        ZintraColors.errorBorder,
        Icons.error_outline,
        ZintraColors.errorDefault,
        ZintraColors.errorText,
      ),
      ZintraStatusType.info => (
        ZintraColors.brandSubtle,
        ZintraColors.borderBrand,
        Icons.info_outline,
        ZintraColors.brand,
        ZintraColors.textBrand,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(ZintraSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: ZintraRadius.md,
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: ZintraSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: ZintraTypography.bodyMediumSemiBold(colorScheme),
                  ),
                Text(
                  message,
                  style: ZintraTypography.bodyMediumMedium(colorScheme),
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 16, color: textColor),
            ),
        ],
      ),
    );
  }
}

enum ZintraStatusType { success, warning, error, info }
