import 'package:client/feature/e_doc/notifiers/form.notifier.dart';
import 'package:client/feature/e_doc/widgets/heart_disease.widget.dart';
import 'package:client/feature/e_doc/widgets/diabetes_form.widget.dart';
import 'package:client/feature/e_doc/widgets/hypertension_form.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeditationFormWidget extends ConsumerStatefulWidget {
  const MeditationFormWidget({super.key});

  @override
  ConsumerState<MeditationFormWidget> createState() =>
      _MeditationFormWidgetState();
}

class _MeditationFormWidgetState extends ConsumerState<MeditationFormWidget> {
  final List<String> list = <String>[
    'Diabetes',
    'Hypertension',
    'Blood Pressure',
  ];
  late String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(formStateProvider);
    ColorScheme theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: DropdownButton(
            menuWidth: MediaQuery.of(context).size.width,
            value: formState,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 16,
            elevation: 16,
            style: TextStyle(color: theme.onSurface),
            onChanged: (String? value) {
              setState(() => dropdownValue = value!);
              ref.read(formStateProvider.notifier).changeStatus(value!);
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ),

        SizedBox(height: 16),
        if (formState == 'Diabetes') DiabetesFormWidget(),
        if (formState == 'Hypertension') HypertensionFormWidget(),
        if (formState == 'Blood Pressure') BloodPressureFormWidget(),
      ],
    );
  }
}
