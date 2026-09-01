import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityCardWidget extends ConsumerWidget {
  const ActivityCardWidget({
    required this.value,
    required this.valueName,
    required this.icon,
    required this.callback,
    this.iconColor,
    super.key,
  });

  final String value;
  final String valueName;
  final FaIconData icon;
  final Color? iconColor;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final accent = iconColor ?? cs.primary;

    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(
        ZintraSpacing.md,
        ZintraSpacing.sm,
        4,
        ZintraSpacing.sm,
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: accent),
          const SizedBox(width: ZintraSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: callback,
            visualDensity: VisualDensity.compact,
            tooltip: 'Refresh $valueName',
            icon: FaIcon(
              FontAwesomeIcons.arrowsRotate,
              color: cs.onSurfaceVariant,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
