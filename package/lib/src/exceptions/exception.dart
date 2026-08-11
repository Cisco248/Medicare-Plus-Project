library;

export 'package:flutter_health_connect/src/exceptions/exception.dart';

/// [HealthConnectException] is a base sealed exception for all Health Connect plugin failures.
/// Base sealed exception for all Health Connect plugin failures.
///
/// Creates an exception with a human-readable [message] and optional [code].
///
/// - Human-readable description of the failure.
/// - Stable machine-readable error code from the platform bridge.
/// - Optional platform details (never contains health record payloads).
sealed class HealthConnectException implements Exception {
  const HealthConnectException(this.message, {this.code, this.details});
  final String message;
  final String? code;
  final Object? details;

  @override
  String toString() =>
      '$runtimeType(${code != null ? '[$code] ' : ''}$message)';
}

/// Health Connect is not available on this device. Creates an [HealthConnectUnavailableException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectUnavailableException extends HealthConnectException {
  const HealthConnectUnavailableException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Health Connect provider APK is not installed or needs an update.
/// Creates an [HealthConnectNotInstalledException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectNotInstalledException extends HealthConnectException {
  const HealthConnectNotInstalledException(
    super.message, {
    super.code,
    super.details,
  });
}

/// The requested operation is missing required Health Connect permissions.
/// Creates an [HealthConnectPermissionException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectPermissionException extends HealthConnectException {
  const HealthConnectPermissionException(
    super.message, {
    super.code,
    super.details,
  });
}

/// A security or authorization failure occurred.
/// Creates an [HealthConnectSecurityException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectSecurityException extends HealthConnectException {
  const HealthConnectSecurityException(
    super.message, {
    super.code,
    super.details,
  });
}

/// A record read/write/delete operation failed.
/// Creates an [HealthConnectRecordException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectRecordException extends HealthConnectException {
  const HealthConnectRecordException(
    super.message, {
    super.code,
    super.details,
  });
}

/// An aggregation operation failed.
/// Creates an [HealthConnectAggregationException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectAggregationException extends HealthConnectException {
  const HealthConnectAggregationException(
    super.message, {
    super.code,
    super.details,
  });
}

/// A changes-token / incremental sync operation failed.
/// Creates an [HealthConnectChangesException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectChangesException extends HealthConnectException {
  const HealthConnectChangesException(
    super.message, {
    super.code,
    super.details,
  });
}

/// The provided time range is invalid (for example start >= end).
/// Creates an [HealthConnectInvalidTimeRangeException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectInvalidTimeRangeException extends HealthConnectException {
  const HealthConnectInvalidTimeRangeException(
    super.message, {
    super.code,
    super.details,
  });
}

/// The requested record type is not supported by this plugin version.
/// Creates an [HealthConnectUnsupportedRecordException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectUnsupportedRecordException extends HealthConnectException {
  const HealthConnectUnsupportedRecordException(
    super.message, {
    super.code,
    super.details,
  });
}

/// An unexpected or unclassified platform failure.
/// Creates an [HealthConnectUnknownException] exception.
///
/// - [message] - Human-readable description of the failure.
/// - [code] - Stable machine-readable error code from the platform bridge.
/// - [details] - Optional platform details (never contains health record payloads).
class HealthConnectUnknownException extends HealthConnectException {
  const HealthConnectUnknownException(
    super.message, {
    super.code,
    super.details,
  });
}
