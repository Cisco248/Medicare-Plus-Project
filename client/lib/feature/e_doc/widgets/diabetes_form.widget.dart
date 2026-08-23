import 'package:client/core/utils/body_metrics.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/button.widget.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/notifiers/doc.state.dart';
import 'package:client/feature/e_doc/utils/clinical_parameter_mapper.dart';
import 'package:client/feature/e_doc/utils/diabetes_payload.dart';
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
  String? _gender;
  bool _familyDiabetes = false;
  bool _hypertensive = false;
  DiabetesPrefill _prefill = const DiabetesPrefill();

  @override
  void dispose() {
    _age.dispose();
    _pulse.dispose();
    _bp.dispose();
    _glucose.dispose();
    _bmi.dispose();
    super.dispose();
  }

  void _apply(DiabetesPrefill prefill) {
    _prefill = prefill;
    if (_age.text.isEmpty && prefill.age != null) {
      _age.text = '${prefill.age}';
    }
    if (_bmi.text.isEmpty && prefill.bmi != null) {
      _bmi.text = BodyMetrics.formatBmi(prefill.bmi)!;
    }
    if (_bp.text.isEmpty && prefill.bpReading != null) {
      _bp.text = prefill.bpReading!;
    }
    if (_glucose.text.isEmpty && prefill.glucose != null) {
      _glucose.text = prefill.glucose!.toStringAsFixed(1);
    }
    if (_pulse.text.isEmpty && prefill.pulseRate != null) {
      _pulse.text = prefill.pulseRate!.toStringAsFixed(0);
    }
    _gender ??= prefill.gender;
    if (prefill.hypertensive != null) {
      _hypertensive = prefill.hypertensive!;
    }
    if (mounted) setState(() {});
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
            gender: _gender!,
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
    final snapshot = ref.watch(clinicalSnapshotProvider);
    ref.listen(clinicalSnapshotProvider, (_, next) {
      _apply(ClinicalParameterMapper(next).diabetes());
    });
    if (_age.text.isEmpty && snapshot.age.isAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _apply(ClinicalParameterMapper(snapshot).diabetes());
      });
    }

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
              hint: 'From your profile if available',
              helperText: snapshot.sourceLabel(_prefill.ageSource),
              controller: _age,
              keyboardType: TextInputType.number,
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey('diabetes-gender-$_gender'),
              initialValue: _gender,
              decoration: InputDecoration(
                labelText: 'Gender',
                helperText: snapshot.sourceLabel(_prefill.genderSource),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _gender = value);
              },
              validator: (value) =>
                  value == null ? 'Please select a gender.' : null,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Pulse rate',
              hint: 'Beats per minute',
              helperText: snapshot.sourceLabel(_prefill.pulseSource),
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
              helperText: snapshot.sourceLabel(_prefill.bpSource),
              controller: _bp,
              validator: _requiredBloodPressure,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Glucose',
              hint: 'mmol/L if known',
              helperText: snapshot.sourceLabel(_prefill.glucoseSource),
              controller: _glucose,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'BMI',
              hint: 'Calculated when height and weight exist',
              helperText: snapshot.sourceLabel(_prefill.bmiSource),
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
              subtitle: _prefill.hypertensive != null
                  ? const Text(
                      'From recorded conditions',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11),
                    )
                  : null,
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

String? _requiredBloodPressure(String? value) {
  if (value == null || value.trim().isEmpty) return 'This field is required.';
  if (parseBloodPressure(value) == null) {
    return 'Enter blood pressure as 120/80.';
  }
  return null;
}
