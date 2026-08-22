import 'package:flutter/services.dart';
import 'package:flutter_health_connect/src/exceptions/exception.dart';

/// Maps native failures onto the typed [HealthConnectException] hierarchy.
///
/// Only `unavailable` and `not_installed` become availability exceptions. The
/// native layer emits those two codes exclusively after an explicit
/// `HealthConnectClient.getSdkStatus` check, so every other failure keeps a
/// category that describes what actually went wrong instead of claiming Health
/// Connect is missing from the device.
class ExceptionConverter {
  const ExceptionConverter._();

  static HealthConnectException fromError(Object error, [StackTrace? stack]) {
    if (error is HealthConnectException) return error;

    // No native implementation is registered. This plugin is Android-only, so
    // on any other platform Health Connect is genuinely unavailable.
    if (error is MissingPluginException) {
      return HealthConnectUnavailableException(
        'Health Connect is only available on Android.',
        code: 'unsupported_platform',
        details: error.message,
      );
    }

    if (error is PlatformException) {
      final code = error.code;
      final message = error.message ?? 'Health Connect platform error.';
      final details = error.details;

      switch (code) {
        // Health Connect genuinely cannot serve this device. These are the only
        // two codes the native layer emits after an explicit `getSdkStatus`
        // check, so they are the only ones that mean "unavailable".
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

        // Health Connect is present but the call did not succeed.
        case 'client_initialization_failed':
        case 'provider_error':
        case 'io_error':
        case 'operation_failed':
        case 'cancelled':
        case 'plugin_detached':
          return HealthConnectOperationException(
            message,
            code: code,
            details: details,
          );

        case 'invalid_request':
        case 'unsupported_metric':
        case 'unsupported_operation':
          return HealthConnectInvalidRequestException(
            message,
            code: code,
            details: details,
          );

        case 'no_activity':
        case 'intent_unavailable':
          return HealthConnectNavigationException(
            message,
            code: code,
            details: details,
          );

        case 'request_in_progress':
          return HealthConnectPermissionException(
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
