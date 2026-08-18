import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:client/feature/e_doc/notifiers/assessment.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenerateWidget extends ConsumerWidget {
  const GenerateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eDocAssessmentProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Assessment result',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 8),
              FaIcon(
                FontAwesomeIcons.solidCircleQuestion,
                size: 14,
                color: colorScheme.onSurface.withAlpha(120),
              ),
            ],
          ),
          const SizedBox(height: 12),
          switch (state.phase) {
            EDocAssessmentPhase.idle => Text(
              'Submit an assessment to generate a personalized explanation.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: colorScheme.onSurface.withAlpha(180),
              ),
            ),
            EDocAssessmentPhase.loading => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
            EDocAssessmentPhase.error => Text(
              state.errorMessage ??
                  'Unable to generate the assessment. Please try again.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: colorScheme.error,
              ),
            ),
            EDocAssessmentPhase.empty => Text(
              state.errorMessage ??
                  'No personalized result is available for this assessment yet.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: colorScheme.onSurface.withAlpha(180),
              ),
            ),
            EDocAssessmentPhase.success => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.model != null)
                  Text(
                    state.model!.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                if (state.prediction != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.prediction!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
                if (state.explanation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.explanation!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      height: 1.4,
                      color: colorScheme.onSurface.withAlpha(200),
                    ),
                  ),
                ],
              ],
            ),
          },
        ],
      ),
    );
  }
}
