import 'package:flutter/services.dart';
import 'package:flutter_health_connect/src/exceptions/exception.dart';

/// Maps [PlatformException] codes to typed [HealthConnectException]s.
///
/// [ExceptionConverter] converts a caught error into a [HealthConnectException].
///
///  Converts a caught error into a [HealthConnectException].
///
/// - [error] - The error to convert.
/// - [stack] - The stack trace of the error.
///
/// Returns a [HealthConnectException] if the error is a [PlatformException] or a [HealthConnectException].

class ExceptionConverter {
  const ExceptionConverter._();

  static HealthConnectException fromError(Object error, [StackTrace? stack]) {
    if (error is HealthConnectException) return error;
    if (error is PlatformException) {
      final code = error.code;
      final message = error.message ?? 'Health Connect platform error.';
      final details = error.details;

      switch (code) {
        case 'unavailable':
          return HealthConnectUnavailableException(
            message,
            code: code,
            details: details,
          );
        case 'not_installed':
          return HealthConnectNotInstalledException(
            message,
            code: code,
            details: details,
          );
        case 'permission_denied':
        case 'permission':
          return HealthConnectPermissionException(
            message,
            code: code,
            details: details,
          );
        case 'security':
          return HealthConnectSecurityException(
            message,
            code: code,
            details: details,
          );
        case 'record':
          return HealthConnectRecordException(
            message,
            code: code,
            details: details,
          );
        case 'aggregation':
          return HealthConnectAggregationException(
            message,
            code: code,
            details: details,
          );
        case 'changes':
        case 'changes_token_expired':
          return HealthConnectChangesException(
            message,
            code: code,
            details: details,
          );
        case 'invalid_time_range':
          return HealthConnectInvalidTimeRangeException(
            message,
            code: code,
            details: details,
          );
        case 'unsupported_record':
          return HealthConnectUnsupportedRecordException(
            message,
            code: code,
            details: details,
          );
        default:
          return HealthConnectUnknownException(
            message,
            code: code,
            details: details,
          );
      }
    }

    return HealthConnectUnknownException(
      error.toString(),
      code: 'unknown',
      details: stack?.toString(),
    );
  }
}
