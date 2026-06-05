import 'package:app/core/themes/themes.dart';
import 'package:app/data/services/activity_service.dart';
import 'package:app/presentation/auth/page/login.dart';
import 'package:app/presentation/dashboard/page/dashboard.dart';
import 'package:app/presentation/layout/page/layout.dart';
import 'package:app/presentation/settings/page/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/sensor_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sensorservice = SensorService();
  await sensorservice.accelerometerData().listen(
    (event) => ActivityService.setData(event),
  );

  runApp(ProviderScope(child: MedicarePlus()));
}

class MedicarePlus extends StatelessWidget {
  const MedicarePlus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ZintraTheme.light(),
      darkTheme: ZintraTheme.dark(),
      home: AppLayout(),
      routes: {
        "/auth": (context) => LoginPage(),
        "/dashboard": (context) => Dashboard(),
        "/setting": (context) => SettingPage(),
      },
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Get Started Page")),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.pushNamed(context, '/auth');
        },
      ),
    );
  }
}
