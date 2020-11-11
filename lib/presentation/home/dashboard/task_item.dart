import 'dart:math';

import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/presentation/utilities/rounded_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatefulWidget {
  TaskItemWidget(this.task);

  final AnimationTaskDTO task;

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  Image _getThumbnailWidget(MediafileInfo mediafileInfo) {
    if (mediafileInfo == null)
      return Image.asset(
        "assets/images/placeholder.png",
        key: Key("placeholder"),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    else
      return Image.memory(
        mediafileInfo.thumbnail,
        key: ValueKey(mediafileInfo.filename),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    )..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: "${widget.task.id}_thumbnail",
              child: ClipPath(
                clipper: RoundedClipper(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: min(_animation.value + 0.3, 1.0),
                      child: _getThumbnailWidget(widget.task.sourceImage),
                    ),
                    Opacity(
                      opacity: min(1.0 - _animation.value, 1.0),
                      child: _getThumbnailWidget(widget.task.sourceVideo),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(widget.task.status.toString()),
                ],
              )),
        ],
      ),
    );
  }
}
