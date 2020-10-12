import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:meta/meta.dart';

import 'alterego_httpclient.dart';
import 'media_api_client.dart';

class DrivingVideoApiClient extends MediaApiClient
    implements IDrivingVideoApiClient {
  DrivingVideoApiClient({@required AlterEgoHTTPClient client})
      : super(client: client, mainPath: "DrivingVideo");
}
