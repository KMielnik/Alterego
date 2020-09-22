import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';

class FakeImageApiClient extends IImageApiClient {
  @override
  Future delete({String filename}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<String> downloadSpecified({String filename}) {
    // TODO: implement downloadSpecified
    throw UnimplementedError();
  }

  @override
  Future<List<MediafileInfo>> getAll({bool includeThumbnails = true}) {
    var list = List<MediafileInfo>();
    for (var i = 0; i < 10; i++) {
      list.add(MediafileInfo(
        filename: "file$i.jpg",
        userLogin: "TEST",
        existsUntill: DateTime.now().add(Duration(days: i % 3)).toString(),
        thumbnail: includeThumbnails ? "" : null,
      ));
    }
  }

  @override
  Future<MediafileInfo> refreshLifetime({String filename}) {
    // TODO: implement refreshLifetime
    throw UnimplementedError();
  }

  @override
  Future<MediafileInfo> upload({String filename}) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
