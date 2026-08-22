import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/button.widget.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/notifiers/doc.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiabetesFormWidget extends ConsumerStatefulWidget {
  const DiabetesFormWidget({super.key});

  @override
  ConsumerState<DiabetesFormWidget> createState() => _DiabetesFormWidgetState();
}

class _DiabetesFormWidgetState extends ConsumerState<DiabetesFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _age = TextEditingController();
  final _pulse = TextEditingController();
  final _bp = TextEditingController();
  final _glucose = TextEditingController();
  final _bmi = TextEditingController();
  String _gender = 'male';
  bool _familyDiabetes = false;
  bool _hypertensive = false;

  @override
  void dispose() {
    _age.dispose();
    _pulse.dispose();
    _bp.dispose();
    _glucose.dispose();
    _bmi.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      NotificationUtils.error(context, 'Please complete the required fields.');
      return;
    }

    final age = int.tryParse(_age.text.trim());
    final pulse = double.tryParse(_pulse.text.trim());
    final glucose = double.tryParse(_glucose.text.trim());
    final bmi = double.tryParse(_bmi.text.trim());
    if (age == null || pulse == null || glucose == null || bmi == null) {
      NotificationUtils.error(context, 'Please enter valid numeric values.');
      return;
    }

    await ref
        .read(docStateProvider.notifier)
        .submitDiabetes(
          DiabetesModel(
            age: age,
            gender: _gender,
            pulseRate: pulse,
            bpReading: _bp.text.trim(),
            glucose: glucose,
            bmi: bmi,
            familyDiabetes: _familyDiabetes ? 'Yes' : 'No',
            hypertensive: _hypertensive ? 'Yes' : 'No',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final assessment = ref.watch(docStateProvider);
    final submitting =
        assessment.phase == DocPhase.loading &&
        assessment.model == DocModel.diabetes;

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
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _gender = value);
              },
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Pulse rate',
              hint: 'e.g. 78',
              controller: _pulse,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Blood pressure',
              hint: 'e.g. 120/80',
              controller: _bp,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'This field is required.'
                  : null,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Glucose',
              hint: 'e.g. 110',
              controller: _glucose,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'BMI',
              hint: 'e.g. 24.5',
              controller: _bmi,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _familyDiabetes,
              onChanged: (value) =>
                  setState(() => _familyDiabetes = value ?? false),
              title: const Text(
                'Family history of diabetes',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _hypertensive,
              onChanged: (value) =>
                  setState(() => _hypertensive = value ?? false),
              title: const Text(
                'Hypertensive',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
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
