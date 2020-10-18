import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:meta/meta.dart';

import 'alterego_httpclient.dart';
import 'media_api_client.dart';

class ResultVideoApiClient extends MediaApiClient
    implements IResultVideoApiClient {
  ResultVideoApiClient({@required AlterEgoHTTPClient client})
      : super(client: client, mainPath: "ResultVideo");
}
