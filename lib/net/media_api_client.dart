import 'dart:convert';
import 'dart:io';

import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/alterego_httpclient.dart';
import 'package:meta/meta.dart';

abstract class MediaApiClient {
  final AlterEgoHTTPClient client;

  final String mainPath;

  MediaApiClient({@required this.client, @required this.mainPath});

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

  Future downloadSpecified({@required String filename}) async {
    var path = "$mainPath/$filename";
  }
}
