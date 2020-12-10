import 'dart:math';

import 'package:alterego/exceptions/app_exception.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:alterego/net/interfaces/ITaskApiClient.dart';
import 'package:alterego/presentation/home/media_lists/media_item_expanded.dart';
import 'package:alterego/presentation/login/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskItemExpanded extends StatefulWidget {
  final AnimationTaskDTO task;

  TaskItemExpanded(this.task);

  @override
  _TaskItemExpandedState createState() => _TaskItemExpandedState(task);
}

class _TaskItemExpandedState extends State<TaskItemExpanded>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  AnimationTaskDTO task;

  _TaskItemExpandedState(this.task);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      lowerBound: 0.0,
      upperBound: 1.0,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          Future.delayed(Duration(milliseconds: 800),
              () => _animationController.reverse());
        else if (status == AnimationStatus.dismissed)
          Future.delayed(Duration(milliseconds: 1500),
              () => _animationController.forward());
      })
      ..forward();
  }

  Widget _getRoundedImageOrDefault<T extends IMediaApiClient>(
      MediafileInfo mediafile) {
    Image image;
    if (mediafile?.thumbnail == null)
      image = Image.asset(
        "assets/images/placeholder.png",
        fit: BoxFit.cover,
      );
    else
      image = Image.memory(
        mediafile.thumbnail,
        fit: BoxFit.fill,
      );

    return GestureDetector(
      onTap: () {
        if (mediafile?.isAvailable ?? false)
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MediaItemExpanded<T>(mediafile),
              fullscreenDialog: true,
            ),
          );
      },
      child: AspectRatio(
        aspectRatio: 0.85,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  child: image,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              if (T == IImageApiClient)
                Strings.mediatypeImage.text(context: context),
              if (T == IDrivingVideoApiClient)
                Strings.mediatypeDrivingVideo.text(context: context),
              if (T == IResultVideoApiClient)
                Strings.mediatypeResultVideo.text(context: context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Task details"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24.0),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: _getInfoCard("Task ID", task.id),
                ),
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Hero(
                    tag: "${task.id}_thumbnail",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.rotate(
                          alignment: Alignment.bottomRight,
                          angle: pi / 2 * _animationController.value,
                          child: Opacity(
                            opacity: max(1.0 - _animationController.value, 0.6),
                            child: _getRoundedImageOrDefault<IImageApiClient>(
                              task.sourceImage,
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: -pi / 2 * _animationController.value,
                          alignment: Alignment.bottomLeft,
                          child: Opacity(
                            opacity: max(1.0 - _animationController.value, 0.6),
                            child: _getRoundedImageOrDefault<
                                IDrivingVideoApiClient>(
                              task.sourceVideo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * 0.2) *
                      _animationController.value,
                  child: _getRoundedImageOrDefault<IResultVideoApiClient>(
                    task.resultAnimation,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    _getInfoCard(
                      Strings.status.get(context),
                      task.status.toString().split(".").last,
                    ),
                    _getInfoCard(
                      "Retain audio",
                      task.retainAudio.toString(),
                    ),
                    _getInfoCard(
                      "Image padding",
                      task.imagePadding.toString(),
                    ),
                  ],
                ),
              ),
              MyRoundedButton(
                Strings.refresh.text(context: context),
                () async {
                  try {
                    var newTask = await context
                        .repository<ITaskApiClient>()
                        .getOne(task.id);

                    task = newTask;
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Couldn't refresh task, error: ${(e as AppException).toString()}",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getInfoCard(String title, String body) {
  return Expanded(
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
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
