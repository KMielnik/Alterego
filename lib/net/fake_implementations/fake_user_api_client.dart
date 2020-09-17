import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/models/identity/register_request.dart';
import 'package:alterego/models/identity/authentication_response.dart';
import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';

class FakeUserApiClient implements IUserApiClient {
  @override
  Future<AuthenticationResponse> authenticate(
      {AuthenticationRequest request}) async {
    await Future.delayed(Duration(seconds: 1));

    if (request.login.isEmpty || request.password.isEmpty)
      throw BadRequestException(message: "Invalid login or password (empty)");

    return AuthenticationResponse(
      login: request.login,
      email: "${request.login}@gmail.com",
      nickname: "${request.login}IsCool",
      jwToken: JwToken(
        token: "",
        expires: DateTime.parse("2050-05-05 12:05:45.123"),
      ),
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({RegisterRequest request}) async {
    if (request.login.isEmpty || request.password.isEmpty)
      throw BadRequestException(
          message: "Invalid fakeregister (login/password cannot be empty).");

    await Future.delayed(Duration(seconds: 2));
  }
}
