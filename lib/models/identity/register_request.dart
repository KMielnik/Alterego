import 'package:meta/meta.dart';

class RegisterRequest {
  String login;
  String password;
  String email;
  String nickname;

  RegisterRequest(
      {@required this.login,
      @required this.password,
      @required this.email,
      @required this.nickname});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    password = json['password'];
    email = json['email'];
    nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    data['email'] = this.email;
    data['nickname'] = this.nickname;
    return data;
  }
}
