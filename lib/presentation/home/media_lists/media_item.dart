import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaItem<T extends IMediaApiClient> extends StatefulWidget {
  final MediafileInfo mediafile;

  const MediaItem(this.mediafile);

  @override
  _MediaItemState<T> createState() => _MediaItemState<T>();
}

class _MediaItemState<T extends IMediaApiClient> extends State<MediaItem<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: Card(
        key: Key(widget.mediafile.filename),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            ClipPath(
              clipper: ImageClipper(),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.mediafile.isAvailable
                      ? Colors.transparent
                      : Colors.grey,
                  BlendMode.saturation,
                ),
                child: Image.memory(
                  widget.mediafile.thumbnail,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          "${Strings.name.get(context)}: ",
                          style:
                              TextStyle().copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.mediafile.originalFilename),
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          "${Strings.mediaitemTimeLeft.get(context)}: ",
                          style:
                              TextStyle().copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.mediafile.isAvailable
                              ? _getDurationString(
                                  DateTime.parse(widget.mediafile.existsUntill)
                                      .difference(DateTime.now()))
                              : "deleted",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              maintainState: true,
              title: Text("Options"),
              children: [
                if (widget.mediafile.isAvailable)
                  FlatButton(
                    onPressed: () {
                      context
                          .bloc<MediaListCubit<T>>()
                          .refreshLifetimeMedia(widget.mediafile.filename);
                    },
                    child: Text("Refresh lifetime"),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                FlatButton(
                  onPressed: () {
                    context
                        .bloc<MediaListCubit<T>>()
                        .deleteMedia(widget.mediafile.filename);
                  },
                  child: Text("Delete"),
                  textColor: Colors.red,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String _getDurationString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20;

    var path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
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
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
