import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/models/identity/authentication_response.dart';
import 'package:alterego/net/user_api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future appStarted() async {
    emit(AuthenticationLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(AuthenticationUnauthenticated());
  }

  Future loggedIn({@required AuthenticationResponse response}) async {
    emit(AuthenticationLoading());

    emit(AuthenticationAuthenticated(nickname: response.nickname));
  }

  Future loggedOut() async {
    emit(AuthenticationLoading());

    emit(AuthenticationUnauthenticated());
  }
}
