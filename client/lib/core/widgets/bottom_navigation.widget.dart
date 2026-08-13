import 'package:client/layout/providers/navigation.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends ConsumerWidget {
  final int selectedIndex;

  const BottomNavigation(this.selectedIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navBarStatus = ref.watch(navigationProvider);
    return BottomNavigationBar(
      // Required with 5+ items; the default "shifting" type hides labels.
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.withAlpha(50),
      elevation: 0,
      onTap: (index) =>
          ref.read(navigationProvider.notifier).changeIndex(index),
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
      ),
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.houseChimneyMedical,
            color: navBarStatus == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withAlpha(50),
            size: 20,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.bots,
            color: navBarStatus == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withAlpha(50),
            size: 20,
          ),
          label: 'Ask',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.userDoctor,
            color: navBarStatus == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withAlpha(50),
            size: 20,
          ),
          label: 'E-Doc',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.briefcaseMedical,
            color: navBarStatus == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withAlpha(50),
            size: 20,
          ),
          label: 'Pharmacy',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.fileMedical,
            color: navBarStatus == 4
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withAlpha(50),
            size: 20,
          ),
          label: 'Reports',
        ),
      ],
    );
  }
}
