import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'add_media_state.dart';

class AddMediaCubit extends Cubit<AddMediaState> {
  AddMediaCubit() : super(AddMediaInitial());

  PickedFile _selectedMedia;

  Future<void> selectMedia(PickedFile file) async {
    _selectedMedia = file;
    emit(AddMediaSelected(file));
  }

  Future<void> reset() async {
    _selectedMedia = null;
    emit(AddMediaInitial());
  }

  Future<void> createAndSend<T extends IMediaApiClient>(
      String selectedFilename, T client) async {
    try {
      if (_selectedMedia == null)
        throw ResourceDoesntExistException(
          message: "No media selected before trying to send to server.",
        );
      await client.upload(
        filepath: _selectedMedia.path,
        filename: selectedFilename,
      );
    } on AppException catch (e) {
      emit(AddMediaError(e.toString()));
    }
    emit(AddMediaInitial());
  }
}
