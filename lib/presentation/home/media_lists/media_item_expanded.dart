import 'dart:io';
import 'dart:typed_data';

import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:alterego/presentation/utilities/rounded_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class MediaItemExpanded<T extends IMediaApiClient> extends StatefulWidget {
  final MediafileInfo mediafile;

  MediaItemExpanded(this.mediafile);

  @override
  _MediaItemExpandedState<T> createState() => _MediaItemExpandedState<T>();
}

class _MediaItemExpandedState<T extends IMediaApiClient>
    extends State<MediaItemExpanded<T>> {
  VideoPlayerController _vpcontroller;

  Future<String> _getFullResMediaDownloadFuture(BuildContext context) => context
      .repository<T>()
      .downloadSpecifiedToTemp(filename: widget.mediafile.filename);

  Future<void> _initializeVideo(BuildContext context) =>
      _getFullResMediaDownloadFuture(context).then((value) async {
        await _vpcontroller?.pause();
        await _vpcontroller?.dispose();
        _vpcontroller = VideoPlayerController.file(File(value));
        await _vpcontroller.initialize();
      });

  Future<Uint8List> _getOriginalImageFuture(BuildContext context) =>
      _getFullResMediaDownloadFuture(context)
          .then((value) => File(value).readAsBytes());

  @override
  void dispose() async {
    super.dispose();
    await _vpcontroller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75),
              child: Hero(
                tag: "${widget.mediafile.filename}_thumbnail",
                child: FutureBuilder<Uint8List>(
                  future: T == IImageApiClient
                      ? _getOriginalImageFuture(context)
                      : _initializeVideo(context)
                          .then((value) => Future.value(Uint8List(0))),
                  builder: (context, snapshot) {
                    return ClipPath(
                      clipper: RoundedClipper(shouldClipTop: false),
                      child: !snapshot.hasData
                          ? widget.mediafile.thumbnail == null
                              ? Image.asset(
                                  "assets/images/placeholder.png",
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                )
                              : Image.memory(
                                  widget.mediafile.thumbnail,
                                  width: double.infinity,
                                  gaplessPlayback: true,
                                  fit: BoxFit.fitWidth,
                                )
                          : snapshot.hasError
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(Strings.errorRetrievingData
                                        .get(context)),
                                  ),
                                )
                              : T == IImageApiClient
                                  ? Image.memory(
                                      snapshot.data,
                                      width: double.infinity,
                                      gaplessPlayback: true,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : _VideoPlayer(vpcontroller: _vpcontroller),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _getInfoCard(Strings.name.get(context),
                              widget.mediafile.originalFilename),
                          _getInfoCard(
                              Strings.mediaitemExpiresOn.get(context),
                              DateFormat()
                                  .format(widget.mediafile.existsUntill)),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        children: [
                          Expanded(
                            child: _getOutlinedButton(
                              Strings.refresh.get(context),
                              null,
                            ),
                          ),
                          Expanded(
                            child: _getOutlinedButton(
                              Strings.mediaitemSaveToGallery.get(context),
                              null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({
    Key key,
    @required VideoPlayerController vpcontroller,
  })  : _vpcontroller = vpcontroller,
        super(key: key);

  final VideoPlayerController _vpcontroller;

  @override
  __VideoPlayerState createState() => __VideoPlayerState();
}

class __VideoPlayerState extends State<_VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomCenter,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
              height: widget._vpcontroller.value.size.height,
              width: widget._vpcontroller.value.size.width,
              child: VideoPlayer(widget._vpcontroller),
            ),
          ),
          _ControlsOverlay(
            controller: widget._vpcontroller,
            refreshParent: () => setState(() {}),
          ),
          VideoProgressIndicator(
            widget._vpcontroller,
            allowScrubbing: true,
            padding: EdgeInsets.symmetric(vertical: 25),
            colors:
                VideoProgressColors(playedColor: Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({
    Key key,
    this.controller,
    this.refreshParent,
  }) : super(key: key);

  final VideoPlayerController controller;
  final Function() refreshParent;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 50),
            reverseDuration: Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? SizedBox.shrink()
                : Container(
                    color: Colors.black26,
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              (controller.value.isPlaying
                      ? controller.pause()
                      : controller.play())
                  .then((value) => refreshParent());
            },
          ),
        ],
      ),
    );
  }
}

Widget _getOutlinedButton(String text, Function func) {
  return OutlinedButton(
    onPressed: func,
    child: Text(
      text,
    ),
  );
}

Widget _getInfoCard(String title, String body) {
  return Expanded(
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle().copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
