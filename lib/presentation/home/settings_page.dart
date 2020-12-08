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
      appBar: AppBar(
        title: Text("Settings"),
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
                    title: "Server",
                    children: [
                      TextInputSettingsTile(
                        settingKey: SettingsOptions.serverAddressKey,
                        initialValue: "https://10.0.2.2/api",
                        title: "Address",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MyRoundedButton(
              Text("Save settings"),
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
