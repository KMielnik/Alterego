import 'package:alterego/blocs/settings/settings_repository.dart';
import 'package:alterego/models/api_response.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:meta/meta.dart';

class AlterEgoHTTPClient {
  final SettingsRepository settings;

  final _client;

  AlterEgoHTTPClient(this.settings)
      : _client = Dio(
          BaseOptions(
            baseUrl: settings.serverAdress,
            validateStatus: (status) => true,
          ),
        ) {
    (_client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) => client..badCertificateCallback = (cert, host, port) => true;
  }

  Future<void> persistToken(String token) async {
    _client.options.headers.putIfAbsent("Authorization", () => "Bearer $token");
  }

  Future<void> logout() async {
    _client.options.headers.remove("Authorization");
  }

  Future<ApiResponse> get(
      {@required String path, Map<String, dynamic> parameters}) async {
    var response = await _client.get<String>(path, queryParameters: parameters);

    return ApiResponse(statusCode: response.statusCode, body: response.data);
  }

  Future<ApiResponse> post(
      {@required String path, @required String body}) async {
    var response = await _client.post<String>(path, data: body);

    return ApiResponse(statusCode: response.statusCode, body: response.data);
  }

  Future<ApiResponse> patch(
      {@required String path, Map<String, dynamic> parameters}) async {
    var response = await _client.patch<String>(path);

    return ApiResponse(statusCode: response.statusCode, body: response.data);
  }

  Future<ApiResponse> download(
      {@required String path,
      @required String filepath,
      @required String filename}) async {
    final fullPath = p.join(path, filename, "file");
    final fullFilePath = p.join(filepath, filename);

    var response = await _client.download(fullPath, fullFilePath);

    return ApiResponse(statusCode: response.statusCode, body: fullFilePath);
  }

  Future<ApiResponse> upload(
      {@required String path,
      @required String filepath,
      @required String filename}) async {
    var formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(filepath, filename: filename)});

    var response = await _client.post<String>(path,
        data: formData, options: Options(contentType: "multipart/form-data"));

    return ApiResponse(statusCode: response.statusCode, body: response.data);
  }
}
