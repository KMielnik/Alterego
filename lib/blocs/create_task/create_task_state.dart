part of 'create_task_cubit.dart';

abstract class CreateTaskState extends Equatable {
  final MediafileInfo image;
  final MediafileInfo drivingVideo;

  const CreateTaskState({this.image, this.drivingVideo});

  @override
  List<Object> get props => [image, drivingVideo];
}

class CreateTaskInitial extends CreateTaskState {
  CreateTaskInitial({MediafileInfo image, MediafileInfo drivingVideo})
      : super(image: image, drivingVideo: drivingVideo);
}

class CreateTaskImageSelected extends CreateTaskState {
  CreateTaskImageSelected({MediafileInfo image, MediafileInfo drivingVideo})
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
