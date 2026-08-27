import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/button.widget.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/notifiers/doc.state.dart';
import 'package:client/feature/e_doc/utils/clinical_parameter_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HypertensionFormWidget extends ConsumerStatefulWidget {
  const HypertensionFormWidget({super.key});

  @override
  ConsumerState<HypertensionFormWidget> createState() =>
      _HypertensionFormWidgetState();
}

class _HypertensionFormWidgetState
    extends ConsumerState<HypertensionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _hba1c = TextEditingController();
  final _cholesterol = TextEditingController();
  DiabetesOrdinal? _diabetes;

  @override
  void dispose() {
    _hba1c.dispose();
    _cholesterol.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      NotificationUtils.error(context, 'Please complete the required fields.');
      return;
    }
    if (_diabetes!.name.isEmpty) {
      NotificationUtils.error(context, 'Please select diabetes status.');
      return;
    }

    final age = ref.watch(clinicalSnapshotProvider).age;
    final height = ref.watch(clinicalSnapshotProvider).heightCm;
    final weight = ref.watch(clinicalSnapshotProvider).weightKg;
    final hba1c = double.tryParse(_hba1c.text.trim());
    final cholesterol = double.tryParse(_cholesterol.text.trim());
    if (!age.isAvailable ||
        !height.isAvailable ||
        !weight.isAvailable ||
        hba1c == null ||
        cholesterol == null) {
      NotificationUtils.error(context, 'Please enter valid numeric values.');
      return;
    }

    await ref
        .read(docStateProvider.notifier)
        .submitHypertension(
          HypertensionModel(
            age: int.parse(age.value?.toString() ?? '0'),
            height: height.value?.toDouble() ?? 0,
            weight: weight.value?.toDouble() ?? 0,
            hba1c: hba1c,
            cholesterolMgdl: cholesterol,
            diabetesOrdinal: _diabetes!,
            gender:
                ref
                        .watch(clinicalSnapshotProvider)
                        .gender
                        .value
                        ?.toLowerCase() ==
                    'male'
                ? 'male'
                : 'female',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(clinicalSnapshotProvider, (_, next) {
      ClinicalParameterMapper(next).hypertension();
    });

    final assessment = ref.watch(docStateProvider);
    final submitting =
        assessment.phase == DocPhase.loading &&
        assessment.model == DocModel.hypertension;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ZintraTextField(
              label: 'HbA1c (%)',
              hint: 'e.g. 5.6',
              controller: _hba1c,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Cholesterol (mg/dL)',
              hint: 'e.g. 180',
              controller: _cholesterol,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: DropdownButtonFormField<DiabetesOrdinal>(
                key: ValueKey('htn-diabetes-$_diabetes'),
                initialValue: _diabetes,
                decoration: const InputDecoration(
                  label: Text('Diabetes status'),
                  helperText: 'From recorded conditions when available',
                ),
                items: const [
                  DropdownMenuItem(
                    value: DiabetesOrdinal.normal,
                    child: Text(
                      'Normal',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                  ),
                  DropdownMenuItem(
                    value: DiabetesOrdinal.preDiabetic,
                    child: Text(
                      'Pre-diabetic',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                  ),
                  DropdownMenuItem(
                    value: DiabetesOrdinal.diabetic,
                    child: Text(
                      'Diabetic',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                    ),
                  ),
                ],
                validator: (value) => value == null ? 'Required' : null,
                onChanged: (value) {
                  if (value != null) setState(() => _diabetes = value);
                },
              ),
            ),
            const SizedBox(height: 24),
            ZintraButton(
              label: 'Generate assessment',
              loading: submitting,
              fullWidth: true,
              onPressed: submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

String? _requiredNumber(String? value) {
  if (value == null || value.trim().isEmpty) return 'This field is required.';
  if (num.tryParse(value.trim()) == null) return 'Enter a valid number.';
  return null;
}
