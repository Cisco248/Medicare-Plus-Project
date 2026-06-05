import 'package:app/data/entity/activity_entity.dart';

class SensorDataModel extends SensorData {
  SensorDataModel({
    required super.timestamp,
    required super.x,
    required super.y,
    required super.z,
  });

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp.toIso8601String(),
    "x": x,
    "y": y,
    "z": z,
  };

  List<dynamic> toList() => [timestamp.toIso8601String(), x, y, z];

  static SensorDataModel fromMap(Map<String, dynamic> data) => SensorDataModel(
    timestamp: data['timestamp'],
    x: data['x'],
    y: data['y'],
    z: data['z'],
  );

  static SensorDataModel fromList(List<dynamic> data) =>
      SensorDataModel(timestamp: data[0], x: data[1], y: data[2], z: data[3]);

  @override
  String toString() {
    return "SensorDataModel(Timestamp: $timestamp, X: $x, Y: $y, Z: $z)";
  }
}
