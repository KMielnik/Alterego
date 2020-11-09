import 'dart:async';

import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:alterego/presentation/home/media_lists/media_item_expanded.dart';
import 'package:alterego/presentation/utilities/rounded_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaItem<T extends IMediaApiClient> extends StatelessWidget {
  final MediafileInfo mediafile;
  final bool selectionMode;

  const MediaItem(this.mediafile, {this.selectionMode = true});
  @override
  Widget build(BuildContext context) {
    var card = Card(
      key: Key(mediafile.filename),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Hero(
            tag: "${mediafile.filename}_thumbnail",
            child: ClipPath(
              clipper: RoundedClipper(),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  mediafile.isAvailable ? Colors.transparent : Colors.grey,
                  BlendMode.saturation,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (mediafile.isAvailable)
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MediaItemExpanded<T>(mediafile),
                          fullscreenDialog: true,
                        ),
                      );
                  },
                  child: Image.memory(
                    mediafile.thumbnail,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                ),
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
                      Text(mediafile.originalFilename),
                    ],
                  ),
                  _ExistsForWidget(mediafile: mediafile),
                ],
              ),
            ),
          ),
          if (!selectionMode)
            ClipPath(
              child: ExpansionTile(
                title: Text(Strings.options.get(context)),
                children: [
                  if (mediafile.isAvailable)
                    FlatButton(
                      onPressed: () {
                        context
                            .bloc<MediaListCubit<T>>()
                            .refreshLifetimeMedia(mediafile.filename);
                      },
                      child:
                          Text(Strings.mediaitemRefreshLifetime.get(context)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  FlatButton(
                    onPressed: () {
                      context
                          .bloc<MediaListCubit<T>>()
                          .deleteMedia(mediafile.filename);
                    },
                    child: Text(Strings.delete.get(context)),
                    textColor: Colors.red,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          if (selectionMode) SizedBox(height: 24.0),
        ],
      ),
    );
    if (!mediafile.isAvailable || !selectionMode) return card;
    return LongPressDraggable<MediafileInfo>(
      dragAnchor: DragAnchor.pointer,
      feedback: ClipRRect(
        child: Image.memory(
          mediafile.thumbnail,
          width: 128,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      data: mediafile,
      child: card,
    );
  }
}

class _ExistsForWidget extends StatefulWidget {
  const _ExistsForWidget({
    Key key,
    @required this.mediafile,
  }) : super(key: key);

  final MediafileInfo mediafile;

  @override
  _ExistsForWidgetState createState() => _ExistsForWidgetState();
}

class _ExistsForWidgetState extends State<_ExistsForWidget> {
  Timer refreshTimer;

  @override
  void initState() {
    super.initState();
    refreshTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(() {
        if (!widget.mediafile.isAvailable) refreshTimer?.cancel();
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    refreshTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          "${Strings.mediaitemTimeLeft.get(context)}: ",
          style: TextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          widget.mediafile.isAvailable
              ? _getDurationString(
                  widget.mediafile.existsUntill.difference(DateTime.now()),
                )
              : Strings.mediaitemExpired.get(context),
        ),
      ],
    );
  }
}

String _getDurationString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
