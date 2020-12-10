import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/dashboard/dashboard_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/implementations/driving_video_api_client.dart';
import 'package:alterego/net/implementations/image_api_client.dart';
import 'package:alterego/net/implementations/result_video_api_client.dart';
import 'package:alterego/net/implementations/user_api_client.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:alterego/net/interfaces/IUserApiClient.dart';
import 'package:alterego/presentation/home/dashboard/task_item_expanded.dart';
import 'package:alterego/presentation/home/home_page.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:auto_localized/auto_localized.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';

import 'blocs/login/login_cubit.dart';
import 'blocs/media_list/media_list_cubit.dart';
import 'net/implementations/alterego_httpclient.dart';
import 'net/implementations/task_api_client.dart';
import 'net/interfaces/ITaskApiClient.dart';

void main() async {
  var app = AppWithState();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Settings.init();

  final _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions();
  print(await _firebaseMessaging.getToken());

  Function _showTaskOpenDialog = (message) async {
    Get.defaultDialog(
      title: "Task has been finished",
      content: Text(
        "Task ${message["data"]["task_id"]}\nDo you want to open it now?",
      ),
      confirm: FlatButton(
        onPressed: () async {
          var task = await Get.context
              .repository<ITaskApiClient>()
              .getOne(message["data"]["task_id"]);
          await Get.to(TaskItemExpanded(task));
          Get.back();
        },
        child: Text("Yes"),
      ),
      cancel: FlatButton(
        onPressed: () {
          Get.back();
        },
        child: Text("No"),
      ),
    );
  };

  _firebaseMessaging.configure(
    onMessage: (message) async {
      print(message);
      if (message["notification"]["title"] == "Task finished")
        await _showTaskOpenDialog(message);
      else
        Get.snackbar(
          message["notification"]["title"],
          message["notification"]["body"],
        );
    },
    onLaunch: _showTaskOpenDialog,
    onResume: (message) async => Future.delayed(
      Duration(seconds: 2),
      _showTaskOpenDialog(message),
    ),
  );

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
    return KeyedSubtree(
      key: key,
      child: RepositoryProvider<AlterEgoHTTPClient>(
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
                  mediaAPIClient: context.repository<IDrivingVideoApiClient>(),
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
              BlocProvider<LoginCubit>(
                create: (context) => LoginCubit(
                  authenticationCubit: context.bloc<AuthenticationCubit>(),
                  userApiClient: context.repository<IUserApiClient>(),
                ),
              ),
            ],
            child: App(),
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
        navigatorKey: Get.key,
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
              return Scaffold();
            }
            if (state is AuthenticationLoading) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
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
