import 'package:alterego/exceptions/app_exception.dart';
import 'package:meta/meta.dart';

class BadRequestException extends AppException {
  BadRequestException({@required message})
      : super(prefix: "Invalid request", message: message);
}

class AlreadyExistsException extends AppException {
  AlreadyExistsException({@required message})
      : super(prefix: "Content already exists", message: message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException({@required message})
      : super(prefix: "Unauthorized", message: message);
}

class ResourceDoesntExistException extends AppException {
  ResourceDoesntExistException({@required message})
      : super(prefix: "Resource doesn't exist", message: message);
}
