import 'package:client/core/exceptions/base.exception.dart';



final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Your session has expired.',
    super.code = 401,
    super.details,
  });
}

final class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.code = 403,
    super.details,
  });
}

final class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.code = 404,
    super.details,
  });
}


final class AlreadyExistsException extends AppException {
  const AlreadyExistsException({
    super.message = 'The resource already exists.',
    super.code = 409,
    super.details,
  });
}

final class ValidationException extends AppException {
  const ValidationException({
    super.message = 'The provided data is invalid.',
    super.code = 422,
    super.details,
  });
}

final class ServerException extends AppException {
  const ServerException({
    super.message = 'Something went wrong on the server.',
    super.code = 500,
    super.details,
  });
}

