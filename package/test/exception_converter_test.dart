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
  });
}
