import 'dart:io';

import 'package:alterego/blocs/add_media/add_media_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddMediaPage extends StatelessWidget {
  // ignore: unused_element
  AddMediaPage._internal(this.mediaApiClient) : _pageTypeString = "";

  final String _pageTypeString;
  final IMediaApiClient mediaApiClient;

  // ignore: type_init_formals
  AddMediaPage.image(IImageApiClient this.mediaApiClient)
      : _pageTypeString = Strings.mediatypeImage.get().toLowerCase();

  // ignore: type_init_formals
  AddMediaPage.drivingVideo(IDrivingVideoApiClient this.mediaApiClient)
      : _pageTypeString = Strings.mediatypeDrivingVideo.get().toLowerCase();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMediaCubit>(
      create: (context) => AddMediaCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.addmediaAddNew.get(_pageTypeString, context),
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<AddMediaCubit, AddMediaState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SelectSourceButtonsWidget(mediaApiClient),
                if (state is AddMediaSelected)
                  _MediaPresentationWidget(state.createdMedia.path),
                if (state is AddMediaSelected)
                  FlatButton(
                    onPressed: () {
                      context.bloc<AddMediaCubit>().createAndSend(
                            "TEST",
                            mediaApiClient,
                          );
                    },
                    child: Strings.addmediaCreateAndSend.text(context: context),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MediaPresentationWidget extends StatelessWidget {
  final String mediaFilePath;

  const _MediaPresentationWidget(
    this.mediaFilePath, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 0.50,
          child: _VideoPlayer(mediaFilePath)),
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
  @override
  void initState() {
    super.initState();

    _vpcontroller = VideoPlayerController.file(File(widget.filePath));
    _vpcontroller.initialize().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    _vpcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _vpcontroller.value.aspectRatio,
      child: Stack(
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
          _ControlsOverlay(
            controller: _vpcontroller,
            refreshParent: () => setState(() {}),
          ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                (controller.value.isPlaying
                        ? controller.pause()
                        : controller.play())
                    .then((value) => refreshParent());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectSourceButtonsWidget extends StatelessWidget {
  final IMediaApiClient mediaApiClient;

  const _SelectSourceButtonsWidget(
    this.mediaApiClient, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Strings.addmediaFromCamera.text(context: context),
        ),
        ElevatedButton(
          onPressed: () async {
            final _picker = ImagePicker();
            PickedFile media;
            if (mediaApiClient is IImageApiClient)
              media = await _picker.getImage(source: ImageSource.gallery);
            else if (mediaApiClient is IDrivingVideoApiClient)
              media = await _picker.getVideo(source: ImageSource.gallery);

            if (media != null) context.bloc<AddMediaCubit>().selectMedia(media);
          },
          child: Strings.addmediaFromGallery.text(context: context),
        ),
      ],
    );
  }
}
