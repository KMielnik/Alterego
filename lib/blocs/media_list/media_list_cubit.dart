import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_list_state.dart';

class MediaListCubit extends Cubit<MediaListState> {
  final IImageApiClient imageApiClient;
  MediaListCubit({this.imageApiClient}) : super(MediaListInitial());

  Future getAllImages() async {
    try {
      var items = await imageApiClient.getAll();

      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future deleteImage(String filename) async {
    try {
      await imageApiClient.delete(filename: filename);

      var items = await imageApiClient.getAll();
      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }

  Future refreshLifetimeImage(String filename) async {
    try {
      await imageApiClient.refreshLifetime(filename: filename);

      var items = await imageApiClient.getAll();
      emit(MediaListLoaded(items));
    } on AppException catch (e) {
      emit(MediaListError(e.toString()));
    }
  }
}
