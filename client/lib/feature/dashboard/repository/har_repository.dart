import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/motion_sample.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/models/server_health.model.dart';
import 'package:client/feature/dashboard/models/weekly_health.model.dart';
import 'package:dio/dio.dart';

class HarRepository {
  HarRepository({required this._client});

  final Dio _client;

  Future<void> submitActivity({
    required String token,
    required String userId,
    required ActivityModel activity,
    required DateTime day,
    String timezone = 'UTC',
  }) async {
    final records = <Map<String, dynamic>>[];
    void add(String type, num? value, String unit, {String? id}) {
      if (value == null) return;
      records.add({
        'metric_type': type,
        'value': value,
        'unit': unit,
        'recorded_at': day.toUtc().toIso8601String(),
        'source': 'health_connect',
        'external_record_id': ?id,
      });
    }

    add('steps', activity.steps, 'count', id: 'steps-${day.toIso8601String()}');
    add(
      'distance',
      activity.distanceMeters,
      'meters',
      id: 'distance-${day.toIso8601String()}',
    );
    add(
      'active_calories',
      activity.activeCalories,
      'kcal',
      id: 'active-cal-${day.toIso8601String()}',
    );
    add(
      'total_calories',
      activity.totalCalories,
      'kcal',
      id: 'total-cal-${day.toIso8601String()}',
    );
    add(
      'heart_rate',
      activity.heartRate?.averageBpm,
      'bpm',
      id: 'hr-${day.toIso8601String()}',
    );
    add(
      'resting_heart_rate',
      activity.heartRate?.restingBpm,
      'bpm',
      id: 'rhr-${day.toIso8601String()}',
    );
    add(
      'sleep_minutes',
      activity.sleep?.totalMinutes,
      'minutes',
      id: 'sleep-${day.toIso8601String()}',
    );
    add(
      'weight',
      activity.weightKilograms,
      'kg',
      id: 'weight-${day.toIso8601String()}',
    );
    if (activity.heightMeters != null) {
      add(
        'height',
        activity.heightMeters! * 100,
        'cm',
        id: 'height-${day.toIso8601String()}',
      );
    }
    add(
      'blood_pressure_systolic',
      activity.bloodPressure?.systolicMmHg,
      'mmHg',
      id: 'sys-${day.toIso8601String()}',
    );
    add(
      'blood_pressure_diastolic',
      activity.bloodPressure?.diastolicMmHg,
      'mmHg',
      id: 'dia-${day.toIso8601String()}',
    );
    add(
      'blood_glucose',
      activity.bloodGlucoseMmolPerLiter,
      'mmol/L',
      id: 'glu-${day.toIso8601String()}',
    );
    add(
      'oxygen_saturation',
      activity.oxygenSaturationPercent,
      'percent',
      id: 'spo2-${day.toIso8601String()}',
    );

    if (records.isEmpty) return;

    try {
      await _client.post(
        '/api/har',
        data: {
          'patient_id': userId,
          'date':
              '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}',
          'timezone': timezone,
          'records': records,
        },
        options: Options(headers: {'X-Auth-Token': token}),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<ServerDailySummary> dailySummary({
    required String token,
    required DateTime day,
    String timezone = 'UTC',
  }) async {
    try {
      final response = await _client.get(
        '/api/har/daily',
        queryParameters: {
          'day':
              '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}',
          'timezone': timezone,
        },
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return ServerDailySummary.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<HealthTrend> trends({
    required String token,
    String metric = 'steps',
  }) async {
    try {
      final response = await _client.get(
        '/api/har/trends',
        queryParameters: {'metric': metric, 'days': 7},
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return HealthTrend.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<WeeklyHealthOverview> weeklyOverview({
    required String token,
    int days = 7,
    String timezone = 'UTC',
    DateTime? end,
  }) async {
    try {
      final day = end ?? DateTime.now();
      final response = await _client.get(
        '/api/har/trends',
        queryParameters: {
          'days': days,
          'timezone': timezone,
          'end':
              '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}',
        },
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return WeeklyHealthOverview.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<List<ServerPrediction>> predictions({required String token}) async {
    try {
      final response = await _client.get(
        '/api/har/predictions',
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return _parsePredictions(response.data);
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<List<ServerPrediction>> refreshPredictions({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        '/api/har/predictions',
        queryParameters: const {'refresh': 'true'},
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return _parsePredictions(response.data);
    } on DioException catch (error) {
      final code = error.response?.statusCode;
      if (code == 404 || code == 405) {
        try {
          final response = await _client.post(
            '/api/har/predictions',
            data: const {},
            options: Options(headers: {'X-Auth-Token': token}),
          );
          return _parsePredictions(response.data);
        } on DioException catch (postError) {
          throw AppException.fromDioException(postError);
        }
      }
      throw AppException.fromDioException(error);
    }
  }

  List<ServerPrediction> _parsePredictions(dynamic data) {
    final items = data as List;
    return [
      for (final item in items)
        ServerPrediction.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<MotionStoreResult> uploadMotionSamples({
    required String token,
    required List<MotionSample> samples,
  }) async {
    if (samples.isEmpty) {
      return const MotionStoreResult(accepted: 0, pruned: 0, sampleCount: 0);
    }
    try {
      final response = await _client.post(
        '/api-har/samples',
        data: {
          'samples': [for (final sample in samples) sample.toJson()],
        },
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return MotionStoreResult.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<MotionStoreResult> motionStats({required String token}) async {
    try {
      final response = await _client.get(
        '/api-har/samples',
        queryParameters: {'limit': 1},
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return MotionStoreResult.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<MotionPrediction> predictCurrentWindow({required String token}) async {
    try {
      final response = await _client.post(
        '/api-har/predict-current',
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return MotionPrediction.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<PatientProfile> fetchProfile({required String token}) async {
    try {
      final response = await _client.get(
        '/api/profile',
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return PatientProfile.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }

  Future<PatientProfile> updateProfile({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _client.put(
        '/api/profile',
        data: body,
        options: Options(headers: {'X-Auth-Token': token}),
      );
      return PatientProfile.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }
}
