import 'dart:convert';
import 'dart:io';

import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/exceptions/parameter_exceptions.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/implementations/alterego_httpclient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract class MediaApiClient implements IMediaApiClient {
  final AlterEgoHTTPClient client;

  final String mainPath;
  Future<String> mediaFolderPathFuture;

  MediaApiClient({@required this.client, @required this.mainPath}) {
    mediaFolderPathFuture = getApplicationDocumentsDirectory()
        .then((value) => path.join(value.path, mainPath));
  }

  @override
  Future<List<MediafileInfo>> getAll({bool includeThumbnails = true}) async {
    var parameters = <String, dynamic>{
      "includeThumbnails": includeThumbnails.toString()
    };
    var response = await client.get(path: mainPath, parameters: parameters);

    switch (response.statusCode) {
      case HttpStatus.ok:
        Iterable l = jsonDecode(response.body);
        var responseObject = List<Object>.from(l)
            .map((Object model) => MediafileInfo.fromJson(model))
            .toList();
        return responseObject;

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw UnauthorizedException(message: response.body);

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }

  @override
  Future<MediafileInfo> refreshLifetime({String filename}) async {
    if (filename.isEmpty)
      throw ParameterEmptyException(message: "filename parameter is empty.");

    var response = await client.patch(path: path.join(mainPath, filename));

    switch (response.statusCode) {
      case HttpStatus.ok:
        var responseObject = MediafileInfo.fromJson(jsonDecode(response.body));
        return responseObject;

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw UnauthorizedException(message: response.body);

      case HttpStatus.notFound:
        throw ResourceDoesntExistException(message: response.body);

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }

  @override
  Future delete({String filename}) async {
    if (filename.isEmpty)
      throw ParameterEmptyException(message: "filename parameter is empty.");

    var response =
        await client.patch(path: path.join(mainPath, filename, "delete"));

    switch (response.statusCode) {
      case HttpStatus.ok:
        return;

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw UnauthorizedException(message: response.body);

      case HttpStatus.notFound:
        throw ResourceDoesntExistException(message: response.body);

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }

  @override
  Future<String> downloadSpecified({@required String filename}) async {
    if (filename.isEmpty)
      throw ParameterEmptyException(message: "filename parameter is empty.");

    var response = await client.download(
        path: mainPath,
        filepath: await mediaFolderPathFuture,
        filename: filename);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return response.body;

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw UnauthorizedException(message: response.body);

      case HttpStatus.notFound:
        throw ResourceDoesntExistException(message: response.body);

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }

  @override
  Future<MediafileInfo> upload({String filename}) async {
    throw UnimplementedError();

    if (filename.isEmpty)
      throw ParameterEmptyException(message: "filename parameter is empty.");

    var filePath = path.join(await mediaFolderPathFuture, filename);

    var fileBytes = List<int>.from(await File(filePath).readAsBytes());

    var contentType = "multipart/form-data";

    var response = await client.upload(
        path: mainPath, body: fileBytes, contentType: contentType);

    switch (response.statusCode) {
      case HttpStatus.ok:
        var responseObject = MediafileInfo.fromJson(jsonDecode(response.body));
        return responseObject;

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw UnauthorizedException(message: response.body);

      case HttpStatus.notFound:
        throw ResourceDoesntExistException(message: response.body);

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }
}
