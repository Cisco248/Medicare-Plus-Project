import 'dart:ui';

import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = borderRadius ?? ZintraRadius.xl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = cs.surface.withValues(alpha: isDark ? 0.42 : 0.72);
    final border = cs.outline.withValues(alpha: isDark ? 0.35 : 0.22);
    final shadow = cs.shadow.withValues(alpha: isDark ? 0.28 : 0.08);

    final content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding ?? const EdgeInsets.all(ZintraSpacing.cardPadding),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: radius,
              border: Border.all(color: border),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: cs.surface.withValues(alpha: 0),
      child: InkWell(onTap: onTap, borderRadius: radius, child: content),
    );
  }
}
