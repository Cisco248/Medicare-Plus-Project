/// ZINTRA BUTTON COMPONENTS
/// Source: Figma Section 7.1 — Buttons
library;

import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

/// Zintra Primary Button
class ZintraButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ZintraButtonSize size;
  final ZintraButtonVariant variant;

  const ZintraButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.fullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ZintraButtonSize.medium,
    this.variant = ZintraButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null && !loading;

    final (bg, fg, border) = switch (variant) {
      ZintraButtonVariant.primary => (
        cs.primary,
        cs.onPrimary,
        Colors.transparent,
      ),
      ZintraButtonVariant.secondary => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
        Colors.transparent,
      ),
      ZintraButtonVariant.outline => (
        Colors.transparent,
        cs.primary,
        cs.primary,
      ),
      ZintraButtonVariant.ghost => (
        Colors.transparent,
        cs.primary,
        Colors.transparent,
      ),
      ZintraButtonVariant.danger => (
        ZintraColors.errorDefault,
        ZintraColorPrimitives.white,
        Colors.transparent,
      ),
    };

    final (h, v, textStyle) = switch (size) {
      ZintraButtonSize.small => (
        ZintraSpacing.sm,
        ZintraSpacing.xxs,
        ZintraTypography.bodySmallSemiBold,
      ),
      ZintraButtonSize.medium => (
        ZintraSpacing.lg,
        ZintraSpacing.sm,
        ZintraTypography.bodyLargeSemiBold,
      ),
      ZintraButtonSize.large => (
        ZintraSpacing.xl,
        ZintraSpacing.md,
        ZintraTypography.h5SemiBold,
      ),
    };

    Widget content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          ),
          const SizedBox(width: ZintraSpacing.xs),
        ] else if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            size: 18,
            color: isDisabled ? ZintraColors.textDisabled : fg,
          ),
          const SizedBox(width: ZintraSpacing.xs),
        ],
        Text(label),
        if (!loading && trailingIcon != null) ...[
          const SizedBox(width: ZintraSpacing.xs),
          Icon(
            trailingIcon,
            size: 18,
            color: isDisabled ? ZintraColors.textDisabled : fg,
          ),
        ],
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: (loading || isDisabled) ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isDisabled ? ZintraColors.surfaceMuted : bg,
          foregroundColor: isDisabled ? ZintraColors.textDisabled : fg,
          textStyle: textStyle,
          padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
          shape: RoundedRectangleBorder(
            borderRadius: ZintraRadius.md,
            side: border == Colors.transparent
                ? BorderSide.none
                : BorderSide(
                    color: isDisabled ? ZintraColors.borderDefault : border,
                  ),
          ),
        ),
        child: content,
      ),
    );
  }
}

enum ZintraButtonSize { small, medium, large }

enum ZintraButtonVariant { primary, secondary, outline, ghost, danger }
