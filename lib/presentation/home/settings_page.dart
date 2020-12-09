import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/main.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsOptions {
  static const String serverAddressKey = "serverAddressKey";
}

class SettingsPage extends StatelessWidget {
  SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Strings.settings.text(context: context),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0))),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SettingsContainer(
                children: [
                  SettingsGroup(
                    title: Strings.settingsGroupServer.get(context),
                    children: [
                      TextInputSettingsTile(
                        settingKey: SettingsOptions.serverAddressKey,
                        initialValue: "https://10.0.2.2/api/",
                        title: Strings.settingsTitleAddress.get(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MyRoundedButton(
              Strings.settingsRestart.text(context: context),
              () {
                AppWithState.restartApp(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
