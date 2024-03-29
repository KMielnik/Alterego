import 'dart:convert';
import 'dart:io';

import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/models/identity/authentication_response.dart';
import 'package:alterego/models/identity/register_request.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'alterego_httpclient.dart';

class UserApiClient implements IUserApiClient {
  final AlterEgoHTTPClient client;

  static const String _authenticationPath = "Account/authenticate";
  static const String _registrationPath = "Account/register";

  static const String _credentialsKey = "CREDENTIALS_KEY";

  final _storage = FlutterSecureStorage();

  UserApiClient({@required this.client});

  Future<AuthenticationResponse> tryAuthenticateWithSavedCredentials() async {
    try {
      var requestJSON = jsonDecode(await _storage.read(key: _credentialsKey));
      var request = AuthenticationRequest.fromJson(requestJSON);
      var response = await authenticate(request: request);

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<AuthenticationResponse> authenticate(
      {AuthenticationRequest request}) async {
    var body = jsonEncode(request);
    var response = await client.post(path: _authenticationPath, body: body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        await _storage.write(
          key: _credentialsKey,
          value: jsonEncode(request.toJson()),
        );

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

  Future<void> register({RegisterRequest request}) async {
    var body = jsonEncode(request);
    var response = await client.post(path: _registrationPath, body: body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        break;

      case HttpStatus.conflict:
        throw AlreadyExistsException(message: response.body);
    }
  }

  Future<void> logout() async {
    await client.logout();
    await _storage.delete(key: _credentialsKey);
  }
}
