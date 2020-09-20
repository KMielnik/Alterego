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
          body: _LoginMainScreen(),
        ),
      ),
    );
  }
}

class _LoginMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Text(
                  "AlterEgo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Scaffold.of(context)
                            .showBottomSheet((context) => _LoginForm());
                      },
                      child: Text("Login"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Scaffold.of(context)
                            .showBottomSheet((context) => _RegisterForm());
                      },
                      child: Text("Signup"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputWidget extends StatelessWidget {
  final Icon icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  const _InputWidget(
      {Key key, this.icon, this.hint, this.controller, this.obscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 20),
        obscureText: obscure,
        validator: (value) {
          if (value.isEmpty) return "Please enter a value";
          return null;
        },
        decoration: InputDecoration(
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 5,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 20, right: 10),
            )),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (_formKey.currentState.validate()) {
        context.bloc<LoginCubit>().login(
              login: _usernameController.text,
              password: _passwordController.text,
            );
      }
    }

    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.account_circle_outlined),
                              hint: "Your login",
                              controller: _usernameController,
                              obscure: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.lock_outline),
                              hint: "Your password",
                              controller: _passwordController,
                              obscure: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RaisedButton(
                        onPressed: _onLoginButtonPressed,
                        child: Text("LOGIN"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (_formKey.currentState.validate()) {
        context.bloc<LoginCubit>().register(
              login: _usernameController.text,
              password: _passwordController.text,
              email: _emailController.text,
              nickname: _nicknameController.text,
            );
      }
    }

    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.account_circle_outlined),
                              hint: "Your login",
                              controller: _usernameController,
                              obscure: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.lock_outline),
                              hint: "Your password",
                              controller: _passwordController,
                              obscure: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.mail_outline),
                              hint: "Your email",
                              controller: _emailController,
                              obscure: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.pets),
                              hint: "Your nickname",
                              controller: _nicknameController,
                              obscure: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RaisedButton(
                        onPressed: _onLoginButtonPressed,
                        child: Text("LOGIN"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
