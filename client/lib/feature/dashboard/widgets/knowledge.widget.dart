import 'package:client/core/themes/primitives/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppWidget extends ConsumerWidget {
  final String text;

  const AppWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onSurface.withAlpha(10),
            colorScheme.surfaceContainer.withAlpha(100),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        backgroundBlendMode: BlendMode.srcOver,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: ZintraColorPrimitives.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "For the patient's health",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: 8),
              FaIcon(
                FontAwesomeIcons.circleQuestion,
                size: 14,
                color: colorScheme.primary,
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
