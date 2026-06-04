import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/presentation/dashboard/page/dashboard.dart';
import 'package:app/presentation/layout/provider/provider.dart';
import 'package:app/presentation/pharmacy/page/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppLayout extends ConsumerWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("User Name"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.bell, size: 16, color: cs.primary),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                ZintraColorPrimitives.transparent,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.gear, size: 16, color: cs.primary),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                ZintraColorPrimitives.transparent,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          Dashboard(),
          Center(child: Text('Profile')),
          Center(child: Text('Profile')),
          EPharmacy(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onError,
        elevation: 0,
        onTap: (index) =>
            ref.read(navigationProvider.notifier).changeIndex(index),
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.houseChimneyMedical,
              color: cs.primary,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.receipt, color: cs.primary),
            label: 'Receipts',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.plus, color: cs.primary),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.briefcaseMedical, color: cs.primary),
            label: 'Pharmacy',
          ),
        ],
      ),
    );
  }
}
