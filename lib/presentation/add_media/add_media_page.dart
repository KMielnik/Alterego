import 'dart:io';

import 'package:alterego/blocs/add_media/add_media_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';

class AddMediaPage extends StatelessWidget {
  // ignore: unused_element
  AddMediaPage._internal(this.mediaApiClient, String pageTypeString)
      : _pageTypeString = pageTypeString,
        _filenameController = TextEditingController();

  final String _pageTypeString;
  final IMediaApiClient mediaApiClient;
  final TextEditingController _filenameController;

  // ignore: type_init_formals
  AddMediaPage.image(IImageApiClient mediaApiClient)
      : this._internal(
          mediaApiClient,
          Strings.mediatypeImage.get().toLowerCase(),
        );

  // ignore: type_init_formals
  AddMediaPage.drivingVideo(IDrivingVideoApiClient mediaApiClient)
      : this._internal(
          mediaApiClient,
          Strings.mediatypeDrivingVideo.get().toLowerCase(),
        );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMediaCubit>(
      create: (context) => AddMediaCubit(),
      child: GestureDetector(
        onTap: () {
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(Strings.addmediaAddNew.get(_pageTypeString, context),
                style: TextStyle(color: Colors.black)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    context.bloc<AddMediaCubit>().reset();
                    _filenameController.clear();
                  },
                ),
              ),
            ],
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BlocConsumer<AddMediaCubit, AddMediaState>(
            listener: (context, state) {
              if (state is AddMediaError)
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state is AddMediaInitial)
                    _SelectSourceButtonsWidget(mediaApiClient),
                  if (state is AddMediaSelected)
                    _MediaPresentationWidget(
                      state.createdMedia.path,
                      mediaApiClient is IDrivingVideoApiClient,
                    ),
                  if (state is AddMediaSelected)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 4.0, bottom: 4.0),
                              child: TextField(
                                controller: _filenameController,
                                maxLength: 30,
                                maxLengthEnforced: true,
                                buildCounter: (
                                  _, {
                                  currentLength,
                                  maxLength,
                                  isFocused,
                                }) =>
                                    null,
                                decoration: InputDecoration(
                                  hintText:
                                      Strings.addmediaNewName.get(context),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          MyRoundedButton(
                            Strings.addmediaCreateAndSend
                                .text(context: context),
                            () {
                              if (_filenameController.text == null ||
                                  _filenameController.text.isEmpty) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Enter correct name for new media."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              context.bloc<AddMediaCubit>().createAndSend(
                                    _filenameController.text,
                                    mediaApiClient,
                                  );

                              _filenameController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MediaPresentationWidget extends StatelessWidget {
  final String mediaFilePath;

  final Widget _mediaWidget;

  _MediaPresentationWidget(
    this.mediaFilePath,
    bool isVideo, {
    Key key,
  })  : _mediaWidget = isVideo
            ? _VideoPlayer(mediaFilePath)
            : Image.file(
                File(mediaFilePath),
                gaplessPlayback: true,
              ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Expanded(flex: 10, child: _mediaWidget),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String filePath;

  _VideoPlayer(
    this.filePath, {
    Key key,
  }) : super(key: key);

  @override
  __VideoPlayerState createState() => __VideoPlayerState();
}

class __VideoPlayerState extends State<_VideoPlayer> {
  VideoPlayerController _vpcontroller;
  Widget _videoWidget = _getPlaceholderImageWidget();

  @override
  void initState() {
    super.initState();

    _vpcontroller = VideoPlayerController.file(File(widget.filePath));
    _vpcontroller.initialize().then((value) => setState(() {
          _videoWidget = _getVideoPlayer();
        }));
  }

  @override
  void dispose() {
    _vpcontroller.dispose();
    super.dispose();
  }

  Widget _getVideoPlayer() => Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomCenter,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
              height: _vpcontroller.value.size.height,
              width: _vpcontroller.value.size.width,
              child: VideoPlayer(_vpcontroller),
            ),
          ),
          _ControlsOverlay(controller: _vpcontroller),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _vpcontroller,
              allowScrubbing: true,
              padding: EdgeInsets.only(bottom: 4.0),
              colors: VideoProgressColors(
                  playedColor: Theme.of(context).accentColor),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: _vpcontroller.value.aspectRatio,
        child: _videoWidget,
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({
    Key key,
    this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 50),
            reverseDuration: Duration(milliseconds: 200),
            child: widget.controller.value.isPlaying
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                (widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play())
                    .then((value) => setState(() {}));
              },
            ),
          ),
        ],
      ),
    );
  }
}

final ImagePicker _picker = ImagePicker();

class _SelectSourceButtonsWidget extends StatelessWidget {
  final IMediaApiClient mediaApiClient;

  const _SelectSourceButtonsWidget(
    this.mediaApiClient, {
    Key key,
  }) : super(key: key);

  Future<PickedFile> _getMedia(ImageSource source) async {
    PickedFile media;
    if (mediaApiClient is IImageApiClient)
      media = await _picker.getImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
    else if (mediaApiClient is IDrivingVideoApiClient) {
      media = await _picker.getVideo(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: Duration(minutes: 1),
      );
      var file = File(media.path);
      file = await file.rename("${p.withoutExtension(file.path)}.mp4");
      media = PickedFile(file.path);
    }

    return media;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MyRoundedButton(
          Strings.addmediaFromCamera.text(context: context),
          () async {
            final media = await _getMedia(ImageSource.camera);
            context.bloc<AddMediaCubit>().selectMedia(media);
          },
        ),
        MyRoundedButton(
          Strings.addmediaFromGallery.text(context: context),
          () async {
            final media = await _getMedia(ImageSource.gallery);
            context.bloc<AddMediaCubit>().selectMedia(media);
          },
        ),
      ],
    );
  }
}

Widget _getPlaceholderImageWidget() => Image.asset(
      "assets/images/placeholder.png",
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
