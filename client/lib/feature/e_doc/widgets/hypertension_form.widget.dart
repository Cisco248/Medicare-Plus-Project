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
  final _age = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _hba1c = TextEditingController();
  final _cholesterol = TextEditingController();
  Gender? _gender;
  DiabetesOrdinal? _diabetes;
  HypertensionPrefill _prefill = const HypertensionPrefill();

  void _apply(HypertensionPrefill prefill) {
    _prefill = prefill;
    if (_age.text.isEmpty && prefill.age != null) {
      _age.text = '${prefill.age}';
    }
    if (_height.text.isEmpty && prefill.heightCm != null) {
      _height.text = prefill.heightCm!.toStringAsFixed(1);
    }
    if (_weight.text.isEmpty && prefill.weightKg != null) {
      _weight.text = prefill.weightKg!.toStringAsFixed(1);
    }
    _gender ??= prefill.gender;
    if (prefill.diabetes != null) {
      _diabetes = prefill.diabetes!;
    }
    if (mounted) setState(() {});
  }

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
    if (_gender == null || _diabetes == null) {
      NotificationUtils.error(
        context,
        'Please select gender and diabetes status.',
      );
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

    await ref
        .read(docStateProvider.notifier)
        .submitHypertension(
          HypertensionModel(
            age: age,
            height: height,
            weight: weight,
            hba1c: hba1c,
            cholesterolMgdl: cholesterol,
            diabetesOrdinal: _diabetes!,
            gender: _gender!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(clinicalSnapshotProvider);
    ref.listen(clinicalSnapshotProvider, (_, next) {
      _apply(ClinicalParameterMapper(next).hypertension());
    });
    if ((_age.text.isEmpty && snapshot.age.isAvailable) ||
        (_height.text.isEmpty && snapshot.heightCm.isAvailable) ||
        (_weight.text.isEmpty && snapshot.weightKg.isAvailable)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _apply(ClinicalParameterMapper(snapshot).hypertension());
      });
    }

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
              label: 'Age',
              hint: 'From your profile if available',
              helperText: snapshot.sourceLabel(_prefill.ageSource),
              controller: _age,
              keyboardType: TextInputType.number,
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Height (cm)',
              hint: 'From profile or Health Connect',
              helperText: snapshot.sourceLabel(_prefill.heightSource),
              controller: _height,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Weight (kg)',
              hint: 'From profile or Health Connect',
              helperText: snapshot.sourceLabel(_prefill.weightSource),
              controller: _weight,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
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
            DropdownButtonFormField<DiabetesOrdinal>(
              key: ValueKey('htn-diabetes-$_diabetes'),
              initialValue: _diabetes,
              decoration: const InputDecoration(
                labelText: 'Diabetes status',
                helperText: 'From recorded conditions when available',
              ),
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
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                if (value != null) setState(() => _diabetes = value);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Gender>(
              key: ValueKey('htn-gender-$_gender'),
              initialValue: _gender,
              decoration: InputDecoration(
                labelText: 'Gender',
                helperText: snapshot.sourceLabel(_prefill.genderSource),
              ),
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
