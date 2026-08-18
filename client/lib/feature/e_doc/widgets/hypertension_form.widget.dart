import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/button.widget.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/notifiers/assessment.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HypertensionFormWidget extends ConsumerStatefulWidget {
  const HypertensionFormWidget({super.key});

  @override
  ConsumerState<HypertensionFormWidget> createState() =>
      _HypertensionFormWidgetState();
}

class _HypertensionFormWidgetState extends ConsumerState<HypertensionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _age = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _hba1c = TextEditingController();
  final _cholesterol = TextEditingController();
  Gender? _gender;
  DiabetesOrdinal _diabetes = DiabetesOrdinal.normal;

  @override
  void dispose() {
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    _hba1c.dispose();
    _cholesterol.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      NotificationUtils.error(context, 'Please complete the required fields.');
      return;
    }
    if (_gender == null) {
      NotificationUtils.error(context, 'Please select a gender.');
      return;
    }

    final age = int.tryParse(_age.text.trim());
    final height = double.tryParse(_height.text.trim());
    final weight = double.tryParse(_weight.text.trim());
    final hba1c = double.tryParse(_hba1c.text.trim());
    final cholesterol = double.tryParse(_cholesterol.text.trim());
    if (age == null ||
        height == null ||
        weight == null ||
        hba1c == null ||
        cholesterol == null) {
      NotificationUtils.error(context, 'Please enter valid numeric values.');
      return;
    }

    await ref.read(eDocAssessmentProvider.notifier).submitHypertension(
      HypertensionModel(
        age: age,
        height: height,
        weight: weight,
        hba1c: hba1c,
        cholesterolMgdl: cholesterol,
        diabetesOrdinal: _diabetes,
        gender: _gender!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assessment = ref.watch(eDocAssessmentProvider);
    final submitting =
        assessment.phase == EDocAssessmentPhase.loading &&
        assessment.model == EDocPredictionModel.hypertension;

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
              label: 'Age',
              hint: 'e.g. 45',
              controller: _age,
              keyboardType: TextInputType.number,
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Height (cm)',
              hint: 'e.g. 170',
              controller: _height,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Weight (kg)',
              hint: 'e.g. 70',
              controller: _weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'HbA1c (%)',
              hint: 'e.g. 5.6',
              controller: _hba1c,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Cholesterol (mg/dL)',
              hint: 'e.g. 180',
              controller: _cholesterol,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<DiabetesOrdinal>(
              initialValue: _diabetes,
              decoration: const InputDecoration(labelText: 'Diabetes status'),
              items: const [
                DropdownMenuItem(
                  value: DiabetesOrdinal.normal,
                  child: Text('Normal'),
                ),
                DropdownMenuItem(
                  value: DiabetesOrdinal.preDiabetic,
                  child: Text('Pre-diabetic'),
                ),
                DropdownMenuItem(
                  value: DiabetesOrdinal.diabetic,
                  child: Text('Diabetic'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _diabetes = value);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Gender>(
              initialValue: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: const [
                DropdownMenuItem(value: Gender.male, child: Text('Male')),
                DropdownMenuItem(value: Gender.female, child: Text('Female')),
                DropdownMenuItem(value: Gender.other, child: Text('Other')),
              ],
              onChanged: (value) => setState(() => _gender = value),
              validator: (value) =>
                  value == null ? 'Please select a gender.' : null,
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
