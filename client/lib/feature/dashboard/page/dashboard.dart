import 'package:client/feature/dashboard/widgets/knowledge.widget.dart';
import 'package:client/feature/dashboard/widgets/patient_card.widget.dart';
import 'package:client/feature/dashboard/widgets/remainder_card.widget.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(
        initialScrollOffset: 10,
        keepScrollOffset: true,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          PatientCard(),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: RemainderCard(),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AppWidget(
              'Welcome to MediCare Plus, your trusted healthcare companion designed to make healthcare management simple, secure, and accessible. Patients can manage their medical records, receive medication reminders, communicate with healthcare professionals, monitor health activities, and access essential healthcare services anytime and anywhere. Our platform connects patients and doctors through modern digital solutions, improving clinical care and providing a better healthcare experience.',
            ),
          ),
        ],
      ),
    );
  }
}
