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
    emit(CreateTaskImageSelected(
        image: mediafileInfo, drivingVideo: drivingVideo));
  }

  Future<void> selectDrivingVideo(MediafileInfo mediafileInfo) async {
    drivingVideo = mediafileInfo;
    emit(CreateTaskImageSelected(drivingVideo: mediafileInfo, image: image));
  }

  Future<void> sendNewTask() async {
    if (image == null || drivingVideo == null) {
      emit(CreateTaskError(
          error:
              "Image and driving video can't be null when sending new task."));

      await reset();
      return;
    }

    emit(CreateTaskSending());
    await Future.delayed(Duration(seconds: 2));

    emit(CreateTaskSent());
    await Future.delayed(Duration(seconds: 1));
    await reset();
  }

  Future<void> reset(
      {bool resetImage = true, bool resetDrivingVideo = true}) async {
    if (!(resetImage || resetDrivingVideo)) return;

    if (resetImage) image = null;

    if (resetDrivingVideo) drivingVideo = null;

    if (image == null)
      emit(CreateTaskInitial(drivingVideo: drivingVideo));
    else if (drivingVideo == null) emit(CreateTaskImageSelected(image: image));
  }
}
