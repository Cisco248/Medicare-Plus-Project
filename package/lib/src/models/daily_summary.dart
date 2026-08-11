library;

/// High-level daily health summary for healthcare applications.
///
/// Only fields with available Health Connect data are populated.
/// Values use the device's local calendar day on Android.
/// [DailySummary] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [date]: The date of the summary.
/// * [steps]: The total steps for the day.
/// * [distanceMeters]: The total distance in meters for the day.
/// * [activeCalories]: The total active calories for the day.
/// * [totalCalories]: The total calories for the day.
/// * [averageHeartRate]: The average heart rate for the day.
/// * [restingHeartRate]: The average resting heart rate for the day.
/// * [sleepDuration]: The total sleep duration for the day.
/// * [weight]: The average weight for the day.

class DailySummary {
  const DailySummary({
    required this.date,
    this.steps,
    this.distanceMeters,
    this.activeCalories,
    this.totalCalories,
    this.averageHeartRate,
    this.restingHeartRate,
    this.sleepDuration,
    this.weight,
  });

  final DateTime date;
  final int? steps;
  final double? distanceMeters;
  final double? activeCalories;
  final double? totalCalories;
  final double? averageHeartRate;
  final double? restingHeartRate;
  final Duration? sleepDuration;
  final double? weight;

  factory DailySummary.fromMap(Map<Object?, Object?> map) {
    final sleepMillis = map['sleepDurationMillis'] as int?;
    return DailySummary(
      date: DateTime.fromMillisecondsSinceEpoch(
        map['dateMillis']! as int,
        isUtc: false,
      ),
      steps: (map['steps'] as num?)?.toInt(),
      distanceMeters: (map['distanceMeters'] as num?)?.toDouble(),
      activeCalories: (map['activeCalories'] as num?)?.toDouble(),
      totalCalories: (map['totalCalories'] as num?)?.toDouble(),
      averageHeartRate: (map['averageHeartRate'] as num?)?.toDouble(),
      restingHeartRate: (map['restingHeartRate'] as num?)?.toDouble(),
      sleepDuration: sleepMillis == null
          ? null
          : Duration(milliseconds: sleepMillis),
      weight: (map['weight'] as num?)?.toDouble(),
    );
  }
}
