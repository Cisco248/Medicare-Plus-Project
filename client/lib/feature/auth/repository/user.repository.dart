import 'dart:io';
import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:dio/dio.dart';

class UserRepository {
  UserRepository({required this._client});

  final Dio _client;

  Future<AuthResponseModel> getOne(String email, String password) async {
    try {
      final res = await _client.post(
        '/api/login',
        data: {'email': email, 'password': password},
      );
      if (res.statusCode == 200) {
        return AuthResponseModel(
          token: res.data['token'],
          id: res.data['id'],
          name: res.data['name'],
          email: res.data['email'],
          mobnum: res.data['mobnum'],
          password: res.data['password'],
        );
      }
      throw AppException.fromCode(res);
    } on SocketException catch (e) {
      throw UnknownException(code: e.address.hashCode, details: e.message);
    } on WebSocketException catch (e) {
      throw UnknownException(code: e.httpStatusCode, details: e.message);
    }
  }

  Future<RequestStatus> addOne(AuthRequestModel data) async {
    try {
      final res = await _client.post('/api/register', data: data.toJson());
      if (res.statusCode == 200 || res.statusCode == 201) {
        return RequestStatus.successful;
      }
      AppException.fromCode(res);
      return RequestStatus.failed;
    } on SocketException catch (e) {
      throw UnknownException(code: e.address.hashCode, details: e.message);
    } on WebSocketException catch (e) {
      throw UnknownException(code: e.httpStatusCode, details: e.message);
    }
  }

  Future<AuthResponseModel> profile(String userId, String token) async {
    try {
      final res = await _client.post(
        "/api/profile",
        queryParameters: {"userId": userId},
        options: Options(headers: {"X-Auth-Token": token}),
      );
      if (res.statusCode == 200) {
        return AuthResponseModel(
          token: res.data['token'],
          id: res.data["id"],
          name: res.data["name"],
          email: res.data["email"],
          mobnum: res.data["mobnum"],
          password: res.data["password"],
        );
      }
      throw AppException.fromCode(res);
    } on SocketException catch (e) {
      throw UnknownException(code: e.address.hashCode, details: e.message);
    } on WebSocketException catch (e) {
      throw UnknownException(code: e.httpStatusCode, details: e.message);
    }
  }
}
