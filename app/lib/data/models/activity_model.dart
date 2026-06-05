import 'package:app/data/entity/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  ActivityModel({
    super.accXValue,
    super.accYValue,
    super.accZValue,
    super.gyroXValue,
    super.gyroYValue,
    super.gyroZValue,
  });

  Map<String, double> toMap() => {
    "acc_x_value": accXValue ?? 0 as double,
    "acc_y_value": accYValue ?? 0 as double,
    "acc_z_value": accZValue ?? 0 as double,
    "gyro_x_value": gyroXValue ?? 0 as double,
    "gyro_y_value": gyroYValue ?? 0 as double,
    "gyro_z_value": gyroZValue ?? 0 as double,
  };

  List<double?> toList() => [
    accXValue ?? 0 as double,
    accZValue ?? 0 as double,
    accZValue ?? 0 as double,
    gyroXValue ?? 0 as double,
    gyroYValue ?? 0 as double,
    gyroZValue ?? 0 as double,
  ];

  static ActivityModel fromMap(Map<String, double?> data) => ActivityModel(
    accXValue: data['acc_x_value'] ?? 0,
    accYValue: data['acc_y_value'] ?? 0,
    accZValue: data['acc_z_value'] ?? 0,
    gyroXValue: data['gyro_x_value'] ?? 0,
    gyroYValue: data['gyro_y_value'] ?? 0,
    gyroZValue: data['gyro_z_value'] ?? 0,
  );

  static ActivityModel fromList(List<double?> data) => ActivityModel(
    accXValue: data[0] ?? 0,
    accYValue: data[1] ?? 0,
    accZValue: data[2] ?? 0,
    gyroXValue: data[3] ?? 0,
    gyroYValue: data[4] ?? 0,
    gyroZValue: data[5] ?? 0,
  );

  @override
  String toString() {
    return "ActivityModel(accXValue: $accXValue, accYValue: $accYValue, accZValue: $accZValue, gyroXValue: $gyroXValue, gyroYValue: $gyroYValue, gyroZValue: $gyroZValue)";
  }
}
