import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/exceptions/network_exceptions.dart';
import 'package:alterego/main.dart';
import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/models/identity/register_request.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({@required this.userApiClient, @required this.authenticationCubit})
      : assert(userApiClient != null),
        assert(authenticationCubit != null),
        super(LoginInitial()) {
    tryLoginWithSavedCredentials();
  }

  final _firebaseMessaging = FirebaseMessaging();
  String _currentUserLogin;

  final IUserApiClient userApiClient;
  final AuthenticationCubit authenticationCubit;

  Future<void> tryLoginWithSavedCredentials() async {
    emit(LoginLoading());
    try {
      final response =
          await userApiClient.tryAuthenticateWithSavedCredentials();
      if (response != null) authenticationCubit.loggedIn(response: response);
    } catch (e) {} finally {
      emit(LoginInitial());
    }
  }

  Future<void> login({
    @required String login,
    @required String password,
  }) async {
    emit(LoginLoading());

    try {
      final request = AuthenticationRequest(login: login, password: password);
      final response = await userApiClient.authenticate(request: request);

      authenticationCubit.loggedIn(response: response);
      _currentUserLogin = response.login;
      await _firebaseMessaging.subscribeToTopic(_currentUserLogin);
    } on BadRequestException catch (error) {
      emit(LoginFailure(error: error.toString()));
    } on Exception catch (error) {
      emit(LoginFailure(error: "Unknown login exception: ${error.toString()}"));
    } finally {
      emit(LoginInitial());
    }
  }

  Future<void> register({
    @required String login,
    @required String password,
    @required String email,
    @required String nickname,
  }) async {
    emit(LoginLoading());

    try {
      final request = RegisterRequest(
        login: login,
        password: password,
        email: email,
        nickname: nickname,
      );
      await userApiClient.register(request: request);
    } on BadRequestException catch (error) {
      emit(LoginFailure(error: error.toString()));
    } on Exception {
      emit(LoginFailure(error: "Unknown login exception"));
    } finally {
      emit(LoginInitial());
    }
  }

  Future<void> logout() async {
    await userApiClient.logout();
    emit(LoginInitial());
    authenticationCubit.loggedOut();
    await _firebaseMessaging.unsubscribeFromTopic(_currentUserLogin);
  }
}
