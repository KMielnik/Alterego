import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ApiResponse extends Equatable {
  final int statusCode;
  final String body;

  ApiResponse({@required this.statusCode, @required this.body});

  @override
  List<Object> get props => [statusCode, body];
}
