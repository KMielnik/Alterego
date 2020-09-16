import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/models/identity/authentication_request.dart';
import 'package:alterego/net/alterego_httpclient.dart';
import 'package:alterego/net/image_api_client.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'net/user_api_client.dart';

void main() async {
  var app = RepositoryProvider<AlterEgoHTTPClient>(
      create: (context) => AlterEgoHTTPClient(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserApiClient>(
              create: (context) => UserApiClient(
                  client: context.repository<AlterEgoHTTPClient>())),
          RepositoryProvider<ImageApiClient>(
              create: (context) => ImageApiClient(
                  client: context.repository<AlterEgoHTTPClient>())),
        ],
        child: BlocProvider(
          create: (context) => AuthenticationCubit()..appStarted(),
          child: App(),
        ),
      ));

  runApp(app);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AlterEgo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.purpleAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationInitial) {
              return Text("Splash screen");
            }
            if (state is AuthenticationLoading) {
              return CircularProgressIndicator();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginPage();
            }
            if (state is AuthenticationAuthenticated) {
              return Text("Welcome to app ${state.nickname}");
            }

            return Container();
          },
        ));
  }
}
