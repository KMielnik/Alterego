import 'dart:convert';
import 'dart:io';

import 'package:alterego/models/api_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

class AlterEgoHTTPClient {
  static const _tokenKey = "token";
  static const _baseUrl = r"https://192.168.0.100/api/";

  final _storage = FlutterSecureStorage();
  final _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 3)
    ..badCertificateCallback = (_, __, ___) => true;

  Future<void> persistToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  String _getFullApiPath(
      {@required String endpoint, Map<String, dynamic> parameters}) {
    var parametersString =
        parameters == null ? '' : '?${Uri(queryParameters: parameters).query}';

    return p.join(_baseUrl, endpoint, parametersString);
  }

  Future<ApiResponse> get(
      {@required String path, Map<String, dynamic> parameters}) async {
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

  Future<ApiResponse> post(
      {@required String path, @required String body}) async {
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

  Future<ApiResponse> patch(
      {@required String path, Map<String, dynamic> parameters}) async {
    var fullPath = _getFullApiPath(endpoint: path, parameters: parameters);

    var request = await _client.patchUrl(Uri.parse(fullPath));

    var headers = await _getAuthorizedHeader();
    headers.forEach((key, value) => request.headers.add(key, value));

    var response = await request.close();

    var buffer = StringBuffer();

    await for (var chunk in response.transform(utf8.decoder))
      buffer.write(chunk);

    return ApiResponse(
        statusCode: response.statusCode, body: buffer.toString());
  }

  Future<ApiResponse> download(
      {@required String path,
      @required String filepath,
      @required String filename}) async {
    var fullPath = p.join(_getFullApiPath(endpoint: path), filename, "file");

    var request = await _client.getUrl(Uri.parse(fullPath));

    var headers = await _getAuthorizedHeader();
    headers.forEach((key, value) => request.headers.add(key, value));

    var response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      var file = File(p.join(filepath, filename));
      if (await file.exists()) await file.delete();

      file = await file.create(recursive: true);

      await for (var chunk in response) {
        await file.writeAsBytes(
          chunk,
          mode: FileMode.writeOnlyAppend,
        );
      }
      return ApiResponse(statusCode: response.statusCode, body: file.path);
    }

    return ApiResponse(statusCode: response.statusCode, body: "");
  }

  Future<ApiResponse> upload(
      {@required String path,
      @required List<int> body,
      @required String contentType}) async {
    throw UnimplementedError();
    var fullPath = _getFullApiPath(endpoint: path);

    var request = await _client.postUrl(Uri.parse(fullPath));

    var headers = await _getAuthorizedHeader();
    headers.forEach((key, value) => request.headers.add(key, value));
    request.headers.add("Content-Type", contentType);

    request.contentLength = body.length;
    request.add(body);

    var response = await request.close();

    var buffer = StringBuffer();

    await for (var chunk in response.transform(utf8.decoder))
      buffer.write(chunk);

    return ApiResponse(
        statusCode: response.statusCode, body: buffer.toString());
  }

  Future<Map<String, String>> _getAuthorizedHeader() async {
    var token = await _storage.read(key: _tokenKey);

    return <String, String>{"Authorization": "Bearer $token"};
  }
}
