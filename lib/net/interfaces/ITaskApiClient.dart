import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/models/animator/mediafile_info.dart';

abstract class ITaskApiClient {
  Future<AnimationTaskDTO> createNewTask(
    MediafileInfo image,
    MediafileInfo drivingVideo, {
    bool retainAudio = true,
    double imagePadding = 0.2,
  });

  Future<List<AnimationTaskDTO>> getAll();
  Future<AnimationTaskDTO> getOne(String taskId);
}
