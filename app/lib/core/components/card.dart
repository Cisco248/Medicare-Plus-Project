// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA CARD
// Source: Figma Section 7.4 — Cards
// ══════════════════════════════════════════════════════════════════════════════

import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/primitives/spacing.dart';
import 'package:app/core/themes/tokens/colors.dart';
import 'package:app/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

class ZintraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ZintraCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        backgroundColor ??
        (isDark
            ? ZintraColorPrimitives.neutral800
            : ZintraColors.surfaceDefault);
    final radius = borderRadius ?? ZintraRadius.lg;

    return Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: padding ?? const EdgeInsets.all(ZintraSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: ZintraColors.borderDefault),
            boxShadow: elevated ? ZintraShadowTokens.cardMd : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA SHADOW TOKENS (BoxShadow lists for convenience)
// ══════════════════════════════════════════════════════════════════════════════

abstract class ZintraShadowTokens {
  static const List<BoxShadow> cardSm = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> cardMd = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> cardLg = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> modal = [
    BoxShadow(color: Color(0x33000000), blurRadius: 40, offset: Offset(0, 16)),
  ];
}
