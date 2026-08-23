import 'package:client/core/network/api_endpoint.dart';
import 'package:dio/dio.dart';

/// Dio client for the server's `/api-base` prediction routes.
///
/// Kept inside E-Doc so the shared `/api` client is unchanged.
Dio eDocBaseModelClient() => Dio(
  BaseOptions(
    baseUrl: '${ApiEndpoints.baseUrl}:8080/api-base',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 120),
    headers: {'Content-Type': 'application/json'},
  ),
);
