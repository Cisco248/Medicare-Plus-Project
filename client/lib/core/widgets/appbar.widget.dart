import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppbarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: theme.surfaceContainer,
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.health_and_safety_rounded, size: 24, color: theme.primary),
            const SizedBox(width: 8),
            Text(
              "MediCare Plus",
              style: TextStyle(
                color: theme.primary,
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      automaticallyImplyActions: false,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
            icon: FaIcon(
              ref.watch(themeProvider).isDark
                  ? FontAwesomeIcons.sun
                  : FontAwesomeIcons.moon,
          
              color: ZintraColorPrimitives.primary500,
            ),
            style: ButtonStyle(
              iconSize: WidgetStatePropertyAll(16),
              backgroundColor: WidgetStatePropertyAll(
                ZintraColorPrimitives.transparent,
              ),
            ),
          ),
        ),
      ],
      clipBehavior: Clip.antiAlias,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
