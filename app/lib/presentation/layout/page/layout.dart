import 'package:app/core/themes/primitives/colors.dart';
import 'package:app/core/themes/schemes/color.dart';
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
    final isOpen = ref.watch(chatPopupProvider);
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
      body: Stack(
        children: [
          // MAIN CONTENT
          IndexedStack(
            index: selectedIndex,
            children: const [
              Dashboard(),
              Center(child: Text('Profile')),
              Center(child: Text('Profile')),
              EPharmacy(),
            ],
          ),

          // DARK OVERLAY
          if (isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => ref.read(chatPopupProvider.notifier).state = false,
                child: Container(color: Colors.black54),
              ),
            ),

          // CHAT POPUP
          if (isOpen)
            Center(
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 340,
                  height: 500,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // HEADER
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "AI Assistant",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton.outlined(
                              color: ZintraColorPrimitives.transparent,
                              icon: Icon(
                                Icons.close,
                                color: ZintraColorPrimitives.destructive500,
                              ),
                              iconSize: 24,
                              onPressed: () =>
                                  ref.read(chatPopupProvider.notifier).state =
                                      false,
                            ),
                          ],
                        ),
                      ),

                      Divider(),

                      Expanded(
                        child: ListView(
                          children: [Text("Ask me about health...")],
                        ),
                      ),

                      // INPUT
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Type question...",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.send),
                            iconSize: 24,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // FLOATING BUTTON (UPDATED)
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          ref.read(chatPopupProvider.notifier).state = true;
        },
        child: FaIcon(FontAwesomeIcons.robot),
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
