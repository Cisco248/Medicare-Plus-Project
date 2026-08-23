import 'package:client/app.router.dart';
import 'package:client/core/themes/theme_provider.dart';
import 'package:client/core/themes/themes.dart';
import 'package:client/feature/dashboard/notifiers/motion_sensor.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MedicarePlus()));
}

class MedicarePlus extends ConsumerStatefulWidget {
  const MedicarePlus({super.key});

  @override
  ConsumerState<MedicarePlus> createState() => _MedicarePlusState();
}

class _MedicarePlusState extends ConsumerState<MedicarePlus> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appRoute = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);
    ref.watch(motionSensorProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ZintraTheme.light(),
      darkTheme: ZintraTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRoute,
    );
  }
}
