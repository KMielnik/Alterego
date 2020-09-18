import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/login/login_cubit.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginCubit>(
        create: (context) {
          return LoginCubit(
              authenticationCubit: context.bloc<AuthenticationCubit>(),
              userApiClient: context.repository<IUserApiClient>());
        },
        child: Scaffold(
          body: LoginForm(),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit),
                title: Text("1"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_alarms),
                title: Text("2"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      context.bloc<LoginCubit>().login(
            login: _usernameController.text,
            password: _passwordController.text,
          );
    }

    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple[900],
                Colors.deepPurple[800],
                Colors.deepPurple[400],
                Colors.deepPurple[400],
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        Text("Enter your data"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1)),
                      ],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(),
                          TextFormField(),
                          SignInButton(
                            Buttons.Google,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("${state.error}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}
