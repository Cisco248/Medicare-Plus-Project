import 'package:client/feature/dashboard/notifiers/activity.notifier.dart';
import 'package:client/feature/dashboard/notifiers/knowledge.notifier.dart';
import 'package:client/feature/dashboard/widgets/activity.widget.dart';
import 'package:client/feature/dashboard/widgets/knowledge.widget.dart';
import 'package:client/feature/dashboard/widgets/patient.widget.dart';
import 'package:client/feature/dashboard/widgets/remainder.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final steps = ref.watch(stepsActivityProvider);
    final summary = ref.watch(dailyActivityProvider);
    final knowledge = ref.watch(knowledgeProvider);
    print(knowledge);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const PatientCard(),
            const SizedBox(height: 16),
            const RemainderCard(),
            const SizedBox(height: 16),
            steps.when(
              data: (value) => ActivityCardWidget(
                value: value.toString(),
                valueName: "Foot Steps",
                icon: FontAwesomeIcons.shoePrints,
                iconColor: Colors.red,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.onSurface.withAlpha(10),
                      colorScheme.surfaceContainer.withAlpha(100),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 2,
                child: Center(child: Text('Unable to load steps')),
              ),
            ),
            const SizedBox(height: 8),
            summary.when(
              data: (value) => Column(
                children: [
                  ActivityCardWidget(
                    value: value.totalCalories?.toStringAsFixed(1) ?? '0',
                    valueName: "Burn Calaries",
                    icon: FontAwesomeIcons.fire,
                    iconColor: Colors.orange,
                  ),
                  SizedBox(height: 8),
                  ActivityCardWidget(
                    value: value.distanceMeters?.toStringAsFixed(1) ?? '0',
                    valueName: "Distance",
                    icon: FontAwesomeIcons.road,
                    iconColor: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  ActivityCardWidget(
                    value: "${value.weight?.toStringAsFixed(1) ?? 0} KG",
                    valueName: "Weight",
                    icon: FontAwesomeIcons.dumbbell,
                    iconColor: Colors.green,
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.onSurface.withAlpha(10),
                      colorScheme.surfaceContainer.withAlpha(100),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 2,
                child: Center(child: Text('Unable to load calories')),
              ),
            ),
            const SizedBox(height: 16),
            KnowledgeWidget(knowledge),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
