import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:meta/meta.dart';

class AnimationTaskDTO {
  String id;
  String owner;
  MediafileInfo sourceVideo;
  MediafileInfo sourceImage;
  MediafileInfo resultAnimation;
  bool retainAudio;
  double imagePadding;
  DateTime createdAt;
  Statuses status;

  AnimationTaskDTO({
    @required this.id,
    @required this.owner,
    @required this.sourceVideo,
    @required this.sourceImage,
    @required this.resultAnimation,
    @required this.retainAudio,
    @required this.imagePadding,
    @required this.createdAt,
    @required this.status,
  });

  AnimationTaskDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    sourceVideo = json['sourceVideo'] != null
        ? MediafileInfo.fromJson(json['sourceVideo'])
        : null;
    sourceImage = json['sourceImage'] != null
        ? MediafileInfo.fromJson(json['sourceImage'])
        : null;
    resultAnimation = json['resultAnimation'] != null
        ? MediafileInfo.fromJson(json['resultAnimation'])
        : null;
    retainAudio = json['retainAudio'];
    imagePadding = json['imagePadding'].toDouble();
    createdAt = DateTime.parse(json['createdAt']);
    status = Statuses.values
        .firstWhere((element) => element.toString().contains(json['status']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner'] = this.owner;
    data['sourceVideo'] = this.sourceVideo;
    data['sourceImage'] = this.sourceImage;
    data['resultAnimation'] = this.resultAnimation;
    data['retainAudio'] = this.retainAudio;
    data['imagePadding'] = this.imagePadding;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}

enum Statuses {
  New,
  Processing,
  Done,
  Notified,
  Failed,
}
