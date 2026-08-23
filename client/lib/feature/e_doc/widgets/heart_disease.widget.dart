import 'package:client/core/utils/body_metrics.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/core/widgets/button.widget.dart';
import 'package:client/core/widgets/textfield.widget.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/heart_disease.model.dart';
import 'package:client/feature/e_doc/notifiers/doc.state.dart';
import 'package:client/feature/e_doc/utils/clinical_parameter_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeartDiseaseFormWidget extends ConsumerStatefulWidget {
  const HeartDiseaseFormWidget({super.key});

  @override
  ConsumerState<HeartDiseaseFormWidget> createState() =>
      _HeartDiseaseFormWidgetState();
}

class _HeartDiseaseFormWidgetState
    extends ConsumerState<HeartDiseaseFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _bmi = TextEditingController();
  final _physicalHealth = TextEditingController();
  String? _ageCategory;
  String? _sex;
  String? _genHealth;
  String? _diabetic;
  bool _smoking = false;
  bool _stroke = false;
  bool _diffWalking = false;
  HeartDiseasePrefill _prefill = const HeartDiseasePrefill();

  void _apply(HeartDiseasePrefill prefill) {
    _prefill = prefill;
    _ageCategory ??= prefill.ageCategory;
    _sex ??= prefill.sex;
    if (_bmi.text.isEmpty && prefill.bmi != null) {
      _bmi.text = BodyMetrics.formatBmi(prefill.bmi)!;
    }
    _diabetic ??= prefill.diabetic;
    if (prefill.smoking == 'Yes') _smoking = true;
    if (prefill.stroke == 'Yes') _stroke = true;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bmi.dispose();
    _physicalHealth.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      NotificationUtils.error(context, 'Please complete the required fields.');
      return;
    }
    if (_ageCategory == null ||
        _sex == null ||
        _genHealth == null ||
        _diabetic == null) {
      NotificationUtils.error(context, 'Please complete the required fields.');
      return;
    }
    final bmi = double.tryParse(_bmi.text.trim());
    final physicalHealth = double.tryParse(_physicalHealth.text.trim());
    if (bmi == null || physicalHealth == null) {
      NotificationUtils.error(context, 'Please enter valid numeric values.');
      return;
    }

    await ref
        .read(docStateProvider.notifier)
        .submitHeartDisease(
          HeartDiseaseModel(
            ageCategory: _ageCategory!,
            sex: _sex!,
            bmi: bmi,
            genHealth: _genHealth!,
            diabetic: _diabetic!,
            smoking: _smoking ? 'Yes' : 'No',
            stroke: _stroke ? 'Yes' : 'No',
            diffWalking: _diffWalking ? 'Yes' : 'No',
            physicalHealth: physicalHealth,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(clinicalSnapshotProvider);
    ref.listen(clinicalSnapshotProvider, (_, next) {
      _apply(ClinicalParameterMapper(next).heartDisease());
    });
    if (_bmi.text.isEmpty && snapshot.bmi.isAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _apply(ClinicalParameterMapper(snapshot).heartDisease());
      });
    }

    final assessment = ref.watch(docStateProvider);
    final submitting =
        assessment.phase == DocPhase.loading &&
        assessment.model == DocModel.heartDisease;

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
            DropdownButtonFormField<String>(
              key: ValueKey('hd-age-$_ageCategory'),
              initialValue: _ageCategory,
              decoration: InputDecoration(
                labelText: 'Age category',
                helperText: snapshot.sourceLabel(_prefill.ageSource),
              ),
              items: [
                for (final item in heartDiseaseAgeCategories)
                  DropdownMenuItem(value: item, child: Text(item)),
              ],
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                if (value != null) setState(() => _ageCategory = value);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey('hd-sex-$_sex'),
              initialValue: _sex,
              decoration: InputDecoration(
                labelText: 'Sex',
                helperText: snapshot.sourceLabel(_prefill.sexSource),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
              ],
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                if (value != null) setState(() => _sex = value);
              },
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'BMI',
              hint: 'Calculated from height and weight when available',
              helperText: snapshot.sourceLabel(_prefill.bmiSource),
              controller: _bmi,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredNumber,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey('hd-gen-$_genHealth'),
              initialValue: _genHealth,
              decoration: const InputDecoration(labelText: 'General health'),
              items: [
                for (final item in heartDiseaseGenHealth)
                  DropdownMenuItem(value: item, child: Text(item)),
              ],
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                if (value != null) setState(() => _genHealth = value);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey('hd-diabetic-$_diabetic'),
              initialValue: _diabetic,
              decoration: const InputDecoration(labelText: 'Diabetes status'),
              items: [
                for (final item in heartDiseaseDiabetic)
                  DropdownMenuItem(value: item, child: Text(item)),
              ],
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                if (value != null) setState(() => _diabetic = value);
              },
            ),
            const SizedBox(height: 8),
            ZintraTextField(
              label: 'Poor physical-health days (last 30 days)',
              hint: '0 to 30 — enter the number of days',
              controller: _physicalHealth,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _requiredPhysicalDays,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _smoking,
              onChanged: (value) => setState(() => _smoking = value ?? false),
              title: const Text(
                'Smoking',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _stroke,
              onChanged: (value) => setState(() => _stroke = value ?? false),
              title: const Text(
                'Previous stroke',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _diffWalking,
              onChanged: (value) =>
                  setState(() => _diffWalking = value ?? false),
              title: const Text(
                'Difficulty walking',
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

String? _requiredPhysicalDays(String? value) {
  if (value == null || value.trim().isEmpty) return 'This field is required.';
  final parsed = num.tryParse(value.trim());
  if (parsed == null) return 'Enter a valid number.';
  if (parsed < 0 || parsed > 30) return 'Enter a value between 0 and 30.';
  return null;
}
