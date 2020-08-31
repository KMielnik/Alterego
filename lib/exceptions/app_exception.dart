import 'package:flutter/cupertino.dart';

class AppException implements Exception {
  final message;
  final prefix;

  AppException({@required this.prefix, @required this.message});

  String toString() => "$prefix: $message";
}
