import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  const AppException({
    required this._message,
    this._code,
    this._details,
  });

  final String _message;
  final int? _code;
  final dynamic _details;

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
          message: response.statusMessage ?? 'Server error. Please try again later.',
          details: response.data,
        );

      default:
        return NetworkException(details: response.data);
    }
  }

  @override
  String toString() {
    return "message: $_message,\ncode: $_code,\ndetails: $_details";
  }
}