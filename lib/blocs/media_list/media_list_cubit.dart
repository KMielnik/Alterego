import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_list_state.dart';

class MediaListCubit<T extends IMediaApiClient> extends Cubit<MediaListState> {
  final T mediaAPIClient;
  MediaListCubit({this.mediaAPIClient}) : super(MediaListInitial());

  Future getAllMedia() async {
    emit(MediaListLoading());
    try {
      var items = await mediaAPIClient.getAll();

      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future getAllActive() async {
    emit(MediaListLoading());
    try {
      var items = await mediaAPIClient.getAllActive();

      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future deleteMedia(String filename) async {
    try {
      await mediaAPIClient.delete(filename: filename);

      var items = await mediaAPIClient.getAll();
      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future refreshLifetimeMedia(String filename) async {
    try {
      await mediaAPIClient.refreshLifetime(filename: filename);

      var items = await mediaAPIClient.getAll();
      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }
}
