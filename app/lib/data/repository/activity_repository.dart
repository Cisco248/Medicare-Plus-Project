import 'dart:convert';
import 'package:app/data/models/sensor_model.dart';
import 'package:http/http.dart';

class ActivityRepository {
  final client = Client();
  ActivityRepository();

  Future addData(SensorDataModel data) async {
    try {
      final response = await client.post(
        Uri.http('10.0.2.2:8000', '/api-har/insert-data'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "timestamp": data.timestamp.toIso8601String(),
          "x": data.x,
          "y": data.y,
          "z": data.z,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Server Error: ${response.body}");
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future getData() async {
    try {
      final response = await client.get(
        Uri.http('10.0.2.2:8000', '/api-har/get-data'),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
