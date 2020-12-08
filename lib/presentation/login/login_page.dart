import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/login/login_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:alterego/presentation/home/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
    return BlocConsumer<LoginCubit, LoginState>(
      builder: (context, state) => Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple[900],
                    Colors.deepPurple[800],
                    Colors.deepPurple[400],
                    Colors.deepPurple[400],
                  ],
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SafeArea(
                  child: Center(
                    child: Text(
                      "AlterEgo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              child: WaveWidget(
                config: CustomConfig(
                  colors: [
                    Colors.deepPurple[500],
                    Colors.deepPurple[700],
                    Colors.deepPurple[800],
                    Colors.white
                  ],
                  durations: [35000, 19440, 10800, 6000],
                  heightPercentages: [0.20, 0.23, 0.25, 0.50],
                  blur: MaskFilter.blur(BlurStyle.solid, 5),
                ),
                backgroundColor: Colors.deepPurple[400],
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyRoundedButton(
                          Text("TEST ACC"),
                          () {
                            context.bloc<LoginCubit>().login(
                                  login: "login123",
                                  password: "pass123",
                                );
                          },
                        ),
                        MyRoundedButton(
                          Text("Settings"),
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyRoundedButton(
                          Text(Strings.loginLogin.get(context)),
                          () {
                            Scaffold.of(context)
                                .showBottomSheet((context) => _LoginForm());
                          },
                        ),
                        MyRoundedButton(
                          Text(Strings.loginRegister.get(context)),
                          () {
                            Scaffold.of(context)
                                .showBottomSheet((context) => _RegisterForm());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(Strings.loading.get(context)),
            ),
          );
        }
        if (state is LoginFailure) {
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
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
          if (value.isEmpty) return Strings.loginEnterValue.get(context);
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
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                              hint: Strings.loginYourLogin.get(context),
                              controller: _usernameController,
                              obscure: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.lock_outline),
                              hint: Strings.loginYourPassword.get(context),
                              controller: _passwordController,
                              obscure: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyRoundedButton(
                        Text(Strings.loginLogin.get(context)),
                        _onLoginButtonPressed,
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
    _onRegisterButtonPressed() {
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
          height: MediaQuery.of(context).size.height * 0.55,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                              hint: Strings.loginYourLogin.get(context),
                              controller: _usernameController,
                              obscure: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.lock_outline),
                              hint: Strings.loginYourPassword.get(context),
                              controller: _passwordController,
                              obscure: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.mail_outline),
                              hint: Strings.loginYourEmail.get(context),
                              controller: _emailController,
                              obscure: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _InputWidget(
                              icon: Icon(Icons.pets),
                              hint: Strings.loginYourNickname.get(context),
                              controller: _nicknameController,
                              obscure: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyRoundedButton(
                        Text(
                          Strings.loginRegister.get(context),
                        ),
                        _onRegisterButtonPressed,
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

class MyRoundedButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  MyRoundedButton(this.child, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          primary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
