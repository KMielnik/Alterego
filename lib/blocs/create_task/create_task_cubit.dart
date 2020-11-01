import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial());

  MediafileInfo image;
  MediafileInfo drivingVideo;

  Future<void> selectImage(MediafileInfo mediafileInfo) async {
    image = mediafileInfo;
    emit(CreateTaskImageSelected(image: mediafileInfo));
  }

  Future<void> selectDrivingVideo(MediafileInfo mediafileInfo) async {
    drivingVideo = mediafileInfo;
    emit(CreateTaskImageSelected(drivingVideo: mediafileInfo, image: image));
  }

  Future<void> reset() async {
    image = null;
    drivingVideo = null;
    emit(CreateTaskInitial());
  }
}
