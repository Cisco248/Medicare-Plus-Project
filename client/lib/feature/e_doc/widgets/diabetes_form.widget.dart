import 'package:client/core/utils/notification.utils.dart';
import 'package:client/feature/e_doc/constant/button.style.dart';
import 'package:flutter/material.dart';

class DiabetesFormWidget extends StatelessWidget {
  DiabetesFormWidget({super.key});

  late final _formKey = GlobalKey<FormState>();
  final TextEditingController param_1 = TextEditingController();
  final TextEditingController param_2 = TextEditingController();
  final TextEditingController param_3 = TextEditingController();
  final TextEditingController param_4 = TextEditingController();

  void sendData(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      NotificationUtils.error(context, 'Fields are Empty!');
    }
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
                controller: param_1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Param one',
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
                controller: param_2,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Param Two',
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
                controller: param_3,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Param Three',
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
                controller: param_4,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelText: 'Param Four',
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
