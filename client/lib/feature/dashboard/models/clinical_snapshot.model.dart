import 'package:client/core/utils/body_metrics.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/models/server_health.model.dart';

enum HealthValueSource {
  profile,
  healthConnect,
  server,
  calculated,
  unavailable,
}

class SourcedValue<T> {
  const SourcedValue(this.value, this.source);

  final T? value;
  final HealthValueSource source;

  bool get isAvailable => value != null;
}

/// Combined view of profile, Health Connect, and server metrics.
///
/// Missing values stay null. Callers must not treat 0 as a real measurement.
class ClinicalSnapshot {
  const ClinicalSnapshot({this.profile, this.activity, this.serverSummary});

  final PatientProfile? profile;
  final ActivityModel? activity;
  final ServerDailySummary? serverSummary;

  bool hasCondition(String code) {
    return profile?.conditions.any(
          (item) => item.code.toLowerCase() == code.toLowerCase(),
        ) ??
        false;
  }

  SourcedValue<int> get age {
    if (profile?.age != null) {
      return SourcedValue(profile!.age, HealthValueSource.profile);
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<String> get gender {
    final raw = profile?.gender?.trim();
    if (raw != null && raw.isNotEmpty) {
      return SourcedValue(raw.toLowerCase(), HealthValueSource.profile);
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get heightCm {
    if (profile?.heightCm != null && profile!.heightCm! > 0) {
      return SourcedValue(profile!.heightCm, HealthValueSource.profile);
    }
    final meters = activity?.heightMeters;
    if (meters != null && meters > 0) {
      return SourcedValue(meters * 100, HealthValueSource.healthConnect);
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get weightKg {
    if (profile?.weightKg != null && profile!.weightKg! > 0) {
      return SourcedValue(profile!.weightKg, HealthValueSource.profile);
    }
    final kg = activity?.weightKilograms;
    if (kg != null && kg > 0) {
      return SourcedValue(kg, HealthValueSource.healthConnect);
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get bmi {
    final value = BodyMetrics.bmi(
      heightCm: heightCm.value,
      weightKg: weightKg.value,
    );
    if (value == null) {
      return const SourcedValue(null, HealthValueSource.unavailable);
    }
    return SourcedValue(value, HealthValueSource.calculated);
  }

  SourcedValue<String> get bloodPressureReading {
    final bp = activity?.bloodPressure;
    if (bp != null) {
      return SourcedValue(
        '${bp.systolicMmHg.toStringAsFixed(0)}/${bp.diastolicMmHg.toStringAsFixed(0)}',
        HealthValueSource.healthConnect,
      );
    }
    if (serverSummary?.systolicMmHg != null &&
        serverSummary?.diastolicMmHg != null) {
      return SourcedValue(
        '${serverSummary!.systolicMmHg!.toStringAsFixed(0)}/${serverSummary!.diastolicMmHg!.toStringAsFixed(0)}',
        HealthValueSource.server,
      );
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get glucose {
    final value = activity?.bloodGlucoseMmolPerLiter;
    if (value != null && value > 0) {
      return SourcedValue(value, HealthValueSource.healthConnect);
    }
    if (serverSummary?.bloodGlucoseMmol != null &&
        serverSummary!.bloodGlucoseMmol! > 0) {
      return SourcedValue(
        serverSummary!.bloodGlucoseMmol,
        HealthValueSource.server,
      );
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get oxygenSaturation {
    final value = activity?.oxygenSaturationPercent;
    if (value != null && value > 0) {
      return SourcedValue(value, HealthValueSource.healthConnect);
    }
    if (serverSummary?.oxygenSaturationPercent != null &&
        serverSummary!.oxygenSaturationPercent! > 0) {
      return SourcedValue(
        serverSummary!.oxygenSaturationPercent,
        HealthValueSource.server,
      );
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get pulseRate {
    final bpm =
        activity?.heartRate?.averageBpm ?? activity?.heartRate?.restingBpm;
    if (bpm != null && bpm > 0) {
      return SourcedValue(bpm, HealthValueSource.healthConnect);
    }
    if (serverSummary?.averageHeartRate != null &&
        serverSummary!.averageHeartRate! > 0) {
      return SourcedValue(
        serverSummary!.averageHeartRate,
        HealthValueSource.server,
      );
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get totalCalories {
    if (activity?.totalCalories != null && activity!.totalCalories! > 0) {
      return SourcedValue(
        activity!.totalCalories,
        HealthValueSource.healthConnect,
      );
    }
    if (serverSummary?.totalCalories != null &&
        serverSummary!.totalCalories! > 0) {
      return SourcedValue(
        serverSummary!.totalCalories,
        HealthValueSource.server,
      );
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<int> get steps {
    if (activity?.steps != null) {
      return SourcedValue(activity!.steps, HealthValueSource.healthConnect);
    }
    if (serverSummary?.steps != null) {
      return SourcedValue(serverSummary!.steps, HealthValueSource.server);
    }
    return const SourcedValue(null, HealthValueSource.unavailable);
  }

  SourcedValue<double> get sleepHours {
    final minutes =
        activity?.sleep?.totalMinutes ?? serverSummary?.sleepMinutes;
    if (minutes == null) {
      return const SourcedValue(null, HealthValueSource.unavailable);
    }
    return SourcedValue(
      minutes / 60,
      activity?.sleep != null
          ? HealthValueSource.healthConnect
          : HealthValueSource.server,
    );
  }

  String sourceLabel(HealthValueSource source) {
    return switch (source) {
      HealthValueSource.profile => 'From your profile',
      HealthValueSource.healthConnect => 'From Health Connect',
      HealthValueSource.server => 'From your saved health record',
      HealthValueSource.calculated => 'Calculated from height and weight',
      HealthValueSource.unavailable =>
        'Not available — enter it if you know it',
    };
  }
}
