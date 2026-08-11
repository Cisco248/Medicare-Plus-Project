// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA CARD
// Source: Figma Section 7.4 — Cards
// ══════════════════════════════════════════════════════════════════════════════


import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/spacing.dart';
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
    final cs = Theme.of(context).colorScheme;
    final radius = borderRadius ?? ZintraRadius.lg;

    return Material(
      color: backgroundColor ?? cs.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          alignment: AlignmentGeometry.center,
          transformAlignment: AlignmentGeometry.center,
          padding: padding ?? const EdgeInsets.all(ZintraSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: cs.surface),
            boxShadow: elevated ? ZintraShadowTokens.cardSm : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

abstract class ZintraShadowTokens {
  static const List<BoxShadow> cardSm = [
    BoxShadow(
      color: ZintraColorPrimitives.neutral100,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
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
