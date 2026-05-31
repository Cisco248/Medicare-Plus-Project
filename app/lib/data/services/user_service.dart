import 'package:app/data/models/user_model.dart';
import 'package:app/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserService {
  static final repo = UserRepository();

  static Future<String> loginService(String email, String password) async {
    try {
      final response = await repo.getOneUserRepository(email, password);
      final user = response['user'];
      final token = response['token'];

      if (token == null || user == null) {
        if (kDebugMode) print("Login Failed: ${user['email']}");
        throw Exception('Token or User not found! Login failed');
      }

      if (kDebugMode) print("Login success: ${user['email']}");

      return 'Login Successfully -> Email: ${user['email']}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  static Future<String> registerService(
    String name,
    String email,
    String mobile,
    String password,
  ) async {
    try {
      final data = UserModel(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      final repsonse = await repo.addUserRepository(data);
      return 'Successfully Registered -> ${repsonse['email']}';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
