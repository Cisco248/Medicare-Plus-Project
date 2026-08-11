// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA AVATAR
// ══════════════════════════════════════════════════════════════════════════════

import 'package:client/core/themes/primitives/fonts.dart';
import 'package:flutter/material.dart';

class ZintraAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;

  const ZintraAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? cs.primaryContainer;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: imageUrl == null ? bg : null,
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null && initials != null
          ? Center(
              child: Text(
                initials!.toUpperCase(),
                style: ZintraTypography.bodySmallSemiBold(cs),
              ),
            )
          : null,
    );
  }
}
