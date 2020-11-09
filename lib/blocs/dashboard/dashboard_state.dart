part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardStateInitial extends DashboardState {}

class DashboardStateLoading extends DashboardState {}

class DashboardStateError extends DashboardState {
  final String error;

  DashboardStateError(this.error);

  @override
  List<Object> get props => [error];
}

class DashboardStateLoaded extends DashboardState {
  final List<AnimationTaskDTO> items;

  DashboardStateLoaded(this.items);

  @override
  List<Object> get props => [items];
}
