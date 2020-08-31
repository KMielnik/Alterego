import 'package:alterego/net/alterego_httpclient.dart';
import 'package:alterego/net/media_api_client.dart';
import 'package:meta/meta.dart';

class ImageApiClient extends MediaApiClient {
  ImageApiClient({@required AlterEgoHTTPClient client})
      : super(client: client, mainPath: "Images");
}
