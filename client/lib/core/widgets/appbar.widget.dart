import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/theme_provider.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppbarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final name = ref.watch(authenticationProvider).value?.data?.name.trim();
    final firstName = _firstName(name);
    final greeting = _greeting(DateTime.now());

    return AppBar(
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      backgroundColor: cs.surface.withValues(alpha: 0),
      surfaceTintColor: cs.surface.withValues(alpha: 0),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      toolbarHeight: kToolbarHeight + 8,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(
          ZintraSpacing.pageMargin,
          0,
          ZintraSpacing.pageMargin,
          0,
        ),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Menu',
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: FaIcon(
                  FontAwesomeIcons.bars,
                  size: 16,
                  color: cs.primary,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName.isEmpty ? greeting : '$greeting, $firstName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      'MediCare Plus',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Toggle theme',
                onPressed: () => ref.read(themeProvider.notifier).toggle(),
                icon: FaIcon(
                  ref.watch(themeProvider).isDark
                      ? FontAwesomeIcons.sun
                      : FontAwesomeIcons.moon,
                  size: 16,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _firstName(String? name) {
    if (name == null || name.isEmpty) return '';
    return name.split(RegExp(r'\s+')).first;
  }

  String _greeting(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
