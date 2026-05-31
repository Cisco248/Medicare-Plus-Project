import 'package:app/core/themes/themes.dart';
import 'package:app/presentation/auth/page/login.dart';
import 'package:app/presentation/dashboard/page/dashboard.dart';
import 'package:app/presentation/settings/page/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MedicarePlus()));
}

class MedicarePlus extends StatelessWidget {
  const MedicarePlus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ZintraTheme.light(),
      darkTheme: ZintraTheme.dark(),
      home: GetStartedPage(),
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
