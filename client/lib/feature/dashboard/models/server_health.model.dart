class ServerDailySummary {
  const ServerDailySummary({
    required this.date,
    this.steps,
    this.distanceMeters,
    this.activeCalories,
    this.totalCalories,
    this.averageHeartRate,
    this.minHeartRate,
    this.maxHeartRate,
    this.restingHeartRate,
    this.sleepMinutes,
    this.activityMinutes,
    this.systolicMmHg,
    this.diastolicMmHg,
    this.bloodGlucoseMmol,
    this.oxygenSaturationPercent,
    this.weightKg,
    this.heightCm,
    this.anomalies = const [],
    this.aiSummary,
    this.recommendations = const [],
    this.disclaimer,
  });

  final DateTime date;
  final int? steps;
  final double? distanceMeters;
  final double? activeCalories;
  final double? totalCalories;
  final double? averageHeartRate;
  final double? minHeartRate;
  final double? maxHeartRate;
  final double? restingHeartRate;
  final int? sleepMinutes;
  final int? activityMinutes;
  final double? systolicMmHg;
  final double? diastolicMmHg;
  final double? bloodGlucoseMmol;
  final double? oxygenSaturationPercent;
  final double? weightKg;
  final double? heightCm;
  final List<String> anomalies;
  final String? aiSummary;
  final List<String> recommendations;
  final String? disclaimer;

  factory ServerDailySummary.fromJson(Map<String, dynamic> json) {
    return ServerDailySummary(
      date: parseCalendarDate(json['date'] as String),
      steps: (json['steps'] as num?)?.toInt(),
      distanceMeters: (json['distance_meters'] as num?)?.toDouble(),
      activeCalories: (json['active_calories'] as num?)?.toDouble(),
      totalCalories: (json['total_calories'] as num?)?.toDouble(),
      averageHeartRate: (json['average_heart_rate'] as num?)?.toDouble(),
      minHeartRate: (json['min_heart_rate'] as num?)?.toDouble(),
      maxHeartRate: (json['max_heart_rate'] as num?)?.toDouble(),
      restingHeartRate: (json['resting_heart_rate'] as num?)?.toDouble(),
      sleepMinutes: (json['sleep_minutes'] as num?)?.toInt(),
      activityMinutes: (json['activity_minutes'] as num?)?.toInt(),
      systolicMmHg: (json['systolic_mm_hg'] as num?)?.toDouble(),
      diastolicMmHg: (json['diastolic_mm_hg'] as num?)?.toDouble(),
      bloodGlucoseMmol: (json['blood_glucose_mmol'] as num?)?.toDouble(),
      oxygenSaturationPercent: (json['oxygen_saturation_percent'] as num?)
          ?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      anomalies: [
        for (final item in json['anomalies'] as List? ?? const [])
          item.toString(),
      ],
      aiSummary: json['ai_summary'] as String?,
      recommendations: [
        for (final item in json['recommendations'] as List? ?? const [])
          item.toString(),
      ],
      disclaimer: json['disclaimer'] as String?,
    );
  }
}

class PredictionEvidence {
  const PredictionEvidence({required this.statement, this.metricType});

  final String statement;
  final String? metricType;

  factory PredictionEvidence.fromJson(Map<String, dynamic> json) {
    return PredictionEvidence(
      statement: json['statement'] as String? ?? '',
      metricType: json['metric_type'] as String?,
    );
  }
}

class ServerPrediction {
  const ServerPrediction({
    required this.id,
    required this.prediction,
    required this.riskLevel,
    required this.modelName,
    required this.modelVersion,
    required this.generatedAt,
    this.predictionScore,
    this.evidence = const [],
    this.disclaimer,
  });

  final String id;
  final String prediction;
  final String riskLevel;
  final String modelName;
  final String modelVersion;
  final DateTime generatedAt;
  final double? predictionScore;
  final List<PredictionEvidence> evidence;
  final String? disclaimer;

  factory ServerPrediction.fromJson(Map<String, dynamic> json) {
    return ServerPrediction(
      id: json['id'] as String? ?? '',
      prediction: json['prediction'] as String? ?? '',
      riskLevel: json['risk_level'] as String? ?? 'low',
      modelName: json['model_name'] as String? ?? '',
      modelVersion: json['model_version'] as String? ?? '',
      generatedAt: _parseDateTime(json['generated_at']),
      predictionScore: (json['prediction_score'] as num?)?.toDouble(),
      evidence: [
        for (final item in json['evidence'] as List? ?? const [])
          PredictionEvidence.fromJson(Map<String, dynamic>.from(item as Map)),
      ],
      disclaimer: json['disclaimer'] as String?,
    );
  }
}

DateTime parseCalendarDate(String raw) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return DateTime.now();
  return DateTime(parsed.year, parsed.month, parsed.day);
}

DateTime _parseDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value) ?? DateTime.now().toUtc();
  }
  return DateTime.now().toUtc();
}

class TrendPoint {
  const TrendPoint({required this.date, this.value});

  final DateTime date;
  final double? value;

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      date: parseCalendarDate(json['date'] as String),
      value: (json['value'] as num?)?.toDouble(),
    );
  }
}

class HealthTrend {
  const HealthTrend({
    required this.metric,
    required this.unit,
    required this.points,
  });

  final String metric;
  final String unit;
  final List<TrendPoint> points;

  factory HealthTrend.fromJson(Map<String, dynamic> json) {
    return HealthTrend(
      metric: json['metric'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      points: [
        for (final item in json['points'] as List? ?? const [])
          TrendPoint.fromJson(Map<String, dynamic>.from(item as Map)),
      ],
    );
  }
}
