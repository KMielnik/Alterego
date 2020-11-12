part of 'create_task_cubit.dart';

abstract class CreateTaskState extends Equatable {
  final MediafileInfo image;
  final MediafileInfo drivingVideo;

  const CreateTaskState({this.image, this.drivingVideo});

  @override
  List<Object> get props => [image, drivingVideo];
}

class CreateTaskInitial extends CreateTaskState {
  CreateTaskInitial() : super(image: null, drivingVideo: null);
}

class CreateTaskSelectImage extends CreateTaskState {
  CreateTaskSelectImage({MediafileInfo image, MediafileInfo drivingVideo})
      : super(image: image, drivingVideo: drivingVideo);
}

class CreateTaskSelectVideo extends CreateTaskState {
  CreateTaskSelectVideo({MediafileInfo image, MediafileInfo drivingVideo})
      : super(image: image, drivingVideo: drivingVideo);
}

class CreateTaskSending extends CreateTaskState {}

class CreateTaskSent extends CreateTaskState {}

class CreateTaskError extends CreateTaskState {
  final String error;

  CreateTaskError({this.error});

  @override
  List<Object> get props => [image, drivingVideo, error];
}
