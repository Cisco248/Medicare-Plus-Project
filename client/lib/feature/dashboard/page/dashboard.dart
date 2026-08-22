import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/dashboard/notifiers/activity.notifier.dart';
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

/// Returns the message intended for the patient, never the raw exception.
String _userMessage(Object error, String subject) =>
    error is AppException ? error.message : 'Unable to load $subject.';

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
    final height = ref.watch(bodyHeightProvider);
    final summary = ref.watch(dailyActivityProvider);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          const PatientCard(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const RemainderCard(),
                const SizedBox(height: 16),
                height.when(
                  data: (data) => ActivityCardWidget(
                    value: "${data.toStringAsFixed(2)} m",
                    valueName: "Height",
                    icon: FontAwesomeIcons.rulerVertical,
                    iconColor: Colors.purple,
                    callback: () {},
                  ),
                  error: (e, st) => Text(_userMessage(e, st.toString())),
                  loading: () => CircularProgressIndicator(),
                ),
                SizedBox(height: 8),
                summary.when(
                  data: (value) {
                    return Column(
                      children: [
                        ActivityCardWidget(
                          value: value.steps.toString(),
                          valueName: "Foot Steps",
                          icon: FontAwesomeIcons.shoePrints,
                          iconColor: Colors.red,
                          callback: () {},
                        ),
                        SizedBox(height: 8),
                        ActivityCardWidget(
                          value: value.totalCalories?.toStringAsFixed(1) ?? '0',
                          valueName: "Burn Calaries",
                          icon: FontAwesomeIcons.fire,
                          iconColor: Colors.orange,
                          callback: () {},
                        ),
                        SizedBox(height: 8),
                        ActivityCardWidget(
                          value: value.weight?.toStringAsFixed(1) ?? '0',
                          valueName: "Weight",
                          icon: FontAwesomeIcons.dumbbell,
                          iconColor: Colors.green,
                          callback: () {},
                        ),
                        SizedBox(height: 8),
                        ActivityCardWidget(
                          value:
                              value.sleepDuration?.inHours.toString() ?? "0.0",
                          valueName: "Sleep Hour",
                          icon: FontAwesomeIcons.bed,
                          iconColor: Colors.blue,
                          callback: () {},
                        ),
                      ],
                    );
                  },
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
                    child: Center(
                      child: Text(_userMessage(error, 'your daily summary')),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const KnowledgeWidget(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
