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
    baseUrl: 'http://192.168.2.49:$port/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ),
);

/// Base URL override for the RAG service, supplied at build time via
/// `--dart-define=RAG_BASE_URL=http://host:8000/api`. Never commit secrets.
const String _ragBaseUrlOverride = String.fromEnvironment('RAG_BASE_URL');

/// Dio client for the RAG backend (port 8000 by default).
///
/// Uses a longer receive timeout than the regular clients because LLM
/// generation can take significantly longer than a CRUD request.
Dio ragClient() => Dio(
  BaseOptions(
    baseUrl: _ragBaseUrlOverride.isNotEmpty
        ? _ragBaseUrlOverride
        : 'http://192.168.2.49:8000/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 120),
    headers: {'Content-Type': 'application/json'},
  ),
);
