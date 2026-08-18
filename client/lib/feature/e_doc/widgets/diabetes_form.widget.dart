import 'package:client/core/network/dio_client.dart';
import 'package:client/core/utils/notification.utils.dart';
import 'package:client/feature/e_doc/constant/button.style.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/repository/diabetes.repository.dart';
import 'package:flutter/material.dart';

class DiabetesFormWidget extends StatefulWidget {
  const DiabetesFormWidget({super.key});

  @override
  State<DiabetesFormWidget> createState() => _DiabetesFormWidgetState();
}

class _DiabetesFormWidgetState extends State<DiabetesFormWidget> {
  late final _formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController bpController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  String selectGender = 'male';
  bool familyDiabetes = false;
  bool hypertensive = false;

  Future<void> sendData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      NotificationUtils.error(context, 'Fields are Empty!');
    }

    final request = DiabetesModel(
      age: int.parse(ageController.text),
      gender: selectGender,
      pulseRate: double.parse(pulseController.text),
      bpReading: bpController.text,
      glucose: double.parse(glucoseController.text),
      bmi: double.parse(bmiController.text),
      familyDiabetes: familyDiabetes ? 'Yes' : 'No',
      hypertensive: hypertensive ? 'Yes' : 'No',
    );

    final diabetesRepository = DiabetesRepository(dio: client(8080));
    await diabetesRepository.predict(request);
  }

  @override
  Widget build(BuildContext context) {
    final boxWidth = MediaQuery.sizeOf(context).width;
    final double boxHeight = 40;

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
              height: boxHeight,
              width: boxWidth,
              child: TextFormField(
                style: TextStyle(fontSize: 12),
                controller: ageController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Age',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: TextFormField(
                style: TextStyle(fontSize: 12),
                controller: pulseController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Pulse Rate',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: TextFormField(
                style: TextStyle(fontSize: 12),
                controller: bpController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Bp Value',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: TextFormField(
                style: TextStyle(fontSize: 12),
                controller: glucoseController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Glucose Value',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: TextFormField(
                style: TextStyle(fontSize: 12),
                controller: bmiController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'BMI Value',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => sendData(context),
              style: eDocCardButtonStyle(context, boxWidth, boxHeight),
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
