import 'package:client/core/widgets/button.widget.dart';
import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:client/feature/e_doc/notifiers/assessment.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Blood-pressure / heart-risk form.
///
/// The server defines `HeartScehema` but does not expose a prediction route
/// yet, so this screen explains that instead of posting to an invented URL.
class BloodPressureFormWidget extends ConsumerWidget {
  const BloodPressureFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          Text(
            'Blood pressure prediction is not available yet.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The server does not currently expose a blood-pressure or heart-risk endpoint. Use the Diabetes or Hypertension assessment instead.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(180),
            ),
          ),
          const SizedBox(height: 16),
          ZintraButton(
            label: 'Show status',
            fullWidth: true,
            onPressed: () => ref
                .read(eDocAssessmentProvider.notifier)
                .markUnavailable(EDocPredictionModel.bloodPressure),
          ),
        ],
      ),
    );
  }
}
