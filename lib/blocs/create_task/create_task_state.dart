part of 'create_task_cubit.dart';

abstract class CreateTaskState extends Equatable {
  final MediafileInfo image;
  final MediafileInfo drivingVideo;

  const CreateTaskState({this.image, this.drivingVideo});

  @override
  List<Object> get props => [image, drivingVideo];
}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskImageSelected extends CreateTaskState {
  CreateTaskImageSelected({MediafileInfo image, MediafileInfo drivingVideo})
      : super(image: image, drivingVideo: drivingVideo);
}
