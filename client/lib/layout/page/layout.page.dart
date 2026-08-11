import 'package:client/core/widgets/appbar.widget.dart';
import 'package:client/core/widgets/bottom_navigation.widget.dart';
import 'package:client/feature/chat_bot/page/ask.page.dart';
import 'package:client/feature/dashboard/page/dashboard.dart';
import 'package:client/feature/e_doc/page/e_doc.page.dart';
import 'package:client/feature/pharmacy/page/shop.dart';
import 'package:client/layout/providers/navigation.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLayout extends ConsumerStatefulWidget {
  const AppLayout({super.key});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navigationProvider);

    return Scaffold(
      appBar: AppbarWidget(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              IndexedStack(
                index: index,
                children: const [
                  Dashboard(),
                  AskPage(),
                  EDocPage(),
                  EPharmacy(),
                ],
              ),
              // if (isPopUpOpen)
              //   Positioned.fill(
              //     child: GestureDetector(
              //       onTap: () => ref.read(popUpProvider.notifier).toggle(),
              //       child: Container(color: Colors.black54),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(index),
    );
  }
}
