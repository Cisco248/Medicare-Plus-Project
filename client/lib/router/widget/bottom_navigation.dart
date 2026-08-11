import 'package:client/router/providers/navigation.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends ConsumerWidget {
  final ColorScheme colorScheme;
  final int selectedIndex;

  const BottomNavigation({
    super.key,
    required this.colorScheme,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onError,
      elevation: 0,
      onTap: (index) =>
          ref.read(navigationProvider.notifier).changeIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.houseChimneyMedical,
            color: colorScheme.primary,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.receipt, color: colorScheme.primary),
          label: 'Receipts',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.plus, color: colorScheme.primary),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.briefcaseMedical,
            color: colorScheme.primary,
          ),
          label: 'Pharmacy',
        ),
      ],
    );
  }
}
