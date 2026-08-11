import 'package:flutter_health_connect/src/enums/export.dart';

/// Result of a Health Connect aggregation query.
/// [AggregationResult] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [metric]: The metric that was aggregated.
/// * [startTime]: The start time of the query.
/// * [endTime]: The end time of the query.
/// * [value]: The aggregated value, or `null` when no data was available.

class AggregationResult {
  const AggregationResult({
    required this.metric,
    required this.startTime,
    required this.endTime,
    this.value,
  });

  final Metric metric;
  final DateTime startTime;
  final DateTime endTime;
  final double? value;

  factory AggregationResult.fromMap(Map<Object?, Object?> map) {
    return AggregationResult(
      metric: Metric.values.byName(map['metric']! as String),
      startTime: DateTime.fromMillisecondsSinceEpoch(
        map['startTimeMillis']! as int,
        isUtc: true,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        map['endTimeMillis']! as int,
        isUtc: true,
      ),
      value: (map['value'] as num?)?.toDouble(),
    );
  }
}
