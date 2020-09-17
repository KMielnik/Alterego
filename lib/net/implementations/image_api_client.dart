import 'package:alterego/net/implementations/alterego_httpclient.dart';
import 'package:alterego/net/implementations/media_api_client.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:meta/meta.dart';

class ImageApiClient extends MediaApiClient implements IImageApiClient {
  ImageApiClient({@required AlterEgoHTTPClient client})
      : super(client: client, mainPath: "Images");
}
