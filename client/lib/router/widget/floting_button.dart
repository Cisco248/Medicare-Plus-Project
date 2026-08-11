import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlotingButton extends ConsumerWidget {
  const FlotingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    onPressed: () {},
    padding: EdgeInsets.all(16),
    icon: FaIcon(
      FontAwesomeIcons.bots,
      size: 28,
      color: Theme.of(context).colorScheme.surface,
    ),
    splashRadius: 32,
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Theme.of(context).colorScheme.primary,
      ),
      shape: WidgetStatePropertyAll(CircleBorder()),
    ),
  );
}
