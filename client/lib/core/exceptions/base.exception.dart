import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  const AppException({required this._message, this._code, this._details});

  final String _message;
  final int? _code;
  final dynamic _details;

  /// User-presentable description of the failure (no raw stack traces).
  String get message => _message;

  int? get code => _code;

  dynamic get details => _details;

  factory AppException.fromCode(Response response) {
    switch (response.statusCode) {
      case 400:
        return ValidationException(
          message: response.statusMessage ?? "Invalid request",
          code: response.statusCode,
          details: response.data,
        );

      case 401:
        return UnauthorizedException(
          message: response.statusMessage ?? 'Please login again.',
          details: response.data,
        );

      case 403:
        return ForbiddenException(
          message: response.statusMessage ?? 'Access denied.',
          details: response.data,
        );

      case 404:
        return NotFoundException(
          message: response.statusMessage ?? 'Resource not found.',
          details: response.data,
        );

      case 422:
        return ValidationException(
          message: response.statusMessage ?? 'Please check the provided data.',
          details: response.data,
        );

      case 429:
        return ServerException(
          message: 'Too many requests. Please try again later.',
          code: response.statusCode,
          details: response.data,
        );

      case 500:
        return ServerException(
          message:
              response.statusMessage ?? 'Server error. Please try again later.',
          details: response.data,
        );

      default:
        return NetworkException(details: response.data);
    }
  }

  /// Maps a transport-level [DioException] to a user-presentable exception.
  factory AppException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException(details: exception.message);
      case DioExceptionType.badResponse:
        final response = exception.response;
        if (response != null) return AppException._fromResponse(response);
        return NetworkException(details: exception.message);
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return NetworkException(details: exception.message);
    }
  }

  /// Like [AppException.fromCode], but prefers the backend's `detail` field
  /// (FastAPI convention) which already contains a user-friendly message.
  factory AppException._fromResponse(Response response) {
    final data = response.data;
    final detail = (data is Map && data['detail'] is String)
        ? data['detail'] as String
        : null;
    if (detail == null || detail.isEmpty) return AppException.fromCode(response);

    switch (response.statusCode) {
      case 400:
      case 422:
        return ValidationException(
          message: detail,
          code: response.statusCode,
          details: data,
        );
      case 401:
        return UnauthorizedException(message: detail, details: data);
      case 403:
        return ForbiddenException(message: detail, details: data);
      case 404:
        return NotFoundException(message: detail, details: data);
      default:
        return ServerException(
          message: detail,
          code: response.statusCode,
          details: data,
        );
    }
  }

  @override
  String toString() {
    return "message: $_message,\ncode: $_code,\ndetails: $_details";
  }
}
