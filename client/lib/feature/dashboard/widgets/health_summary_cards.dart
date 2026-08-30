import 'package:client/core/utils/body_metrics.dart';
import 'package:client/feature/dashboard/models/server_health.model.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/dashboard/notifiers/server_health.notifier.dart';
import 'package:client/feature/dashboard/widgets/activity.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TodayHealthGrid extends ConsumerWidget {
  const TodayHealthGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(clinicalSnapshotProvider);
    final refresh = ref
        .read(clinicalSnapshotProvider.notifier)
        .refreshDailyActivity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Health",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ActivityCardWidget(
          value: snapshot.steps.value?.toString() ?? '—',
          valueName: 'Steps',
          icon: FontAwesomeIcons.shoePrints,
          iconColor: Colors.red,
          callback: refresh,
        ),
        const SizedBox(height: 8),
        ActivityCardWidget(
          value: snapshot.totalCalories.value?.toStringAsFixed(0) ?? '—',
          valueName: 'Calories',
          icon: FontAwesomeIcons.fire,
          iconColor: Colors.orange,
          callback: refresh,
        ),
        const SizedBox(height: 8),
        ActivityCardWidget(
          value: snapshot.sleepHours.value?.toStringAsFixed(1) ?? '—',
          valueName: 'Sleep (hours)',
          icon: FontAwesomeIcons.bed,
          iconColor: Colors.blue,
          callback: refresh,
        ),
        const SizedBox(height: 8),
        ActivityCardWidget(
          value: snapshot.weightKg.value?.toStringAsFixed(1) ?? '—',
          valueName: 'Weight',
          icon: FontAwesomeIcons.dumbbell,
          iconColor: Colors.green,
          callback: refresh,
        ),
        if (snapshot.bmi.isAvailable) ...[
          const SizedBox(height: 8),
          ActivityCardWidget(
            value: BodyMetrics.formatBmi(snapshot.bmi.value) ?? '—',
            valueName: 'BMI',
            icon: FontAwesomeIcons.heartPulse,
            iconColor: Colors.pink,
            callback: refresh,
          ),
        ],
      ],
    );
  }
}

class VitalSignsCard extends ConsumerWidget {
  const VitalSignsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(clinicalSnapshotProvider);
    final bp = snapshot.bloodPressureReading.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vital Signs',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _row(
              'Heart rate',
              snapshot.pulseRate.value == null
                  ? '—'
                  : '${snapshot.pulseRate.value!.toStringAsFixed(0)} bpm',
            ),
            _row('Blood pressure', bp == null ? '—' : '$bp mmHg'),
            _row(
              'Blood glucose',
              snapshot.glucose.value == null
                  ? '—'
                  : '${snapshot.glucose.value!.toStringAsFixed(1)} mmol/L',
            ),
            _row(
              'SpO₂',
              snapshot.oxygenSaturation.value == null
                  ? '—'
                  : '${snapshot.oxygenSaturation.value!.toStringAsFixed(0)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Inter')),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AiHealthSummaryCard extends ConsumerWidget {
  const AiHealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(clinicalSnapshotProvider).serverSummary;
    if (summary == null ||
        (summary.aiSummary == null && summary.recommendations.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI-generated health insight',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (summary.aiSummary != null)
              Text(
                summary.aiSummary!,
                style: const TextStyle(fontFamily: 'Inter'),
              ),
            if (summary.recommendations.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Recommendations',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              ...summary.recommendations.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '• $item',
                    style: const TextStyle(fontFamily: 'Inter'),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              summary.disclaimer ??
                  'This information is intended to support monitoring and should not replace professional medical evaluation.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityTrackingCard extends ConsumerWidget {
  const ActivityTrackingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serverPredictionProvider);
    final latest = state.latest;
    final busy = state.refreshing || (state.loading && latest == null);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk indicators',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            if (state.refreshing) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(minHeight: 2),
            ],
            if (latest != null) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  "Risk Level: ${latest.riskLevel.toUpperCase()}",
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: latest.riskLevel == 'high'
                    ? Colors.red.withAlpha(40)
                    : latest.riskLevel == 'moderate'
                    ? Colors.orange.withAlpha(40)
                    : Colors.green.withAlpha(400),
              ),
              const SizedBox(height: 8),
              Text(
                latest.prediction,
                style: const TextStyle(fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              ...latest.evidence
                  .take(4)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '• ${item.statement}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 12),
              Text(
                latest.disclaimer ??
                    'Potential risk only. This is not a diagnosis and requires clinical review.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${latest.modelName} ${latest.modelVersion}  ·  ${_formatGeneratedAt(latest.generatedAt)}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ] else if (busy) ...[
              const SizedBox(height: 8),
              const Text(
                'Generating risk indicators from your latest health record…',
                style: TextStyle(fontFamily: 'Inter'),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage ??
                    'No risk indicators yet. Tap refresh to generate them from your latest health record.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: state.errorMessage == null
                      ? null
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            if (latest != null && state.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: state.refreshing
                    ? null
                    : () => ref
                          .read(serverPredictionProvider.notifier)
                          .refreshNow(),
                icon: state.refreshing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const FaIcon(FontAwesomeIcons.arrowsRotate, size: 14),
                label: Text(state.refreshing ? 'Refreshing…' : 'Refresh now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatGeneratedAt(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    return '$day/$month/${local.year} $hour:$minute:$second';
  }
}

class HealthTrendChart extends StatelessWidget {
  const HealthTrendChart({required this.trend, super.key});

  final HealthTrend trend;

  @override
  Widget build(BuildContext context) {
    final values = trend.points.map((point) => point.value).toList();
    if (values.every((value) => value == null)) {
      return const SizedBox.shrink();
    }
    final maxValue = values.whereType<double>().fold<double>(
      1,
      (a, b) => a > b ? a : b,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-day ${trend.metric.replaceAll('_', ' ')}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final point in trend.points)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          height: point.value == null
                              ? 4
                              : (point.value! / maxValue) * 72 + 4,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(160),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
