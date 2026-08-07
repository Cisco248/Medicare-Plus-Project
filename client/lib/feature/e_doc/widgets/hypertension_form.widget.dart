import 'package:client/core/utils/notification.utils.dart';
import 'package:client/feature/e_doc/constant/button.style.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/viewmodel/e_doc.viewmodel.dart';
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
  late final _formKey = GlobalKey<FormState>();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _cholesterol = TextEditingController();
  final TextEditingController _diabetesOrdinal = TextEditingController();

  bool isChecked = false;
  List<String> dropDownList = ["Male", "Female"];
  String? selectGender;

  @override
  Widget build(BuildContext context) {
    Future<void> sendData(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        NotificationUtils.error(context, 'Fields are Empty!');
      }

      final userData = HypertensionModel(
        age: int.parse(_age.text),
        weight: double.parse(_weight.text),
        cholesterolUnit: double.parse(_cholesterol.text),
        diabetesOrdinal: DiabetesOrdinal.normal,
        gender: Gender.male,
      );
      ref.watch(eDocViewModelProvider.notifier).sendData(userData);
    }

    final width = MediaQuery.sizeOf(context).width;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: 40,
              child: TextFormField(
                controller: _age,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                  hintText: 'E.g: 30',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 40,
              width: width,
              child: TextFormField(
                controller: _weight,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Weight',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                  hintText: 'E.g: 30.6',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 40,
              width: width,
              child: TextFormField(
                controller: _cholesterol,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Cholesterol mgdl',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                  hintText: 'E.g: 200 mgdl',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: width,
              height: 40,
              child: TextFormField(
                controller: _diabetesOrdinal,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Diabetes Ordinal',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                  hintText: 'E.g: 0',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.onSurface, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              width: width,
              height: 40,
              child: DropdownButton(
                value: selectGender,
                items: dropDownList
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (String? value) {
                  setState(() => selectGender = value);
                },
                hint: Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
                underline: Container(height: 0),
                icon: Icon(null),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => sendData(context),
              style: eDocCardButtonStyle(context, width, 40),
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: eDocCardTextStyle(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
