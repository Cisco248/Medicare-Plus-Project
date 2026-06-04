import 'package:app/core/components/avatar.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/divider.dart';
import 'package:app/core/themes/primitives/fonts.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          PatientCard(cs: cs),
          RemainderCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: DoctorRecomendation(cs: cs),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final ColorScheme cs;
  const PatientCard({super.key, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cs.primaryFixedDim,
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ZintraAvatar(size: 128, initials: 'PN'),
          ZintraCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Patient Name', style: ZintraTypography.bodyLargeBold),
                Text('Age: 45'),
                Text('BP: 120/80 mmHg'),
                Text('HR: 72 bpm'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RemainderCard extends StatelessWidget {
  const RemainderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ZintraCard(
      child: Column(
        children: [
          Text('Next Appointment', style: ZintraTypography.bodyLargeBold),
          Text('Dr. Smith - Cardiology'),
          Text('Date: 2024-07-15'),
          Text('Time: 10:00 AM'),
        ],
      ),
    );
  }
}

class DoctorRecomendation extends StatelessWidget {
  final ColorScheme cs;
  const DoctorRecomendation({super.key, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ZintraCard(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          backgroundColor: cs.primary,
          elevated: true,
          child: Text(
            "Doctor Recomendations",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ZintraDivider(),
        ZintraCard(
          elevated: true,
          backgroundColor: cs.secondaryContainer,
          child: Column(
            children: [
              Text(
                'Warm-Up (5 Minutes)',
                style: ZintraTypography.bodyLargeSemiBold,
              ),
              SizedBox.square(dimension: 12),
              ListView(
                shrinkWrap: true,
                children: [
                  Text('Jumping Jacks - 1 minute'),
                  Text('Arm Circles - 1 minute'),
                  Text('Shoulder rolls: 30 seconds'),
                  Text('High Knees - 1 minute'),
                  Text('Gentle leg swings: 30 seconds per leg'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ZintraCard(
          elevated: true,
          backgroundColor: cs.secondaryContainer,
          child: Column(
            children: [
              Text(
                'Cardio (20–30 Minutes)',
                style: ZintraTypography.bodyLargeSemiBold,
              ),
              SizedBox.square(dimension: 12),
              ListView(
                shrinkWrap: true,
                children: [
                  Text('Brisk walking'),
                  Text('Cycling'),
                  Text('Swimming'),
                  Text('Elliptical trainer'),
                  Text('Dancing'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
