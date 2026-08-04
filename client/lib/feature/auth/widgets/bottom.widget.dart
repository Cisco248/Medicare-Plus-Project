import 'package:client/core/widgets/divider.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginBottomSection extends StatelessWidget {
  const LoginBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ZintraDivider(label: 'Sign using Accounts'),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text(
                "Sign with Google",
                style: TextStyle(
                  color: theme.onSurface,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                fixedSize: WidgetStatePropertyAll(Size(width / 2 - 36, 12)),
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 1),
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(color: theme.onSurface, width: 1),
                ),
                iconColor: WidgetStatePropertyAll(theme.onSurface),
                iconSize: WidgetStatePropertyAll(12),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.apple),
              label: Text(
                "Sign with Apple ID",
                style: TextStyle(
                  color: theme.onSurface,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                fixedSize: WidgetStatePropertyAll(Size(width / 2 - 36, 12)),
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 1),
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(color: theme.onSurface, width: 1),
                ),
                iconColor: WidgetStatePropertyAll(theme.onSurface),
                iconSize: WidgetStatePropertyAll(12),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
