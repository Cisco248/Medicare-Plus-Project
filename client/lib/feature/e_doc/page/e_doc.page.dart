import 'package:client/feature/e_doc/widgets/form.widget.dart';
import 'package:client/feature/e_doc/widgets/generate.widget.dart';
import 'package:flutter/material.dart';

class EDocPage extends StatelessWidget {
  const EDocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        children: [
          MeditationFormWidget(),
          SizedBox(height: 24),
          GenerateWidget(),
        ],
      ),
    );
  }
}
