import 'package:meta/meta.dart';

class AnimationTaskRequest {
  String sourceVideo;
  String sourceImage;
  bool retainAudio;
  double imagePadding;

  AnimationTaskRequest(
      {@required this.sourceVideo,
      @required this.sourceImage,
      @required this.retainAudio,
      @required this.imagePadding});

  AnimationTaskRequest.fromJson(Map<String, dynamic> json) {
    sourceVideo = json['sourceVideo'];
    sourceImage = json['sourceImage'];
    retainAudio = json['retainAudio'];
    imagePadding = json['imagePadding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceVideo'] = this.sourceVideo;
    data['sourceImage'] = this.sourceImage;
    data['retainAudio'] = this.retainAudio;
    data['imagePadding'] = this.imagePadding;
    return data;
  }
}
