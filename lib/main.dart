import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/dashboard/dashboard_cubit.dart';
import 'package:alterego/blocs/settings/settings_repository.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/implementations/driving_video_api_client.dart';
import 'package:alterego/net/implementations/image_api_client.dart';
import 'package:alterego/net/implementations/result_video_api_client.dart';
import 'package:alterego/net/implementations/user_api_client.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:alterego/presentation/home/home_page.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:auto_localized/auto_localized.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/media_list/media_list_cubit.dart';
import 'net/implementations/alterego_httpclient.dart';
import 'net/implementations/task_api_client.dart';
import 'net/interfaces/ITaskApiClient.dart';

void main() async {
  var app = AppWithState();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(app);
}

class AppWithState extends StatefulWidget {
  const AppWithState({
    Key key,
  }) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppWithStateState>().restartApp();
  }

  @override
  _AppWithStateState createState() => _AppWithStateState();
}

class _AppWithStateState extends State<AppWithState> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SettingsRepository>(
      create: (context) => SettingsRepository(),
      child: KeyedSubtree(
        key: key,
        child: RepositoryProvider<AlterEgoHTTPClient>(
          create: (context) => AlterEgoHTTPClient(
            context.repository<SettingsRepository>(),
          ),
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
              RepositoryProvider<IDrivingVideoApiClient>(
                create: (context) => DrivingVideoApiClient(
                  client: context.repository<AlterEgoHTTPClient>(),
                ),
              ),
              RepositoryProvider<IResultVideoApiClient>(
                create: (context) => ResultVideoApiClient(
                  client: context.repository<AlterEgoHTTPClient>(),
                ),
              ),
              RepositoryProvider<ITaskApiClient>(
                create: (context) => TaskApiClient(
                  client: context.repository<AlterEgoHTTPClient>(),
                ),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationCubit>(
                    create: (context) => AuthenticationCubit()..appStarted()),
                BlocProvider<MediaListCubit<IImageApiClient>>(
                  create: (context) => MediaListCubit<IImageApiClient>(
                    mediaAPIClient: context.repository<IImageApiClient>(),
                  ),
                ),
                BlocProvider<MediaListCubit<IDrivingVideoApiClient>>(
                  create: (context) => MediaListCubit<IDrivingVideoApiClient>(
                    mediaAPIClient:
                        context.repository<IDrivingVideoApiClient>(),
                  ),
                ),
                BlocProvider<MediaListCubit<IResultVideoApiClient>>(
                  create: (context) => MediaListCubit<IResultVideoApiClient>(
                    mediaAPIClient: context.repository<IResultVideoApiClient>(),
                  ),
                ),
                BlocProvider<DashboardCubit>(
                  create: (context) => DashboardCubit(
                    taskApiClient: context.repository<ITaskApiClient>(),
                  ),
                ),
              ],
              child: App(),
            ),
          ),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoLocalizedApp(
      child: MaterialApp(
        title: 'AlterEgo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.amberAccent,
          fontFamily: 'Georgia',
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: const Color(0xFFEFEFEF),
          cardColor: Colors.white,
        ),
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationsDelegates,
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
      ),
    );
  }
}
