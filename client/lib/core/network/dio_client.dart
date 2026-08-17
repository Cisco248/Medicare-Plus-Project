import 'package:client/core/network/api_endpoint.dart';
import 'package:dio/dio.dart';

Dio client(int port) => Dio(
  BaseOptions(
    baseUrl: '${ApiEndpoints.baseUrl}:$port/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 120),
    headers: {'Content-Type': 'application/json'},
  ),
);
