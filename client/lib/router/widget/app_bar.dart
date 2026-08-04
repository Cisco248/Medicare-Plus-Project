import 'package:client/core/themes/primitives/colors.dart';
import 'package:client/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ZintraAppBar extends ConsumerWidget {
  const ZintraAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppBar(
    title: Text("Medicare +"),
    automaticallyImplyActions: false,
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        onPressed: () => ref.read(themeProvider.notifier).toggle(),
        icon: FaIcon(
          FontAwesomeIcons.sun,
          color: ZintraColorPrimitives.primary500,
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
