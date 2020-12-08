import 'package:alterego/main.dart';
import 'package:flutter/cupertino.dart';

class SettingsRepository {
  String _serverAdress;

  set serverAdress(String adress) {
    _serverAdress = adress;
  }

  String get serverAdress {
    return _serverAdress;
  }

  void restartApp(BuildContext context) {
    AppWithState.restartApp(context);
  }
}
