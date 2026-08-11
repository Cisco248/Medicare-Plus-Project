library;

/// [RecordType] Health Connect record types supported by this plugin.
///
///  Only types present in the official Android Health Connect API are included.
/// There is no first-class BMI record type in Health Connect.
///
/// - [steps]  --> Step count interval records.
/// - [distance] --> Distance traveled interval records.
/// - [activeCaloriesBurned] --> Active calories burned interval records.
/// - [totalCaloriesBurned] --> Total calories burned interval records.
/// - [floorsClimbed] --> Floors climbed interval records.
/// - [exerciseSession] --> Exercise / workout session records.
/// - [heartRate] --> Heart rate series records.
/// - [restingHeartRate] --> Resting heart rate instantaneous records.
/// - [heartRateVariabilityRmssd] --> Heart rate variability (RMSSD) instantaneous records.
/// - [bloodPressure] --> Blood pressure instantaneous records.
/// - [weight] --> Body weight instantaneous records.
/// - [height] --> Body height instantaneous records.
/// - [bodyFat] --> Body fat percentage instantaneous records.
/// - [sleepSession] --> Sleep session records (stages nested inside the session).
/// - [oxygenSaturation] --> Oxygen saturation instantaneous records.
/// - [bodyTemperature] --> Body temperature instantaneous records.
/// - [nutrition] --> Nutrition interval records.
/// - [bloodGlucose] --> Blood glucose instantaneous records.

enum RecordType {
  steps,
  distance,
  activeCaloriesBurned,
  totalCaloriesBurned,
  floorsClimbed,
  exerciseSession,
  heartRate,
  restingHeartRate,
  heartRateVariabilityRmssd,
  bloodPressure,
  weight,
  height,
  bodyFat,
  sleepSession,
  oxygenSaturation,
  bodyTemperature,
  nutrition,
  bloodGlucose,
}
