import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

class MediafileInfo {
  String filename;
  String userLogin;
  String existsUntill;
  Uint8List thumbnail;

  MediafileInfo(
      {@required this.filename,
      @required this.userLogin,
      @required this.existsUntill,
      @required this.thumbnail});

  MediafileInfo.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    userLogin = json['userLogin'];
    existsUntill = json['existsUntill'];
    thumbnail = base64.decode(json['thumbnail']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['userLogin'] = this.userLogin;
    data['existsUntill'] = this.existsUntill;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
