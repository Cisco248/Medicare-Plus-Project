/// ZINTRA BUTTON COMPONENTS
/// Source: Figma Section 7.1 — Buttons
library;

import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/fonts.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/colors.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

/// Zintra Primary Button
class ZintraButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final double? width;
  final double? height;
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
    this.width,
    this.height,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ZintraButtonSize.medium,
    this.variant = ZintraButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null && !loading;

    final (bg, fg, border) = switch (variant) {
      ZintraButtonVariant.primary => (
        colorScheme.primary,
        ZintraColorPrimitives.white,
        ZintraColorPrimitives.transparent,
      ),
      ZintraButtonVariant.secondary => (
        ZintraColorPrimitives.warning500,
        ZintraColorPrimitives.black,
        ZintraColorPrimitives.transparent,
      ),
      ZintraButtonVariant.outline => (
        ZintraColorPrimitives.transparent,
        ZintraColorPrimitives.primary500,
        ZintraColorPrimitives.primary500,
      ),
      ZintraButtonVariant.ghost => (
        ZintraColorPrimitives.transparent,
        ZintraColorPrimitives.neutral400,
        ZintraColorPrimitives.transparent,
      ),
      ZintraButtonVariant.danger => (
        ZintraColorPrimitives.destructive500,
        ZintraColorPrimitives.white,
        ZintraColorPrimitives.transparent,
      ),
    };

    final (h, v, textStyle) = switch (size) {
      ZintraButtonSize.small => (
        ZintraSpacing.xs,
        ZintraSpacing.xxs,
        ZintraTypography.bodySmallSemiBold(colorScheme),
      ),
      ZintraButtonSize.medium => (
        ZintraSpacing.sm,
        ZintraSpacing.sm,
        ZintraTypography.bodyLargeSemiBold(colorScheme),
      ),
      ZintraButtonSize.large => (
        ZintraSpacing.md,
        ZintraSpacing.md,
        ZintraTypography.h5SemiBold(colorScheme),
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
            color: isDisabled ? ZintraColors.brandDark : fg,
          ),

          const SizedBox(width: ZintraSpacing.xs),
        ],
        Text(label),
        if (!loading && trailingIcon != null) ...[
          const SizedBox(width: ZintraSpacing.xs),
          Icon(
            trailingIcon,
            size: 18,
            color: isDisabled ? ZintraColors.brandDark : fg,
          ),
        ],
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: (loading || isDisabled) ? null : onPressed,
        style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(
            Size(width ?? double.infinity, height ?? 36),
          ),
          backgroundColor: WidgetStatePropertyAll(
            isDisabled ? ZintraColors.surfaceMuted : bg,
          ),
          foregroundColor: WidgetStatePropertyAll(
            isDisabled ? ZintraColors.textDisabled : fg,
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: h, vertical: v),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: ZintraRadius.md,
              side: border == Colors.transparent
                  ? BorderSide.none
                  : BorderSide(
                      color: isDisabled ? ZintraColors.borderDefault : border,
                      width: 2,
                    ),
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
