import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

class MediafileInfo {
  String filename;
  String userLogin;
  String existsUntill;
  bool isAvailable;
  Uint8List thumbnail;

  MediafileInfo(
      {@required this.filename,
      @required this.userLogin,
      @required this.existsUntill,
      @required this.isAvailable,
      @required this.thumbnail});

  MediafileInfo.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    userLogin = json['userLogin'];
    existsUntill = json['existsUntill'];
    isAvailable = json['isAvailable'];
    thumbnail =
        json['thumbnail'] != null ? base64.decode(json['thumbnail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['userLogin'] = this.userLogin;
    data['existsUntill'] = this.existsUntill;
    data['isAvailable'] = this.isAvailable;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
