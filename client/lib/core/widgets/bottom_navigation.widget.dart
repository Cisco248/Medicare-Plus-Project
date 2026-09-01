import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:client/layout/notifiers/navigation.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation(this.selectedIndex, {super.key});

  final int selectedIndex;

  static const _items = <({FaIconData icon, String label})>[
    (icon: FontAwesomeIcons.houseChimneyMedical, label: 'Home'),
    (icon: FontAwesomeIcons.bots, label: 'Ask'),
    (icon: FontAwesomeIcons.userDoctor, label: 'E-Doc'),
    (icon: FontAwesomeIcons.briefcaseMedical, label: 'Pharmacy'),
    (icon: FontAwesomeIcons.fileMedical, label: 'Reports'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ZintraSpacing.pageMargin,
        0,
        ZintraSpacing.pageMargin,
        bottomInset > 0 ? bottomInset : ZintraSpacing.xs,
      ),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            for (var index = 0; index < _items.length; index++)
              Expanded(
                child: _NavItem(
                  icon: _items[index].icon,
                  label: _items[index].label,
                  selected: selectedIndex == index,
                  onTap: () =>
                      ref.read(navigationProvider.notifier).changeIndex(index),
                  colorScheme: cs,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
  });

  final FaIconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final active = colorScheme.primary;
    final inactive = colorScheme.onSurface.withValues(alpha: 0.45);

    return Material(
      color: colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ZintraSpacing.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected ? active.withValues(alpha: 0.12) : null,
            borderRadius: BorderRadius.circular(ZintraSpacing.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 18, color: selected ? active : inactive),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? active : inactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
