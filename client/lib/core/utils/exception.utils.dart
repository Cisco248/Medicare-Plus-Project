import 'package:dio/dio.dart';

class BaseException extends DioException {
  BaseException({
    required super.requestOptions,
    int? statusCode,
    super.error,
    super.message,
  }) : super(
         type: _getType(statusCode),
         response: statusCode == null
             ? null
             : Response(requestOptions: requestOptions, statusCode: statusCode),
       );

  static DioExceptionType _getType(int? statusCode) {
    if (statusCode == null) {
      return DioExceptionType.unknown;
    }

    return switch (statusCode) {
      400 => DioExceptionType.badResponse,
      401 => DioExceptionType.badCertificate,
      403 => DioExceptionType.badResponse,
      404 => DioExceptionType.badResponse,
      408 => DioExceptionType.connectionTimeout,
      500 => DioExceptionType.badResponse,
      502 => DioExceptionType.badResponse,
      503 => DioExceptionType.badResponse,
      _ => DioExceptionType.unknown,
    };
  }
}
