import 'package:alterego/localizations/localization.al.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum HomePageType {
  dashboard,
  images,
  drivingvideos,
}

extension HomePageTypeExtension on HomePageType {
  String get name {
    switch (this) {
      case HomePageType.dashboard:
        return Strings.homepagesDashboard.get();
      case HomePageType.images:
        return Strings.homepagesImages.get();
      case HomePageType.drivingvideos:
        return Strings.homepagesDrivingVideos.get();
      default:
        return null;
    }
  }

  IconData get icon {
    switch (this) {
      case HomePageType.dashboard:
        return Icons.ac_unit;
      case HomePageType.images:
        return Icons.image;
      case HomePageType.drivingvideos:
        return Icons.video_call;
      default:
        return null;
    }
  }
}
