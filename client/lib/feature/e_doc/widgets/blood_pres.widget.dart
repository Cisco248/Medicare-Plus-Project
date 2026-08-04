import 'package:client/core/utils/notification.utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            TextFormField(
              controller: param_1,
              decoration: InputDecoration(labelText: 'BP Param one'),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: param_2,
              decoration: InputDecoration(labelText: 'Param Two'),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: param_3,
              decoration: InputDecoration(labelText: 'Param Three'),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: param_4,
              decoration: InputDecoration(labelText: 'Param Four'),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => sendData(context),
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(
                  Size(MediaQuery.sizeOf(context).width, 40),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              label: Text(
                'Submit',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              icon: FaIcon(
                FontAwesomeIcons.arrowRight,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
