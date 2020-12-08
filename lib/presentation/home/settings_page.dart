import 'package:alterego/blocs/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  final SettingsRepository repository;
  SettingsPage(this.repository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("XDDDDD"),
          Expanded(
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: "Server data",
                  tiles: [
                    SettingsTile(
                      title: "Address",
                      leading: Icon(Icons.hail),
                      onPressed: (context) {
                        repository.serverAdress = "http://10.0.2.2/api/";
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              context.repository<SettingsRepository>().restartApp(context);
            },
            child: Text("Save settings"),
          ),
        ],
      ),
    );
  }
}
