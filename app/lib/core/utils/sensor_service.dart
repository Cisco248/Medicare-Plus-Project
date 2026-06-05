import 'dart:math';
import 'package:app/data/models/sensor_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  Stream<SensorDataModel> accelerometerData() {
    return accelerometerEventStream().map(
      (event) => SensorDataModel(
        timestamp: event.timestamp,
        x: event.x,
        y: event.y,
        z: event.z,
      ),
    );
  }
}
