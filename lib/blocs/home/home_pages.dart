import 'package:alterego/localizations/localization.al.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum HomePageType {
  dashboard,
  images,
  drivingvideos,
  resultvideos,
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
      case HomePageType.resultvideos:
        return Strings.homepagesResultVideos.get();
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
      case HomePageType.resultvideos:
        return Icons.animation;
      default:
        return null;
    }
  }
}
