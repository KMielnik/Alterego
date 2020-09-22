import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_list_state.dart';

class MediaListCubit extends Cubit<MediaListState> {
  final IImageApiClient imageApiClient;
  MediaListCubit({this.imageApiClient}) : super(MediaListInitial());

  Future getAllImages() async {
    var items = await imageApiClient.getAll();

    emit(MediaListLoaded(items));
  }
}
