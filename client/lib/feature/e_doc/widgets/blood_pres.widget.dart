import 'package:client/core/utils/notification.utils.dart';
import 'package:client/feature/e_doc/constant/button.style.dart';
import 'package:flutter/material.dart';

class BloodPressureFormWidget extends StatelessWidget {
  BloodPressureFormWidget({super.key});

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
    final width = MediaQuery.sizeOf(context).width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
                controller: param_1,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Parameter One',
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
            SizedBox(
              width: width,
              height: 40,
              child: TextFormField(
                controller: param_2,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Parameter Two',
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
            SizedBox(
              width: width,
              height: 40,
              child: TextFormField(
                controller: param_3,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Parameter Three',
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
            SizedBox(
              width: width,
              height: 40,
              child: TextFormField(
                controller: param_4,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Parameter Four',
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => sendData(context),
              style: eDocCardButtonStyle(context, width, 40),
              child: Text('Submit', style: eDocCardTextStyle(context)),
            ),
          ],
        ),
      ),
    );
  }
}
