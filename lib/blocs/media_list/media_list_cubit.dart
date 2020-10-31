import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_list_state.dart';

class MediaListCubit<T extends IMediaApiClient> extends Cubit<MediaListState> {
  final T mediaAPIClient;
  MediaListCubit({this.mediaAPIClient}) : super(MediaListInitial());

  List<MediafileInfo> mediaList;
  bool onlyActiveAvailable = true;

  Future<void> refreshMedia() async {
    emit(MediaListLoading());
    try {
      if (onlyActiveAvailable)
        mediaList = await mediaAPIClient.getAllActive();
      else
        mediaList = await mediaAPIClient.getAll();

      emit(MediaListLoaded(mediaList));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future<void> getFilteredList(String filter, {bool onlyActive = false}) async {
    var initialList =
        mediaList.where((element) => !onlyActive || element.isAvailable);

    var filteredList = initialList
        .where((element) => element.originalFilename.contains(filter))
        .toList();

    emit(MediaListLoaded(filteredList));
  }

  Future<void> getAllMedia() async {
    emit(MediaListLoading());
    try {
      if (onlyActiveAvailable)
        mediaList = await mediaAPIClient.getAll();
      else
        mediaList ??= await mediaAPIClient.getAll();

      onlyActiveAvailable = false;

      emit(MediaListLoaded(mediaList));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future<void> getAllActive() async {
    emit(MediaListLoading());
    try {
      if (mediaList == null) {
        mediaList = await mediaAPIClient.getAllActive();

        onlyActiveAvailable = true;
      }

      emit(
        MediaListLoaded(
          mediaList.where((element) => element.isAvailable).toList(),
        ),
      );
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future<void> deleteMedia(String filename) async {
    try {
      mediaList.removeWhere((element) => element.filename == filename);
      emit(MediaListLoaded(mediaList));

      await mediaAPIClient.delete(filename: filename);
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future<void> refreshLifetimeMedia(String filename) async {
    try {
      var originalItemIndex =
          mediaList.indexWhere((element) => element.filename == filename);
      var changedItem =
          await mediaAPIClient.refreshLifetime(filename: filename);

      mediaList.setAll(originalItemIndex, [changedItem]);

      emit(MediaListLoaded(mediaList));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }
}
