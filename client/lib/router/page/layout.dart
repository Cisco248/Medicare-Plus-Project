import 'package:client/router/providers/navigation.notifier.dart';
import 'package:client/router/widget/appbar.dart';
import 'package:client/router/widget/bottom_navigation.dart';
import 'package:client/router/widget/floting_button.dart';
import 'package:client/router/widget/page_stack.dart';
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppTopBar(colorScheme: cs),
      body: SafeArea(child: PageStack(selectedIndex: index)),
      floatingActionButton: const FlotingButton(),
      bottomNavigationBar: BottomNavigation(
        colorScheme: cs,
        selectedIndex: index,
      ),
    );
  }
}
