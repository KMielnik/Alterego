import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/models/identity/authentication_response.dart';
import 'package:alterego/models/identity/register_request.dart';

abstract class IUserApiClient {
  Future<AuthenticationResponse> authenticate({AuthenticationRequest request});
  Future<void> register({RegisterRequest request});
  Future<void> logout();
}
