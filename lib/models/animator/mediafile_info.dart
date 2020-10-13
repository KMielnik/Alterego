import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

class MediafileInfo {
  String filename;
  String originalFilename;
  String userLogin;
  DateTime existsUntill;
  bool isAvailable;
  Uint8List thumbnail;

  MediafileInfo(
      {@required this.filename,
      @required this.originalFilename,
      @required this.userLogin,
      @required this.existsUntill,
      @required this.isAvailable,
      @required this.thumbnail});

  MediafileInfo.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    originalFilename = json['originalFilename'];
    userLogin = json['userLogin'];
    existsUntill = DateTime.parse(json['existsUntill']);
    isAvailable = json['isAvailable'];
    thumbnail =
        json['thumbnail'] != null ? base64.decode(json['thumbnail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['originalFilename'] = this.originalFilename;
    data['userLogin'] = this.userLogin;
    data['existsUntill'] = this.existsUntill.toString();
    data['isAvailable'] = this.isAvailable;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
