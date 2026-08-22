import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/health_summary.model.dart';
import 'package:dio/dio.dart';

class RagService {
  RagService({required this._client});

  final Dio _client;

  Future<HealthSummaryResponse> generateHealthSummary(
    HealthSummaryRequest request, {
    String? token,
  }) async {
    try {
      final response = await _client.post<Object?>(
        '/api/knowledge',
        data: request.toJson(),
        options: token == null
            ? null
            : Options(headers: {'x_auth_token': token}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AppException.fromCode(response);
      }
      return _parse(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  HealthSummaryResponse _parse(Object? data) {
    if (data is! Map<String, Object?>) {
      throw const ValidationException(
        message: 'The summary service returned an unexpected response.',
      );
    }
    try {
      return HealthSummaryResponse.fromJson(data);
    } on Object catch (e) {
      throw ValidationException(
        message: 'The summary service returned an unexpected response.',
        details: e,
      );
    }
  }

  AppException _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException(details: exception.message);
      case DioExceptionType.badResponse:
        final response = exception.response;
        if (response != null) return AppException.fromCode(response);
        return NetworkException(details: exception.message);
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return NetworkException(details: exception.message);
    }
  }
}
