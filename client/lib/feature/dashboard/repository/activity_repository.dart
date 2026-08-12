import 'dart:core';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
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
      throw NotFoundException(details: e);
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
        throw NotFoundException(
          message: 'Your record is empty, Try again later!',
          details: res,
        );
      }
      return res;
    } catch (e) {
      throw UnknownException(details: e);
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
        throw NotFoundException(
          message: 'Your record is empty, Try again later!',
          details: res,
        );
      }
      return res;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }

  Future<DailySummary> dailySummary() async {
    try {
      final res = await _sdk.getDailyHealthSummary(
        date: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
      );
      return res;
    } catch (e) {
      throw UnknownException(details: e);
    }
  }
}
