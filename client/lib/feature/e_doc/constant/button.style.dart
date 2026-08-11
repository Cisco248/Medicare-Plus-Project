import 'package:flutter/material.dart';

ButtonStyle eDocCardButtonStyle(
  BuildContext context,
  double boxWidth,
  double boxHeight,
) => ButtonStyle(
  fixedSize: WidgetStatePropertyAll(Size(boxWidth, boxHeight)),
  backgroundColor: WidgetStatePropertyAll(
    Theme.of(context).colorScheme.primary,
  ),
  padding: WidgetStatePropertyAll(
    EdgeInsetsGeometry.symmetric(horizontal: 0, vertical: 0),
  ),
);

TextStyle eDocCardTextStyle(BuildContext context) => TextStyle(
  color: Theme.of(context).colorScheme.onPrimary,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
