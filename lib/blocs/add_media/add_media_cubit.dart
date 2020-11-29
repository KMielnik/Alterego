import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

part 'add_media_state.dart';

class AddMediaCubit extends Cubit<AddMediaState> {
  AddMediaCubit() : super(AddMediaInitial());

  PickedFile _selectedMedia;

  Future<void> selectMedia(PickedFile file) async {
    if (file == null) return;
    final mediaExtension = p.extension(file.path);

    if (!(mediaExtension == ".jpg" ||
        mediaExtension == ".jpeg" ||
        mediaExtension == ".mp4")) {
      emit(AddMediaError("\"$mediaExtension\" is unsupported."));

      return;
    }

    _selectedMedia = file;
    emit(AddMediaSelected(file));
  }

  Future<void> reset() async {
    _selectedMedia = null;
    emit(AddMediaInitial());
  }

  Future<void> createAndSend(
      String selectedFilename, IMediaApiClient client) async {
    try {
      if (_selectedMedia == null)
        throw ResourceDoesntExistException(
          message: "No media selected before trying to send to server.",
        );

      client.upload(
        filepath: _selectedMedia.path,
        filename: selectedFilename,
      );
      emit(AddMediaCreated());
    } on AppException catch (e) {
      emit(AddMediaError(e.toString()));
    }
    emit(AddMediaInitial());
  }
}
