import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SidePanel extends ConsumerWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 3 / 4,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              icon: FaIcon(FontAwesomeIcons.sun),
              iconAlignment: IconAlignment.start,
              onPressed: () {},
              style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary,
                ),
                alignment: Alignment.centerLeft,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              label: const Text('Theme Mode'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                iconAlignment: IconAlignment.end,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              child: Text('Sync Cloud'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                iconAlignment: IconAlignment.end,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              child: Text('Personalization'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                iconAlignment: IconAlignment.end,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              child: Text('Application Logs'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                iconAlignment: IconAlignment.end,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              child: Text('Settings'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                iconAlignment: IconAlignment.end,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              child: Text('About Us'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                iconAlignment: IconAlignment.end,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodySmall,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.5,
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 1 / 20,
                  ),
                ),
              ),
              child: Text('Customer Support'),
            ),
          ],
        ),
      ),
    );
  }
}
