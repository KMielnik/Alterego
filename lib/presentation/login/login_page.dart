import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/login/login_cubit.dart';
import 'package:alterego/net/user_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<LoginCubit>(
      create: (context) {
        return LoginCubit(
            authenticationCubit: context.bloc<AuthenticationCubit>(),
            userApiClient: context.repository<UserApiClient>());
      },
      child: Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: LoginForm(),
        ),
      ),
    ));
  }
}

class LoginForm extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      context.bloc<LoginCubit>().login(
          login: _usernameController.text, password: _passwordController.text);
    }

    return BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return Form(
              child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
              ),
              TextFormField(
                controller: _passwordController,
              ),
              RaisedButton(
                onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                child: Text("Login"),
              ),
            ],
          ));
        },
        listener: (context, state) {});
  }
}
