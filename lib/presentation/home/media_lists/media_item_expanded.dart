import 'dart:io';
import 'dart:typed_data';

import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:alterego/presentation/home/media_lists/media_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  @override
  void dispose() {
    super.dispose();
    _vpcontroller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFEFEFEFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Column(children: [
          Hero(
            tag: "${widget.mediafile.filename}_thumbnail",
            child: FutureBuilder<Uint8List>(
              initialData: widget.mediafile.thumbnail,
              future: context
                  .repository<T>()
                  .downloadSpecifiedToTemp(filename: widget.mediafile.filename)
                  .then((value) async {
                if (!(T == IImageApiClient)) {
                  _vpcontroller = VideoPlayerController.file(File(value));
                  await _vpcontroller.initialize();
                }
                return value;
              }).then((value) => T == IImageApiClient
                      ? File(value).readAsBytes()
                      : Uint8List(0)),
              builder: (context, snapshot) {
                final hasNewData = snapshot.data != widget.mediafile.thumbnail;

                if (snapshot.hasData)
                  return AnimatedSwitcher(
                    switchInCurve: Curves.fastOutSlowIn,
                    switchOutCurve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 500),
                    child: ClipPath(
                      clipper: ImageClipper(),
                      child: T == IImageApiClient || !hasNewData
                          ? Image.memory(
                              snapshot.data,
                              key: Key(
                                  (snapshot.data == widget.mediafile.thumbnail)
                                      .toString()),
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  VideoPlayer(_vpcontroller),
                                  if (!_vpcontroller.value.isPlaying)
                                    Center(
                                      child: Material(
                                        child: IconButton(
                                          iconSize: 36,
                                          icon: Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            await _vpcontroller.play();
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  );

                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text("Error retrieving data."),
                  ),
                );
              },
            ),
          ),
          Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _getInfoCard("Name", widget.mediafile.originalFilename),
                        _getInfoCard("Expires on",
                            DateFormat().format(widget.mediafile.existsUntill)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Row(
                      children: [
                        Expanded(
                          child: _getOutlinedButton(
                            Strings.refresh.get(context),
                            () {
                              setState(() {
                                context
                                    .bloc<MediaListCubit<T>>()
                                    .refreshLifetimeMedia(
                                        widget.mediafile.filename);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child:
                              _getOutlinedButton("Save to gallery", () async {
                            Permission.accessMediaLocation.request();
                            final file = await context
                                .repository<T>()
                                .downloadSpecifiedToTemp(
                                    filename: widget.mediafile.filename);
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(content: Text(file)));

                            await ImageGallerySaver.saveFile(file);
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
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
