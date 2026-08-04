import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenerateWidget extends StatelessWidget {
  const GenerateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Generative Answer',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(width: 8),
              Icon(
                FaIcon(FontAwesomeIcons.solidCircleQuestion, size: 16).icon,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'lorem ipsum' * 10,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(190),
              fontStyle: FontStyle.italic,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontVariations: [FontVariation.opticalSize(14)],
            ),
          ),
        ],
      ),
    );
  }
}
