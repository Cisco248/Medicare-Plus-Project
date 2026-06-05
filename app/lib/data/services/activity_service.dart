import 'dart:io';
import 'package:app/data/models/activity_model.dart';
import 'package:app/data/repository/activity_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ActivityService {
  static final repo = ActivityRepository();

  static Future<void> setData(Map<String, double> data) async {
    try {
      if (data.isEmpty) throw ClientException('Data is Empty');

      final response = await repo.addData(ActivityModel.fromMap(data));
      if (kDebugMode) print(response);
    } catch (e) {
      HttpException('Connection Error: $e');
    }
  }

  static Future<void> getData() async {
    try {
      final response = await repo.getData();
      if (kDebugMode) print(response);
    } catch (e) {
      HttpException('Connection Error: $e');
    }
  }
}
