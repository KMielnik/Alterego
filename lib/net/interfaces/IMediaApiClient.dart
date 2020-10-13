import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:meta/meta.dart';

abstract class IMediaApiClient {
  Future<List<MediafileInfo>> getAll({bool includeThumbnails = true});
  Future<MediafileInfo> refreshLifetime({String filename});
  Future delete({String filename});
  Future<String> downloadSpecifiedToTemp({@required String filename});
  Future<MediafileInfo> upload({String filename});
}
