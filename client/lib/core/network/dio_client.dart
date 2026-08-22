import 'package:client/core/network/api_endpoint.dart';
import 'package:dio/dio.dart';

Dio client() => Dio(
  BaseOptions(
    baseUrl: '${ApiEndpoints.baseUrl}:8080',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 120),
    headers: {'Content-Type': 'application/json'},
  ),
);

Dio ragClient() => Dio(
  BaseOptions(
    baseUrl: '${ApiEndpoints.baseUrl}:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 120),
    headers: {'Content-Type': 'application/json'},
  ),
);
