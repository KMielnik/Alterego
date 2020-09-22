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
        return "Dashboard";
      case HomePageType.images:
        return "Images";
      case HomePageType.drivingvideos:
        return "Driving videos";
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
