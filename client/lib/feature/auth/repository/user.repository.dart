import 'dart:io';
import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/feature/auth/models/auth.response.model.dart';
import 'package:client/feature/auth/models/auth.scheme.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UserRepository {
  UserRepository({required this._client});

  final Dio _client;

  Future<AuthResponseModel> getOne(String email, String password) async {
    try {
      final res = await _client.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      if (res.statusCode == 200) {
        return AuthResponseModel(
          token: res.data['token'],
          data: UserModel(
            name: res.data['name'],
            email: res.data['email'],
            mobnum: res.data['mobnum'],
            password: res.data['password'],
          ),
        );
      }
      throw AppException.fromCode(res);
    } on SocketException catch (e) {
      throw UnknownException(code: e.address.hashCode, details: e.message);
    } on WebSocketException catch (e) {
      throw UnknownException(code: e.httpStatusCode, details: e.message);
    }
  }

  Future<RequestStatus> addOne(UserModel data) async {
    try {
      debugPrint(data.toJson().toString());
      final res = await _client.post('/register', data: data.toJson());
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
}

enum RequestStatus { successful, failed }
