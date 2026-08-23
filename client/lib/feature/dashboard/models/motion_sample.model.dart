class MotionSample {
  const MotionSample({
    required this.timestamp,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
  });

  final DateTime timestamp;
  final double accX;
  final double accY;
  final double accZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toUtc().toIso8601String(),
    'acc_x': accX,
    'acc_y': accY,
    'acc_z': accZ,
    'gyro_x': gyroX,
    'gyro_y': gyroY,
    'gyro_z': gyroZ,
  };
}

class MotionStoreResult {
  const MotionStoreResult({
    required this.accepted,
    required this.pruned,
    required this.sampleCount,
  });

  final int accepted;
  final int pruned;
  final int sampleCount;

  factory MotionStoreResult.fromJson(Map<String, dynamic> json) {
    return MotionStoreResult(
      accepted: (json['accepted'] as num?)?.toInt() ?? 0,
      pruned: (json['pruned'] as num?)?.toInt() ?? 0,
      sampleCount:
          (json['sample_count'] as num?)?.toInt() ??
          (json['sampleCount'] as num?)?.toInt() ??
          0,
    );
  }
}

class MotionPrediction {
  const MotionPrediction({
    required this.activity,
    required this.confidence,
    required this.windowSamples,
    this.summary,
  });

  final String activity;
  final double confidence;
  final int windowSamples;
  final String? summary;

  factory MotionPrediction.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'];
    return MotionPrediction(
      activity: json['activity'] as String? ?? 'unknown',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      windowSamples:
          (json['window_samples'] as num?)?.toInt() ??
          (json['windowSamples'] as num?)?.toInt() ??
          0,
      summary: rawSummary is String ? rawSummary : rawSummary?.toString(),
    );
  }
}
