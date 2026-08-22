import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/notifiers/doc.state.dart';
import 'package:client/feature/e_doc/notifiers/form.notifier.dart';
// import 'package:client/feature/e_doc/notifiers/form.notifier.dart';
import 'package:client/feature/e_doc/widgets/diabetes_form.widget.dart';
import 'package:client/feature/e_doc/widgets/heart_disease.widget.dart';
import 'package:client/feature/e_doc/widgets/hypertension_form.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EDocAssessmentForm extends ConsumerWidget {
  const EDocAssessmentForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(eDocModelProvider);
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: DropdownButton<DocModel>(
            value: model,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_downward, size: 16),
            style: TextStyle(color: theme.onSurface, fontSize: 14),
            onChanged: (value) {
              if (value != null) {
                ref.read(eDocModelProvider.notifier).select(value);
                ref.read(docStateProvider.notifier).clear();
              }
            },
            items: [
              for (final item in DocModel.values)
                DropdownMenuItem(value: item, child: Text(item.label)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        switch (model) {
          DocModel.diabetes => const DiabetesFormWidget(),
          DocModel.hypertension => const HypertensionFormWidget(),
          DocModel.bloodPressure => const BloodPressureFormWidget(),
        },
      ],
    );
  }
}
