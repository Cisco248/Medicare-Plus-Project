import 'package:client/feature/dashboard/notifiers/activity.notifier.dart';
import 'package:client/feature/dashboard/widgets/activity.widget.dart';
import 'package:client/feature/dashboard/widgets/knowledge.widget.dart';
import 'package:client/feature/dashboard/widgets/patient.widget.dart';
import 'package:client/feature/dashboard/widgets/remainder.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final _sdk = FlutterHealthConnect();

  void initials() async {
    await _sdk.initialize();
    await _sdk.getAvailability();
  }

  @override
  void initState() {
    super.initState();
    initials();
  }

  @override
  Widget build(BuildContext context) {
    final stepsCounter = ref.watch(stepsActivityProvider);
    final burnCalaryCounter = ref.watch(burnCaloriesActivityProvider);

    return SingleChildScrollView(
      controller: ScrollController(
        initialScrollOffset: 10,
        keepScrollOffset: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            PatientCard(),
            SizedBox(height: 16),
            RemainderCard(),
            SizedBox(height: 16),
            stepsCounter.when(
              data: (data) => ActivityCardWidget(
                value: data.toString(),
                icon: FontAwesomeIcons.heart,
                iconColor: Colors.red.shade500,
              ),
              error: (e, st) => Center(child: Text(e.toString())),
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 8),
            burnCalaryCounter.when(
              data: (data) => ActivityCardWidget(
                value: data.toString(),
                icon: FontAwesomeIcons.backwardStep,
                iconColor: Colors.blue.shade500,
              ),
              error: (e, _) => Center(child: Text(e.toString())),
              loading: () => CircularProgressIndicator(),
            ),
            SizedBox(height: 16),
            AppWidget(
              'Welcome to MediCare Plus, your trusted healthcare companion designed to make healthcare management simple, secure, and accessible. Patients can manage their medical records, receive medication reminders, communicate with healthcare professionals, monitor health activities, and access essential healthcare services anytime and anywhere. Our platform connects patients and doctors through modern digital solutions, improving clinical care and providing a better healthcare experience.',
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await _sdk.openAppPermissions();
              },
              child: Text('Permission'),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
