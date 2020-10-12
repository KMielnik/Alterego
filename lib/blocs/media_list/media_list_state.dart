part of 'media_list_cubit.dart';

abstract class MediaListState extends Equatable {
  const MediaListState();

  @override
  List<Object> get props => [];
}

class MediaListInitial extends MediaListState {}

class MediaListLoading extends MediaListState {}

class MediaListError extends MediaListState {
  final String error;

  MediaListError(this.error);

  @override
  List<Object> get props => [error];
}

class MediaListLoaded extends MediaListState {
  final List<MediafileInfo> items;

  MediaListLoaded(this.items);

  @override
  List<Object> get props => [items];
}
