import 'package:client/feature/auth/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UserRepository {
  final Dio _client;
  final bool device;

  UserRepository({Dio? client})
    : _client =
          client ??
          Dio(
            BaseOptions(
              baseUrl: 'http://10.0.2.2:8080/api',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          ),
      device = false;

  Future<String> getOne(String email, String password) async {
    try {
      final response = await _client.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return response.data.toString();
    } on DioException catch (e) {
      final message =
          'Status: ${e.response?.statusCode}, Message: ${e.message}';
      throw Exception('Login failed: $message');
    }
  }

  Future addOne(UserModel data) async {
    try {
      debugPrint(data.toJson().toString());
      final response = await _client.post('/register', data: data.toJson());
      return response.data;
    } on DioException catch (e) {
      final message =
          'Status: ${e.response?.statusCode}, Message: ${e.message}';
      throw Exception('Registration failed: $message');
    }
  }
}
