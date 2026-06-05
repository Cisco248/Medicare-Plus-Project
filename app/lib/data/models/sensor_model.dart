import 'package:app/data/entity/activity_entity.dart';

class SensorDataModel extends SensorData {
  SensorDataModel({super.x, super.y, super.z});

  Map<String, double> toMap() => {
    "x": x ?? 0 as double,
    "y": y ?? 0 as double,
    "z": z ?? 0 as double,
  };

  List<double?> toList() => [
    x ?? 0 as double,
    y ?? 0 as double,
    z ?? 0 as double,
  ];

  static SensorDataModel fromMap(Map<String, double?> data) =>
      SensorDataModel(x: data['x'] ?? 0, y: data['y'] ?? 0, z: data['z'] ?? 0);

  static SensorDataModel fromList(List<double?> data) =>
      SensorDataModel(x: data[0] ?? 0, y: data[1] ?? 0, z: data[2] ?? 0);

  @override
  String toString() {
    return "SensorDataModel(accXValue: $x, accYValue: $y, accZValue: $z)";
  }
}
