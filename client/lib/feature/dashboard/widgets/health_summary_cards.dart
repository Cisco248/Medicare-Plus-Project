import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/utils/body_metrics.dart';
import 'package:client/core/widgets/glass.widget.dart';
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
    final cs = Theme.of(context).colorScheme;
    final tiles = <Widget>[
      ActivityCardWidget(
        value: snapshot.steps.value?.toString() ?? '—',
        valueName: 'Steps',
        icon: FontAwesomeIcons.shoePrints,
        iconColor: cs.primary,
        callback: refresh,
      ),
      ActivityCardWidget(
        value: snapshot.totalCalories.value?.toStringAsFixed(0) ?? '—',
        valueName: 'Calories',
        icon: FontAwesomeIcons.fire,
        iconColor: cs.secondary,
        callback: refresh,
      ),
      ActivityCardWidget(
        value: snapshot.sleepHours.value?.toStringAsFixed(1) ?? '—',
        valueName: 'Sleep (hours)',
        icon: FontAwesomeIcons.bed,
        iconColor: cs.tertiary,
        callback: refresh,
      ),
      ActivityCardWidget(
        value: snapshot.weightKg.value?.toStringAsFixed(1) ?? '—',
        valueName: 'Weight',
        icon: FontAwesomeIcons.dumbbell,
        iconColor: cs.primary,
        callback: refresh,
      ),
      if (snapshot.bmi.isAvailable)
        ActivityCardWidget(
          value: BodyMetrics.formatBmi(snapshot.bmi.value) ?? '—',
          valueName: 'BMI',
          icon: FontAwesomeIcons.heartPulse,
          iconColor: cs.secondary,
          callback: refresh,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Health",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: ZintraSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 700 ? 4 : 2;
            final gap = ZintraSpacing.xs;
            final width =
                ((constraints.maxWidth - gap * (columns - 1)) / columns)
                    .floorToDouble();
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final tile in tiles) SizedBox(width: width, child: tile),
              ],
            );
          },
        ),
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
    final cs = Theme.of(context).colorScheme;
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vital Signs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: ZintraSpacing.sm),
          _row(
            context,
            'Heart rate',
            snapshot.pulseRate.value == null
                ? '—'
                : '${snapshot.pulseRate.value!.toStringAsFixed(0)} bpm',
          ),
          _row(context, 'Blood pressure', bp == null ? '—' : '$bp mmHg'),
          _row(
            context,
            'Blood glucose',
            snapshot.glucose.value == null
                ? '—'
                : '${snapshot.glucose.value!.toStringAsFixed(1)} mmol/L',
          ),
          _row(
            context,
            'SpO₂',
            snapshot.oxygenSaturation.value == null
                ? '—'
                : '${snapshot.oxygenSaturation.value!.toStringAsFixed(0)}%',
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: 'Inter', color: cs.onSurfaceVariant),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
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
    final cs = Theme.of(context).colorScheme;
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI-generated health insight',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: ZintraSpacing.xs),
          if (summary.aiSummary != null)
            Text(
              summary.aiSummary!,
              style: TextStyle(fontFamily: 'Inter', color: cs.onSurface),
            ),
          if (summary.recommendations.isNotEmpty) ...[
            const SizedBox(height: ZintraSpacing.sm),
            Text(
              'Recommendations',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            ...summary.recommendations.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '• $item',
                  style: TextStyle(fontFamily: 'Inter', color: cs.onSurface),
                ),
              ),
            ),
          ],
          const SizedBox(height: ZintraSpacing.sm),
          Text(
            summary.disclaimer ??
                'This information is intended to support monitoring and should not replace professional medical evaluation.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
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
    final cs = Theme.of(context).colorScheme;

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk indicators',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          if (state.refreshing) ...[
            const SizedBox(height: ZintraSpacing.xs),
            const LinearProgressIndicator(minHeight: 2),
          ],
          if (latest != null) ...[
            const SizedBox(height: ZintraSpacing.xs),
            Chip(
              label: Text(
                'Risk Level: ${latest.riskLevel.toUpperCase()}',
                style: TextStyle(fontSize: 13, color: cs.onSurface),
              ),
              backgroundColor: latest.riskLevel == 'high'
                  ? cs.error.withValues(alpha: 0.16)
                  : latest.riskLevel == 'moderate'
                  ? cs.tertiary.withValues(alpha: 0.16)
                  : cs.primary.withValues(alpha: 0.16),
              side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: ZintraSpacing.xs),
            Text(
              latest.prediction,
              style: TextStyle(fontFamily: 'Inter', color: cs.onSurface),
            ),
            const SizedBox(height: ZintraSpacing.xs),
            ...latest.evidence
                .take(4)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '• ${item.statement}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: ZintraSpacing.sm),
            Text(
              latest.disclaimer ??
                  'Potential risk only. This is not a diagnosis and requires clinical review.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${latest.modelName} ${latest.modelVersion}  ·  ${_formatGeneratedAt(latest.generatedAt)}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: cs.onSurfaceVariant,
              ),
            ),
          ] else if (busy) ...[
            const SizedBox(height: ZintraSpacing.xs),
            Text(
              'Generating risk indicators from your latest health record…',
              style: TextStyle(fontFamily: 'Inter', color: cs.onSurface),
            ),
          ] else ...[
            const SizedBox(height: ZintraSpacing.xs),
            Text(
              state.errorMessage ??
                  'No risk indicators yet. Tap refresh to generate them from your latest health record.',
              style: TextStyle(
                fontFamily: 'Inter',
                color: state.errorMessage == null ? cs.onSurface : cs.error,
              ),
            ),
          ],
          if (latest != null && state.errorMessage != null) ...[
            const SizedBox(height: ZintraSpacing.xs),
            Text(
              state.errorMessage!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: cs.error,
              ),
            ),
          ],
          const SizedBox(height: ZintraSpacing.sm),
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
    final cs = Theme.of(context).colorScheme;
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-day ${trend.metric.replaceAll('_', ' ')}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: ZintraSpacing.sm),
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
                          color: cs.primary.withValues(alpha: 0.63),
                          borderRadius: BorderRadius.circular(
                            ZintraSpacing.radiusSm,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
