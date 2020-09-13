import 'package:meta/meta.dart';

class AuthenticationResponse {
  String login;
  String email;
  String nickname;
  JwToken jwToken;

  AuthenticationResponse(
      {@required this.login,
      @required this.email,
      @required this.nickname,
      @required this.jwToken});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    email = json['email'];
    nickname = json['nickname'];
    jwToken =
        json['jwToken'] != null ? new JwToken.fromJson(json['jwToken']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['email'] = this.email;
    data['nickname'] = this.nickname;
    if (this.jwToken != null) {
      data['jwToken'] = this.jwToken.toJson();
    }
    return data;
  }
}

class JwToken {
  String token;
  DateTime expires;

  JwToken({this.token, this.expires});

  JwToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expires'] = this.expires;
    return data;
  }
}
