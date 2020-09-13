import 'package:alterego/exceptions/app_exception.dart';
import 'package:meta/meta.dart';

class ParameterEmptyException extends AppException {
  ParameterEmptyException({@required message})
      : super(prefix: "Parameter cannot be empty", message: message);
}
