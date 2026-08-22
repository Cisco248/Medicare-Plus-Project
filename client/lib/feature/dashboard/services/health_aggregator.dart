import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:flutter_health_connect/app.dart';

/// Pure aggregation of raw Health Connect records into normalized values.
///
/// All methods return `null` (or an empty list) when there is no data, so
/// missing metrics are never reported as zero. Duplicate records (same
/// non-empty Health Connect ID) are counted once.
class HealthAggregator {
  const HealthAggregator._();

  /// Keeps only records overlapping the `[start, end)` window.
  static List<T> filterByRange<T extends BaseRecord>(
    List<T> records,
    DateTime start,
    DateTime end,
  ) {
    final startUtc = start.toUtc();
    final endUtc = end.toUtc();
    return records
        .where(
          (r) =>
              r.startTime.toUtc().isBefore(endUtc) &&
              r.endTime.toUtc().isAfter(startUtc),
        )
        .toList(growable: false);
  }

  static List<T> _dedupe<T extends BaseRecord>(List<T> records) {
    final seen = <String>{};
    final result = <T>[];
    for (final record in records) {
      if (record.id.isEmpty || seen.add(record.id)) result.add(record);
    }
    return result;
  }

  static int? sumSteps(List<StepsRecord> records) {
    final unique = _dedupe(records);
    if (unique.isEmpty) return null;
    return unique.fold<int>(0, (sum, r) => sum + r.count);
  }

  static double? sumDistanceMeters(List<DistanceRecord> records) {
    final unique = _dedupe(records);
    if (unique.isEmpty) return null;
    return unique.fold<double>(0, (sum, r) => sum + r.distanceMeters);
  }

  static double? sumActiveCalories(List<ActiveCaloriesBurnedRecord> records) {
    final unique = _dedupe(records);
    if (unique.isEmpty) return null;
    return unique.fold<double>(0, (sum, r) => sum + r.energyKilocalories);
  }

  static double? sumTotalCalories(List<TotalCaloriesBurnedRecord> records) {
    final unique = _dedupe(records);
    if (unique.isEmpty) return null;
    return unique.fold<double>(0, (sum, r) => sum + r.energyKilocalories);
  }

  /// Average/min/max over all heart-rate samples plus the average resting
  /// heart rate, when available.
  static HeartRateSummary? summarizeHeartRate(
    List<HeartRateRecord> heartRateRecords,
    List<RestingHeartRateRecord> restingRecords,
  ) {
    final samples = _dedupe(
      heartRateRecords,
    ).expand((r) => r.samples).map((s) => s.beatsPerMinute).toList();
    final resting = _dedupe(restingRecords).map((r) => r.beatsPerMinute);

    if (samples.isEmpty && resting.isEmpty) return null;

    double? averageBpm;
    int? minBpm;
    int? maxBpm;
    if (samples.isNotEmpty) {
      averageBpm = samples.reduce((a, b) => a + b) / samples.length;
      minBpm = samples.reduce((a, b) => a < b ? a : b);
      maxBpm = samples.reduce((a, b) => a > b ? a : b);
    }

    double? restingBpm;
    if (resting.isNotEmpty) {
      restingBpm = resting.reduce((a, b) => a + b) / resting.length;
    }

    return HeartRateSummary(
      averageBpm: averageBpm,
      minBpm: minBpm,
      maxBpm: maxBpm,
      restingBpm: restingBpm,
    );
  }

  /// Total sleep duration with overlapping sessions merged, so the same
  /// minutes are never counted twice.
  static SleepSummary? summarizeSleep(List<SleepSessionRecord> records) {
    final unique = _dedupe(records);
    if (unique.isEmpty) return null;

    final intervals =
        unique
            .map((r) => (start: r.startTime.toUtc(), end: r.endTime.toUtc()))
            .toList()
          ..sort((a, b) => a.start.compareTo(b.start));

    var totalMillis = 0;
    var currentStart = intervals.first.start;
    var currentEnd = intervals.first.end;
    for (final interval in intervals.skip(1)) {
      if (interval.start.isAfter(currentEnd)) {
        totalMillis += currentEnd.difference(currentStart).inMilliseconds;
        currentStart = interval.start;
        currentEnd = interval.end;
      } else if (interval.end.isAfter(currentEnd)) {
        currentEnd = interval.end;
      }
    }
    totalMillis += currentEnd.difference(currentStart).inMilliseconds;

    return SleepSummary(
      totalMinutes: Duration(milliseconds: totalMillis).inMinutes,
      sessionCount: unique.length,
    );
  }

  static List<WorkoutSummary> summarizeWorkouts(
    List<ExerciseSessionRecord> records,
  ) {
    final unique = _dedupe(records)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return unique
        .map(
          (r) => WorkoutSummary(
            type: r.exerciseType,
            title: r.title,
            startTime: r.startTime.toUtc(),
            endTime: r.endTime.toUtc(),
            durationMinutes: r.endTime.difference(r.startTime).inMinutes,
          ),
        )
        .toList(growable: false);
  }

  static double? latestWeightKilograms(List<WeightRecord> records) =>
      _latest(records)?.weightKilograms;

  static double? latestHeightMeters(List<HeightRecord> records) =>
      _latest(records)?.heightMeters;

  static BloodPressureSummary? latestBloodPressure(
    List<BloodPressureRecord> records,
  ) {
    final latest = _latest(records);
    if (latest == null) return null;
    return BloodPressureSummary(
      systolicMmHg: latest.systolicMmHg,
      diastolicMmHg: latest.diastolicMmHg,
      measuredAt: latest.startTime.toUtc(),
    );
  }

  static double? latestBloodGlucoseMmolPerLiter(
    List<BloodGlucoseRecord> records,
  ) => _latest(records)?.levelMillimolesPerLiter;

  static double? latestOxygenSaturationPercent(
    List<OxygenSaturationRecord> records,
  ) => _latest(records)?.percentage;

  static T? _latest<T extends BaseRecord>(List<T> records) {
    final unique = _dedupe(records);
    if (unique.isEmpty) return null;
    unique.sort((a, b) => a.startTime.compareTo(b.startTime));
    return unique.last;
  }
}
