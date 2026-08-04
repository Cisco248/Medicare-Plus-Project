import 'package:client/core/themes/primitives/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final ColorScheme colorScheme;

  const AppTopBar({super.key, required this.colorScheme});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text("User Name"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: FaIcon(
            FontAwesomeIcons.bell,
            size: 16,
            color: colorScheme.primary,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              ZintraColorPrimitives.transparent,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: FaIcon(
            FontAwesomeIcons.gear,
            size: 16,
            color: colorScheme.primary,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              ZintraColorPrimitives.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
