import 'package:client/core/themes/primitives/spacing.dart';
import 'package:client/core/themes/tokens/spacing.dart';
import 'package:client/core/widgets/glass.widget.dart';
import 'package:client/feature/dashboard/models/weekly_health.model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HealthChartCard extends StatelessWidget {
  const HealthChartCard({
    super.key,
    required this.title,
    required this.unit,
    required this.series,
    this.subtitle,
    this.loading = false,
    this.error = false,
    this.onRetry,
    this.barColor,
    this.emptyTitle = 'No activity data available',
    this.emptyMessage =
        'Your activity data will appear here once new measurements are recorded.',
  });

  final String title;
  final String unit;
  final List<WeeklyMetricPoint> series;
  final String? subtitle;
  final bool loading;
  final bool error;
  final VoidCallback? onRetry;
  final Color? barColor;
  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(ZintraSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: ZintraSpacing.xs),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: ZintraSpacing.sm),
          SizedBox(height: 168, child: _body(context)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (loading) return const _ChartSkeleton();
    if (error) {
      return _ChartMessage(
        icon: FontAwesomeIcons.triangleExclamation,
        title: 'Unable to load activity data',
        message: 'Try again',
        actionLabel: onRetry == null ? null : 'Try again',
        onAction: onRetry,
      );
    }
    if (series.isEmpty || series.every((point) => !point.hasData)) {
      return _ChartMessage(
        icon: FontAwesomeIcons.chartColumn,
        title: emptyTitle,
        message: emptyMessage,
      );
    }
    return Semantics(
      label: '$title, $unit, last ${series.length} days',
      child: _WeeklyBarChart(series: series, unit: unit, barColor: barColor),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart({
    required this.series,
    required this.unit,
    this.barColor,
  });

  final List<WeeklyMetricPoint> series;
  final String unit;
  final Color? barColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = barColor ?? cs.primary;
    final present = [
      for (final point in series)
        if (point.hasData) point.value!,
    ];
    final peak = present.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );
    final maxY = peak <= 0 ? 1.0 : peak * 1.15;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontFamily: 'Inter',
      color: cs.onSurfaceVariant,
      fontSize: 10,
    );

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => cs.surfaceContainer,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (groupIndex < 0 || groupIndex >= series.length) return null;
              final point = series[groupIndex];
              final day = weekdayLabel(point.date);
              final valueText = point.hasData
                  ? '${_formatValue(point.value!)} $unit'
                  : 'No data';
              return BarTooltipItem(
                '$day\n$valueText',
                TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: _interval(maxY),
              getTitlesWidget: (value, meta) {
                if (value < 0 || value > maxY) return const SizedBox.shrink();
                return Text(_compact(value), style: labelStyle);
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= series.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    weekdayLabel(series[index].date),
                    style: labelStyle,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _interval(maxY),
          getDrawingHorizontalLine: (value) =>
              FlLine(color: cs.outline.withValues(alpha: 0.22), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var index = 0; index < series.length; index++)
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: _barHeight(series[index], maxY),
                  width: 12,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(ZintraSpacing.radiusMd),
                  ),
                  color: series[index].hasData
                      ? color
                      : cs.outline.withValues(alpha: 0),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: cs.outline.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
        ],
      ),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  double _barHeight(WeeklyMetricPoint point, double maxY) {
    if (!point.hasData) return 0;
    if (point.value! <= 0) return maxY * 0.02;
    return point.value!;
  }

  double _interval(double maxY) {
    if (maxY <= 1) return 0.25;
    if (maxY <= 10) return 2;
    if (maxY <= 100) return 20;
    if (maxY <= 1000) return 200;
    if (maxY <= 10000) return 2000;
    return (maxY / 4).clamp(1, double.infinity);
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fill = cs.outline.withValues(alpha: 0.18);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10,
          width: 140,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: ZintraRadius.full,
          ),
        ),
        const SizedBox(height: ZintraSpacing.md),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final height in const [
                48.0,
                96.0,
                64.0,
                120.0,
                72.0,
                108.0,
                56.0,
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: fill,
                        borderRadius: ZintraRadius.md,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartMessage extends StatelessWidget {
  const _ChartMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final FaIconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 18, color: cs.primary),
          const SizedBox(height: ZintraSpacing.xs),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: cs.onSurfaceVariant,
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: ZintraSpacing.xs),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

String _formatValue(double value) {
  if (value >= 100) return value.toStringAsFixed(0);
  if (value >= 10) return value.toStringAsFixed(1);
  return value.toStringAsFixed(2);
}

String _compact(double value) {
  if (value >= 1000) {
    final thousands = value / 1000;
    return thousands >= 10
        ? '${thousands.toStringAsFixed(0)}k'
        : '${thousands.toStringAsFixed(1)}k';
  }
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
