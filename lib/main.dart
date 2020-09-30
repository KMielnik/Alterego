import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/net/fake_implementations/fake_image_api_client.dart';
import 'package:alterego/net/fake_implementations/fake_user_api_client.dart';
import 'package:alterego/net/implementations/alterego_httpclient.dart';
import 'package:alterego/net/implementations/image_api_client.dart';
import 'package:alterego/net/implementations/user_api_client.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:alterego/presentation/home/home_page.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  var app = RepositoryProvider<AlterEgoHTTPClient>(
    create: (context) => AlterEgoHTTPClient(),
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IUserApiClient>(
          create: (context) => UserApiClient(
            client: context.repository<AlterEgoHTTPClient>(),
          ),
        ),
        RepositoryProvider<IImageApiClient>(
          create: (context) => ImageApiClient(
            client: context.repository<AlterEgoHTTPClient>(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthenticationCubit()..appStarted(),
        child: App(),
      ),
    ),
  );

  runApp(app);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlterEgo',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        fontFamily: 'Georgia',
        canvasColor: Colors.transparent,
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
            return HomePage();
          }

          return Container();
        },
      ),
    );
  }
}
