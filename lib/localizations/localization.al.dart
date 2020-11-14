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

  static const name = PlainLocalizedString(
    key: 'name',
    values: {
      'pl': '''Nazwa''',
      'en_US': '''Name''',
    },
  );

  static const options = PlainLocalizedString(
    key: 'options',
    values: {
      'pl': '''Opcje''',
      'en_US': '''Options''',
    },
  );

  static const delete = PlainLocalizedString(
    key: 'delete',
    values: {
      'pl': '''Usuń''',
      'en_US': '''Delete''',
    },
  );

  static const select = PlainLocalizedString(
    key: 'select',
    values: {
      'pl': '''Wybierz''',
      'en_US': '''Select''',
    },
  );

  static const search = PlainLocalizedString(
    key: 'search',
    values: {
      'pl': '''Szukaj''',
      'en_US': '''Search''',
    },
  );

  static const status = PlainLocalizedString(
    key: 'status',
    values: {
      'pl': '''Status''',
      'en_US': '''Status''',
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

  static const homepagesResultVideos = PlainLocalizedString(
    key: 'homepages_result_videos',
    values: {
      'pl': '''Animacje''',
      'en_US': '''Animations''',
    },
  );

  static const mediaitemTimeLeft = PlainLocalizedString(
    key: 'mediaitem_time_left',
    values: {
      'pl': '''Pozostały czas''',
      'en_US': '''Exists for''',
    },
  );

  static const mediaitemExpiresOn = PlainLocalizedString(
    key: 'mediaitem_expires_on',
    values: {
      'pl': '''Wygasa''',
      'en_US': '''Expires on''',
    },
  );

  static const mediaitemSaveToGallery = PlainLocalizedString(
    key: 'mediaitem_save_to_gallery',
    values: {
      'pl': '''Zapisz do galerii''',
      'en_US': '''Save to gallery''',
    },
  );

  static const mediaitemRefreshLifetime = PlainLocalizedString(
    key: 'mediaitem_refresh_lifetime',
    values: {
      'pl': '''Wydłuż życie''',
      'en_US': '''Refresh lifetime''',
    },
  );

  static const mediaitemExpired = PlainLocalizedString(
    key: 'mediaitem_expired',
    values: {
      'pl': '''Wygasło''',
      'en_US': '''Expired''',
    },
  );

  static const createTaskDragHereImage = PlainLocalizedString(
    key: 'create_task_drag_here_image',
    values: {
      'pl': '''Upuść zdjęcie tutaj''',
      'en_US': '''Drag image here''',
    },
  );

  static const createTaskDragHereVideo = PlainLocalizedString(
    key: 'create_task_drag_here_video',
    values: {
      'pl': '''Upuść film tutaj''',
      'en_US': '''Drag driving video here''',
    },
  );

  static const createTaskSelectImageTitle = PlainLocalizedString(
    key: 'create_task_select_image_title',
    values: {
      'pl': '''Wybierz zdjęcie''',
      'en_US': '''Select your image''',
    },
  );

  static const createTaskSelectDrivingvideoTitle = PlainLocalizedString(
    key: 'create_task_select_drivingvideo_title',
    values: {
      'pl': '''Wybierz film poruszający''',
      'en_US': '''Select driving video''',
    },
  );

  static const taskStatusNew = PlainLocalizedString(
    key: 'task_status_new',
    values: {
      'pl': '''Nowy''',
      'en_US': '''New''',
    },
  );

  static const taskStatusProcessing = PlainLocalizedString(
    key: 'task_status_processing',
    values: {
      'pl': '''W trakcie''',
      'en_US': '''Processing''',
    },
  );

  static const taskStatusFinished = PlainLocalizedString(
    key: 'task_status_finished',
    values: {
      'pl': '''Gotowy''',
      'en_US': '''Finished''',
    },
  );

  static const taskStatusFailed = PlainLocalizedString(
    key: 'task_status_failed',
    values: {
      'pl': '''Niepowodzenie''',
      'en_US': '''Failed''',
    },
  );

  static const taskCreatedOn = PlainLocalizedString(
    key: 'task_created_on',
    values: {
      'pl': '''Stworzony''',
      'en_US': '''Created''',
    },
  );

  static const taskResultAnimationDeleted = PlainLocalizedString(
    key: 'task_result_animation_deleted',
    values: {
      'pl': '''[Wynik usunięty]''',
      'en_US': '''[Animation deleted]''',
    },
  );

  static const errorRetrievingData = PlainLocalizedString(
    key: 'error_retrieving_data',
    values: {
      'pl': '''Błąd pobierania danych''',
      'en_US': '''Error retrieving data.''',
    },
  );
}
