import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityCardWidget extends StatelessWidget {
  final String value;
  final FaIconData icon;
  final Color iconColor;

  const ActivityCardWidget({
    required this.value,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      width: MediaQuery.of(context).size.width,
      height: 128,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onSurface.withAlpha(10),
            colorScheme.surfaceContainer.withAlpha(100),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          FaIcon(icon, size: 32, color: iconColor),
          Text(value == '' ? "No Record Found" : value),
        ],
      ),
    );
  }
}
