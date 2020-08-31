import 'dart:convert';
import 'dart:io';

import 'package:alterego/models/api_response.dart';
import 'package:alterego/models/identity/authentication_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

class AlterEgoHTTPClient {
  static const _tokenKey = "token";
  static const _baseUrl = r"https://10.0.2.2:5001/api/";

  final _storage = FlutterSecureStorage();
  final _client = new HttpClient()
    ..badCertificateCallback = (_, __, ___) => true;

  Future persistToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future logout() async {
    await _storage.delete(key: _tokenKey);
  }

  String _getFullApiPath({String endpoint, Map<String, dynamic> parameters}) {
    var parametersString =
        parameters == null ? '' : '?${Uri(queryParameters: parameters).query}';

    return _baseUrl + endpoint + parametersString;
  }

  Future<ApiResponse> get(
      {String path, Map<String, dynamic> parameters}) async {
    var fullPath = _getFullApiPath(endpoint: path, parameters: parameters);

    var request = await _client.getUrl(Uri.parse(fullPath));

    var headers = await _getAuthorizedHeader();
    headers.forEach((key, value) => request.headers.add(key, value));

    var response = await request.close();

    var buffer = StringBuffer();

    await for (var chunk in response.transform(utf8.decoder))
      buffer.write(chunk);

    return ApiResponse(
        statusCode: response.statusCode, body: buffer.toString());
  }

  Future<ApiResponse> post({String path, String body}) async {
    var fullPath = _getFullApiPath(endpoint: path);

    var request = await _client.postUrl(Uri.parse(fullPath));

    var headers = await _getAuthorizedHeader();
    headers.forEach((key, value) => request.headers.add(key, value));
    request.headers.add("Content-Type", "application/json");

    request.contentLength = body.length;
    request.write(body);

    var response = await request.close();

    var buffer = StringBuffer();

    await for (var chunk in response.transform(utf8.decoder))
      buffer.write(chunk);

    return ApiResponse(
        statusCode: response.statusCode, body: buffer.toString());
  }

  Future<File> download({String path, String filepath, String filename}) async {
    var fullPath = _getFullApiPath(endpoint: path) + "/$filename";

    var request = await _client.getUrl(Uri.parse(fullPath));

    var headers = await _getAuthorizedHeader();
    headers.forEach((key, value) => request.headers.add(key, value));

    var response = await request.close();

    var file = File(path + "/" + filename);

    await for (var chunk in response) {
      await file.writeAsBytes(chunk);
    }
    return file;
  }

  Future<Map<String, String>> _getAuthorizedHeader() async {
    var token = await _storage.read(key: _tokenKey);

    return <String, String>{"Authorization": "Bearer $token"};
  }
}
