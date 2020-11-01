import 'dart:convert';
import 'dart:io';

import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/main.dart';
import 'package:alterego/models/animator/animation_task_request.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/net/interfaces/ITaskApiClient.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import 'alterego_httpclient.dart';

class TaskApiClient extends ITaskApiClient {
  final AlterEgoHTTPClient client;

  static const mainPath = "Tasks";

  TaskApiClient({@required this.client});

  @override
  Future<AnimationTaskDTO> createNewTask(
      MediafileInfo image, MediafileInfo drivingVideo,
      {bool retainAudio = true, double imagePadding = 0.2}) async {
    var request = AnimationTaskRequest(
      sourceVideo: drivingVideo.filename,
      sourceImage: image.filename,
      retainAudio: retainAudio,
      imagePadding: imagePadding,
    );

    var response = await client.post(path: mainPath, body: jsonEncode(request));

    switch (response.statusCode) {
      case HttpStatus.created:
        var responseObject =
            AnimationTaskDTO.fromJson(jsonDecode(response.body));

        return responseObject;

      case HttpStatus.badRequest:
        throw BadRequestException(message: response.body);
        break;

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        throw UnauthorizedException(message: response.body);

      default:
        throw AppException(
            prefix: "Unhandled status code ${response.statusCode}",
            message: response.body);
    }
  }
}
