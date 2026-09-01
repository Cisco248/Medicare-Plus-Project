import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/feature/dashboard/models/weekly_health.model.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/dashboard/widgets/health_chart_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyHealthCharts extends ConsumerWidget {
  const WeeklyHealthCharts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekly = ref.watch(weeklyHealthProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return weekly.when(
      loading: () => _ChartGrid(
        children: [
          for (final title in const [
            'Weekly Steps',
            'Calories Burned',
            'Sleep Hours',
            'Patient Activity',
          ])
            HealthChartCard(
              title: title,
              unit: '',
              series: const [],
              loading: true,
            ),
        ],
      ),
      error: (_, _) => _ChartGrid(
        children: [
          HealthChartCard(
            title: 'Weekly Steps',
            unit: 'steps',
            series: const [],
            error: true,
            onRetry: () => ref.invalidate(weeklyHealthProvider),
          ),
          HealthChartCard(
            title: 'Calories Burned',
            unit: 'kcal',
            series: const [],
            error: true,
            onRetry: () => ref.invalidate(weeklyHealthProvider),
          ),
          HealthChartCard(
            title: 'Sleep Hours',
            unit: 'h',
            series: const [],
            error: true,
            onRetry: () => ref.invalidate(weeklyHealthProvider),
          ),
          HealthChartCard(
            title: 'Patient Activity',
            unit: '',
            series: const [],
            error: true,
            onRetry: () => ref.invalidate(weeklyHealthProvider),
          ),
        ],
      ),
      data: (overview) {
        if (overview == null) {
          return _ChartGrid(
            children: [
              HealthChartCard(
                title: 'Weekly Steps',
                unit: 'steps',
                series: const [],
              ),
              HealthChartCard(
                title: 'Calories Burned',
                unit: 'kcal',
                series: const [],
              ),
              HealthChartCard(
                title: 'Sleep Hours',
                unit: 'h',
                series: const [],
              ),
              HealthChartCard(
                title: 'Patient Activity',
                unit: '',
                series: const [],
              ),
            ],
          );
        }

        final steps = overview.stepsSeries();
        final calories = overview.caloriesSeries();
        final sleep = overview.sleepHoursSeries();
        final activity = overview.activitySeries();
        final activityUnit = overview.activityUsesMinutes ? 'min' : 'kcal';
        final activityLabel = overview.activityUsesMinutes
            ? 'Active minutes'
            : 'Active energy';

        return _ChartGrid(
          children: [
            HealthChartCard(
              title: 'Weekly Steps',
              unit: 'steps',
              series: steps,
              subtitle: _subtitle(overview.statsFor(steps), 'steps'),
              barColor: colorScheme.primary,
              emptyTitle: 'No step data available',
              emptyMessage:
                  'Weekly steps will appear here once Health Connect records them.',
            ),
            HealthChartCard(
              title: 'Calories Burned',
              unit: 'kcal',
              series: calories,
              subtitle: _subtitle(overview.statsFor(calories), 'kcal'),
              barColor: colorScheme.secondary,
              emptyTitle: 'No calorie data available',
              emptyMessage:
                  'Calories burned will appear here once Health Connect records them.',
            ),
            HealthChartCard(
              title: 'Sleep Hours',
              unit: 'h',
              series: sleep,
              subtitle: _subtitle(overview.statsFor(sleep), 'h'),
              barColor: colorScheme.tertiary,
              emptyTitle: 'No sleep data available',
              emptyMessage:
                  'Sleep hours will appear here once Health Connect records them.',
            ),
            HealthChartCard(
              title: 'Patient Activity',
              unit: activityUnit,
              series: activity,
              subtitle: _activitySubtitle(
                overview.statsFor(activity),
                activityLabel,
                activityUnit,
              ),
              barColor: colorScheme.primary,
              emptyTitle: 'No activity data available',
              emptyMessage:
                  'Workouts and active energy will appear here once Health Connect records them.',
            ),
          ],
        );
      },
    );
  }

  String? _subtitle(WeeklySeriesStats? stats, String unit) {
    if (stats == null) return null;
    return '${_format(stats.total, unit)} total  ·  ${_format(stats.average, unit)} avg/day';
  }

  String? _activitySubtitle(
    WeeklySeriesStats? stats,
    String label,
    String unit,
  ) {
    if (stats == null) return label;
    return '$label  ·  ${_format(stats.total, unit)} total';
  }

  String _format(double value, String unit) {
    if (unit == 'h') return '${value.toStringAsFixed(1)} $unit';
    if (value >= 100) return '${value.toStringAsFixed(0)} $unit';
    return '${value.toStringAsFixed(1)} $unit';
  }
}

class _ChartGrid extends StatelessWidget {
  const _ChartGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    if (!wide) {
      return Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const SizedBox(height: ZintraSpacing.sm),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final right = i + 1 < children.length
          ? children[i + 1]
          : const SizedBox();
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[i]),
            const SizedBox(width: ZintraSpacing.sm),
            Expanded(child: right),
          ],
        ),
      );
      if (i + 2 < children.length) {
        rows.add(const SizedBox(height: ZintraSpacing.sm));
      }
    }
    return Column(children: rows);
  }
}
