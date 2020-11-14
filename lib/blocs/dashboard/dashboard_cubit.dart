import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/net/interfaces/ITaskApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ITaskApiClient taskApiClient;
  DashboardCubit({this.taskApiClient}) : super(DashboardStateInitial());

  List<AnimationTaskDTO> mediaList;

  Future<List<AnimationTaskDTO>> getTasksFromServer() async =>
      await taskApiClient.getAll();

  Future<void> refresh() async {
    emit(DashboardStateLoading());

    mediaList = await getTasksFromServer();
    emit(DashboardStateLoaded(mediaList));
  }

  Future<void> getAll() async {
    emit(DashboardStateLoading());

    mediaList ??= await getTasksFromServer();

    emit(DashboardStateLoaded(mediaList));
  }
}
