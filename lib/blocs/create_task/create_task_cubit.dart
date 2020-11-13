import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/ITaskApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final ITaskApiClient taskApiClient;
  final MediaListCubit<IImageApiClient> _imageCubit;
  final MediaListCubit<IDrivingVideoApiClient> _videoCubit;

  CreateTaskCubit(
    this.taskApiClient,
    this._imageCubit,
    this._videoCubit,
  ) : super(CreateTaskInitial());

  MediafileInfo image;
  MediafileInfo drivingVideo;

  Future<void> startPicker() async {
    await _imageCubit.getAllActive();
    await _videoCubit.getAllActive();
    emit(CreateTaskSelectImage());
  }

  Future<void> selectImage(MediafileInfo mediafileInfo) async {
    image = mediafileInfo;
    emit(CreateTaskSelectVideo(
        image: mediafileInfo, drivingVideo: drivingVideo));
  }

  Future<void> selectDrivingVideo(MediafileInfo mediafileInfo) async {
    drivingVideo = mediafileInfo;
    emit(CreateTaskSelectVideo(drivingVideo: mediafileInfo, image: image));
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
    await taskApiClient.createNewTask(image, drivingVideo);

    emit(CreateTaskSent());
    await Future.delayed(Duration(seconds: 1));
    await reset();
  }

  Future<void> reset(
      {bool resetImage = true, bool resetDrivingVideo = true}) async {
    if (!(resetImage || resetDrivingVideo)) return;

    if (resetImage) image = null;

    if (resetDrivingVideo) drivingVideo = null;

    if (resetImage || resetDrivingVideo) {
      emit(CreateTaskInitial());
      return;
    }

    if (image == null)
      emit(CreateTaskSelectImage(drivingVideo: drivingVideo));
    else if (drivingVideo == null) emit(CreateTaskSelectVideo(image: image));
  }
}
