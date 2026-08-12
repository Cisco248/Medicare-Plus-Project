import 'package:client/core/exceptions/base.exception.dart';

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection.',
    super.code,
    super.details,
  });
}

final class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'The request timed out.',
    super.code,
    super.details,
  });
}

final class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Something went wrong. Please try again.',
    super.code,
    super.details,
  });
}