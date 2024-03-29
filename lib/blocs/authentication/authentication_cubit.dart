import 'package:alterego/models/identity/authentication_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> appStarted() async {
    emit(AuthenticationLoading());
    emit(AuthenticationUnauthenticated());
  }

  Future<void> loggedIn({@required AuthenticationResponse response}) async {
    emit(AuthenticationLoading());

    emit(AuthenticationAuthenticated(nickname: response.nickname));
  }

  Future<void> loggedOut() async {
    emit(AuthenticationLoading());

    emit(AuthenticationUnauthenticated());
  }
}
