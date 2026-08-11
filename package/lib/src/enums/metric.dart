library;

/// ## [Metric] backed by Health Connect's native aggregate APIs.
///
///  ### Params
///
/// * [stepsTotal] :
/// Total step count (`StepsRecord.COUNT_TOTAL`).
///
/// * [distanceTotal]:
/// Total distance in meters (`DistanceRecord.DISTANCE_TOTAL`).
///
/// * [activeCaloriesTotal]:
/// Total active calories in kilocalories. (`ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL`).
///
/// * [totalCaloriesTotal]:
/// Total calories in kilocalories. (`TotalCaloriesBurnedRecord.ENERGY_TOTAL`).
///
/// * [floorsClimbedTotal]:
/// Total floors climbed. (`FloorsClimbedRecord.FLOORS_CLIMBED_TOTAL`).
///
/// * [heartRateAvg]:
/// Average heart rate in BPM (`HeartRateRecord.BPM_AVG`).
///
/// * [heartRateMin]:
/// Minimum heart rate in BPM (`HeartRateRecord.BPM_MIN`).
///
/// * [heartRateMax]:
/// Maximum heart rate in BPM (`HeartRateRecord.BPM_MAX`).
///
/// * [restingHeartRateAvg]:
/// Average resting heart rate in BPM (`RestingHeartRateRecord.BPM_AVG`).
///
/// * [weightAvg]:
/// Average weight in kilograms (`WeightRecord.WEIGHT_AVG`).
///
/// ### Returns:
///
/// * [Metric.stepsTotal]:
/// Total step count (`StepsRecord.COUNT_TOTAL`).
///
/// * [Metric.distanceTotal]:
/// Total distance in meters (`DistanceRecord.DISTANCE_TOTAL`).
///
/// * [Metric.activeCaloriesTotal]:
/// Total active calories in kilocalories. (`ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL`).

enum Metric {
  stepsTotal,
  distanceTotal,
  activeCaloriesTotal,
  totalCaloriesTotal,
  floorsClimbedTotal,
  heartRateAvg,
  heartRateMin,
  heartRateMax,
  restingHeartRateAvg,
  weightAvg,
}
