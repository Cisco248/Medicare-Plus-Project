import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/data/models/user_model.dart';

class UserRepository {
  final client = Client();
  UserRepository();

  Future getOneUserRepository(String email, String password) async {
    try {
      final response = await client.post(
        Uri.http('10.0.2.2:8000', '/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future addUserRepository(UserModel data) async {
    try {
      final response = await client.post(
        Uri.http('10.0.2.2:8000', '/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": data.name,
          "email": data.email,
          "mobnum": data.mobile,
          "password": data.password,
        }),
      );

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future deleteUserRepository(String value, String parameter) async {}

  // Future updateUserRepository(String value, UserEntity data) async {}
}
