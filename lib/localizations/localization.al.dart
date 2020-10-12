// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unnecessary_const, constant_identifier_names

// **************************************************************************
// AutoLocalizedGenerator
// **************************************************************************

import 'package:auto_localized/auto_localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@immutable
class AutoLocalizedData {
  static const supportedLocales = <Locale>[
    Locale('pl'),
    Locale('en', 'US'),
  ];

  static const delegate = AutoLocalizationDelegate(supportedLocales);

  static const localizationsDelegates = [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    delegate,
  ];
}

extension AutoLocalizedContextExtension on BuildContext {
  List<Locale> get supportedLocales => AutoLocalizedData.supportedLocales;

  List<LocalizationsDelegate> get localizationsDelegates =>
      AutoLocalizedData.localizationsDelegates;

  String translate(
    LocalizedString string, [
    String arg1 = "",
    String arg2 = "",
    String arg3 = "",
    String arg4 = "",
    String arg5 = "",
  ]) =>
      string.when(
        plain: (string) => string.get(this),
        arg1: (string) => string.get(arg1, this),
        arg2: (string) => string.get(arg1, arg2, this),
        arg3: (string) => string.get(arg1, arg2, arg3, this),
        arg4: (string) => string.get(arg1, arg2, arg3, arg4, this),
        arg5: (string) => string.get(arg1, arg2, arg3, arg4, arg5, this),
      );
}

@immutable
class Strings {
  static const loading = PlainLocalizedString(
    key: 'loading',
    values: {
      'pl': '''Ładowanie''',
      'en_US': '''Loading''',
    },
  );

  static const refresh = PlainLocalizedString(
    key: 'refresh',
    values: {
      'pl': '''Odśwież''',
      'en_US': '''Refresh''',
    },
  );

  static const loginLogin = PlainLocalizedString(
    key: 'login_login',
    values: {
      'pl': '''Zaloguj''',
      'en_US': '''Login''',
    },
  );

  static const loginRegister = PlainLocalizedString(
    key: 'login_register',
    values: {
      'pl': '''Zarejestruj się''',
      'en_US': '''Register''',
    },
  );

  static const loginEnterValue = PlainLocalizedString(
    key: 'login_enter_value',
    values: {
      'pl': '''Proszę wprowadź wartość''',
      'en_US': '''Please enter a value''',
    },
  );

  static const loginYourLogin = PlainLocalizedString(
    key: 'login_your_login',
    values: {
      'pl': '''Twój login''',
      'en_US': '''Your login''',
    },
  );

  static const loginYourPassword = PlainLocalizedString(
    key: 'login_your_password',
    values: {
      'pl': '''Twoje hasło''',
      'en_US': '''Your password''',
    },
  );

  static const loginYourNickname = PlainLocalizedString(
    key: 'login_your_nickname',
    values: {
      'pl': '''Twój pseudonim''',
      'en_US': '''Your nickname''',
    },
  );

  static const loginYourEmail = PlainLocalizedString(
    key: 'login_your_email',
    values: {
      'pl': '''Twój email''',
      'en_US': '''Your email''',
    },
  );

  static const homepagesDashboard = PlainLocalizedString(
    key: 'homepages_dashboard',
    values: {
      'pl': '''Start''',
      'en_US': '''Dashboard''',
    },
  );

  static const homepagesImages = PlainLocalizedString(
    key: 'homepages_images',
    values: {
      'pl': '''Zdjęcia''',
      'en_US': '''Images''',
    },
  );

  static const homepagesDrivingVideos = PlainLocalizedString(
    key: 'homepages_driving_videos',
    values: {
      'pl': '''Oryginalne filmy''',
      'en_US': '''Driving videos''',
    },
  );
}
