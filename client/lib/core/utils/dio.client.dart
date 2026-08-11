import 'package:dio/dio.dart';

Dio virtualDevice(int port) => Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:$port/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ),
);

Dio physicalDevice(int port) => Dio(
  BaseOptions(
    baseUrl: 'http://192.168.2.47:$port/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ),
);
