import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_health_connect/app.dart';

void main() {
  group('ExceptionConverter', () {
    test('maps known platform codes', () {
      expect(
        ExceptionConverter.fromError(
          PlatformException(code: 'not_installed', message: 'missing'),
        ),
        isA<HealthConnectNotInstalledException>(),
      );
      expect(
        ExceptionConverter.fromError(
          PlatformException(code: 'permission_denied', message: 'denied'),
        ),
        isA<HealthConnectPermissionException>(),
      );
      expect(
        ExceptionConverter.fromError(
          PlatformException(code: 'invalid_time_range', message: 'bad'),
        ),
        isA<HealthConnectInvalidTimeRangeException>(),
      );
      expect(
        ExceptionConverter.fromError(
          PlatformException(code: 'changes_token_expired', message: 'expired'),
        ),
        isA<HealthConnectChangesException>(),
      );
      expect(
        ExceptionConverter.fromError(
          PlatformException(code: 'unsupported_record', message: 'bmi'),
        ),
        isA<HealthConnectUnsupportedRecordException>(),
      );
    });

    test('maps unknown codes', () {
      expect(
        ExceptionConverter.fromError(
          PlatformException(code: 'something_else', message: 'x'),
        ),
        isA<HealthConnectUnknownException>(),
      );
    });

    // The core regression this suite guards: only the two codes the native
    // layer emits from an explicit getSdkStatus check may become availability
    // exceptions, because the app renders those as
    // "Health Connect is not available on this device" (404).
    test('only provider-status codes become availability exceptions', () {
      const availabilityCodes = {'unavailable', 'not_installed'};
      const otherCodes = [
        'client_initialization_failed',
        'provider_error',
        'io_error',
        'operation_failed',
        'cancelled',
        'plugin_detached',
        'permission_denied',
        'security',
        'no_activity',
        'intent_unavailable',
        'request_in_progress',
        'invalid_request',
        'unsupported_metric',
        'unsupported_operation',
        'invalid_time_range',
        'unsupported_record',
        'changes_token_expired',
      ];

      for (final code in otherCodes) {
        final mapped = ExceptionConverter.fromError(
          PlatformException(code: code, message: 'failure'),
        );
        expect(
          mapped,
          isNot(isA<HealthConnectUnavailableException>()),
          reason: '$code must not be reported as Health Connect unavailable',
        );
        expect(
          mapped,
          isNot(isA<HealthConnectNotInstalledException>()),
          reason: '$code must not be reported as Health Connect missing',
        );
      }

      for (final code in availabilityCodes) {
        expect(
          ExceptionConverter.fromError(
            PlatformException(code: code, message: 'missing'),
          ),
          anyOf(
            isA<HealthConnectUnavailableException>(),
            isA<HealthConnectNotInstalledException>(),
          ),
        );
      }
    });

    test('classifies provider-side failures as operation failures', () {
      for (final code in ['provider_error', 'io_error', 'operation_failed']) {
        expect(
          ExceptionConverter.fromError(
            PlatformException(code: code, message: 'boom'),
          ),
          isA<HealthConnectOperationException>(),
          reason: code,
        );
      }
    });

    test('classifies navigation failures separately from availability', () {
      for (final code in ['no_activity', 'intent_unavailable']) {
        expect(
          ExceptionConverter.fromError(
            PlatformException(code: code, message: 'cannot open'),
          ),
          isA<HealthConnectNavigationException>(),
          reason: code,
        );
      }
    });

    test('a missing native implementation means an unsupported platform', () {
      final mapped = ExceptionConverter.fromError(
        MissingPluginException('No implementation found'),
      );
      expect(mapped, isA<HealthConnectUnavailableException>());
      expect(mapped.code, 'unsupported_platform');
    });

    test('passes typed exceptions through unchanged', () {
      const original = HealthConnectPermissionException('denied');
      expect(identical(ExceptionConverter.fromError(original), original), isTrue);
    });
  });
}
