import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaItem extends StatefulWidget {
  final MediafileInfo mediafile;

  const MediaItem(this.mediafile);

  @override
  _MediaItemState createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(widget.mediafile.filename),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          ClipPath(
            clipper: ImageClipper(),
            child: Image.memory(
              widget.mediafile.thumbnail,
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(widget.mediafile.filename),
              ],
            ),
          ),
          Text(DateTime.parse(widget.mediafile.existsUntill)
              .difference(DateTime.now())
              .toString()),
          ExpansionTile(
            maintainState: true,
            title: Text("Options"),
            children: [
              FlatButton(
                onPressed: () {},
                child: Text("Refresh lifetime"),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              FlatButton(
                onPressed: () {
                  context
                      .bloc<MediaListCubit>()
                      .deleteImage(widget.mediafile.filename);
                },
                child: Text("Delete"),
                textColor: Colors.red,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          )
        ],
      ),
    );
  }
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
