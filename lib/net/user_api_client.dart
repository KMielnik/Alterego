import 'dart:convert';
import 'dart:io';

import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/models/identity/authentication_response.dart';
import 'package:alterego/models/identity/register_request.dart';
import 'package:alterego/net/alterego_httpclient.dart';
import 'package:meta/meta.dart';

class UserApiClient {
  final AlterEgoHTTPClient client;

  static const String _authenticationPath = "Account/authenticate";
  static const String _registrationPath = "Account/register";

  UserApiClient({@required this.client});

  Future<AuthenticationResponse> authenticate(
      {AuthenticationRequest request}) async {
    var body = jsonEncode(request);
    var response = await client.post(path: _authenticationPath, body: body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        var responseObject =
            AuthenticationResponse.fromJson(jsonDecode(response.body));

        client.persistToken(responseObject.jwToken.token);
        return responseObject;

      case HttpStatus.badRequest:
        throw BadRequestException(message: response.body);
        break;

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }

  Future register({RegisterRequest request}) async {
    var body = jsonEncode(request);
    var response = await client.post(path: _registrationPath, body: body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        break;

      case HttpStatus.conflict:
        throw AlreadyExistsException(message: response.body);
    }
  }

  Future logout() async => await client.logout();
}
