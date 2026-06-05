import 'dart:convert';
import 'package:app/data/models/activity_model.dart';
import 'package:http/http.dart';

class ActivityRepository {
  final client = Client();
  ActivityRepository();

  Future addData(ActivityModel activity) async {
    try {
      final response = await client.post(
        Uri.http('10.0.2.2:8000', '/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "acc_x_value": activity.accXValue,
          "acc_y_value": activity.accYValue,
          "acc_z_value": activity.accZValue,
          "gyro_x_value": activity.gyroXValue,
          "gyro_y_value": activity.accYValue,
          "gyro_z_value": activity.gyroZValue,
        }),
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future getData() async {
    try {
      final response = await client.get(
        Uri.http('10.0.2.2:8000', '/api/har_data'),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
