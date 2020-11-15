part of 'add_media_cubit.dart';

abstract class AddMediaState extends Equatable {
  const AddMediaState();

  @override
  List<Object> get props => [];
}

class AddMediaInitial extends AddMediaState {}

class AddMediaSelected extends AddMediaState {
  final PickedFile createdMedia;

  AddMediaSelected(this.createdMedia);

  @override
  List<Object> get props => [createdMedia];
}

class AddMediaError extends AddMediaState {
  final String error;

  AddMediaError(this.error);

  @override
  List<Object> get props => [error];
}

class AddMediaCreated extends AddMediaState {}
