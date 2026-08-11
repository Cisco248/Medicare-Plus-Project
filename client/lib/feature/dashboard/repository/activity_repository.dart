import 'package:client/core/utils/exception.utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_health_connect/app.dart';

class ActivityRepository {
  final FlutterHealthConnect _sdk;

  ActivityRepository({FlutterHealthConnect? sdk})
    : _sdk = sdk ?? FlutterHealthConnect();

  final DateTime _startTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
  );
  final DateTime _endTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    23,
    59,
  );

  Future<void> initialized(List<Permission> permissions) async {
    try {
      await _sdk.initialize();
      await _sdk.checkPermissions(permissions);
    } catch (e) {
      throw BaseException(requestOptions: RequestOptions(), error: e);
    }
  }

  Future<List<StepsRecord>> footStep(List<Permission> permissions) async {
    try {
      await initialized(permissions);
      final res = await _sdk.readSteps(
        startTime: _startTime,
        endTime: _endTime,
      );
      if (res.isEmpty) {
        throw BaseException(
          requestOptions: RequestOptions(),
          error: res.toString(),
          message: "Record not found",
        );
      }
      return res;
    } catch (e) {
      throw BaseException(requestOptions: RequestOptions(), error: e);
    }
  }

  Future<List<TotalCaloriesBurnedRecord>> burnCalories(
    List<Permission> permissions,
  ) async {
    try {
      await initialized(permissions);
      final res = await _sdk.readTotalCaloriesBurned(
        startTime: _startTime,
        endTime: _endTime,
      );
      if (res.isEmpty) {
        throw BaseException(
          requestOptions: RequestOptions(),
          error: res.toString(),
          message: "Record not found",
        );
      }
      return res;
    } catch (e) {
      throw BaseException(requestOptions: RequestOptions(), error: e);
    }
  }

  Future<List<BloodPressureRecord>> bloodPressure(
    List<Permission> permissions,
  ) async {
    try {
      await initialized(permissions);
      final res = await _sdk.readBloodPressure(
        startTime: _startTime,
        endTime: _endTime,
      );
      if (res.isEmpty) {
        throw BaseException(
          requestOptions: RequestOptions(),
          error: res.toString(),
          message: "Record not found",
        );
      }
      return res;
    } catch (e) {
      throw BaseException(requestOptions: RequestOptions(), error: e);
    }
  }
}
