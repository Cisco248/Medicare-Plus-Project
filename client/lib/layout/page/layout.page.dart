import 'package:client/core/widgets/appbar.widget.dart';
import 'package:client/core/widgets/bottom_navigation.widget.dart';
import 'package:client/core/widgets/drawer.widget.dart';
import 'package:client/feature/chat_bot/page/ask.page.dart';
import 'package:client/feature/dashboard/page/dashboard.dart';
import 'package:client/feature/e_doc/page/e_doc.page.dart';
import 'package:client/feature/pharmacy/page/shop.dart';
import 'package:client/feature/reports/page/reports.page.dart';
import 'package:client/layout/notifiers/navigation.notifier.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const AppbarWidget(),
      drawer: const AppDrawer(),
      extendBody: false,
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: const [
            Dashboard(),
            AskPage(),
            EDocPage(),
            EPharmacy(),
            ReportsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(index),
    );
  }
}
