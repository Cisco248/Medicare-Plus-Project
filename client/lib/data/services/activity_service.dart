// import 'dart:io';
// import 'package:app/data/models/sensor_model.dart';
// import 'package:app/data/repository/activity_repository.dart';
// import 'package:flutter/foundation.dart';

// class ActivityService {
//   static final repo = ActivityRepository();

//   static Future setData(SensorDataModel data) async {
//     try {
//       return await repo.addData(data);
//     } catch (e) {
//       return HttpException('Service Error: $e');
//     }
//   }

//   static Future<void> getData() async {
//     try {
//       final response = await repo.getData();
//       if (kDebugMode) print(response);
//     } catch (e) {
//       HttpException('Connection Error: $e');
//     }
//   }
// }
