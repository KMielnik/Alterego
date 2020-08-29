import 'package:meta/meta.dart';

class AuthenticationRequest {
  String login;
  String password;

  AuthenticationRequest({@required this.login, @required this.password});

  AuthenticationRequest.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    return data;
  }
}
