import 'package:flutter/material.dart';

class RoundedClipper extends CustomClipper<Path> {
  final bool shouldClipTop;
  RoundedClipper({this.shouldClipTop = true});

  @override
  Path getClip(Size size) {
    double radius = 20;

    var path = Path()
      ..moveTo(size.width, radius)
      ..lineTo(size.width, size.height)
      ..arcToPoint(
        Offset(size.width - radius, size.height - radius),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(radius, size.height - radius)
      ..arcToPoint(
        Offset(0, size.height),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(0, radius);

    if (shouldClipTop) {
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));
    } else {
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, radius);
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
