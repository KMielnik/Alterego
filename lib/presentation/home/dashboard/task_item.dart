import 'dart:math';

import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/presentation/utilities/rounded_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Row _getStatusText(Statuses status) {
    var statusTitle = Text(
      "${Strings.status.get(context)}: ",
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    Text statusText;

    switch (status) {
      case Statuses.New:
        statusText = Strings.taskStatusNew.text(context: context);
        break;
      case Statuses.Processing:
        statusText = Strings.taskStatusProcessing.text(context: context);
        break;
      case Statuses.Done:
      case Statuses.Notified:
        statusText = Strings.taskStatusFinished.text(context: context);
        break;
      case Statuses.Failed:
        statusText = Strings.taskStatusFailed.text(
          context: context,
          style: TextStyle(color: Colors.red),
        );
        break;
    }

    return Row(
      children: [statusTitle, statusText],
      mainAxisSize: MainAxisSize.min,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameLength =
        widget.task.resultAnimation?.originalFilename?.length ?? 0;
    final nameDesiredLength = min(35, nameLength);
    final name = (widget.task.resultAnimation?.originalFilename
                ?.substring(0, nameDesiredLength) ??
            Strings.taskResultAnimationDeleted.get(context)) +
        (nameDesiredLength < nameLength ? "..." : "");
    return Column(
      children: [
        Card(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.1,
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
                padding: EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          "${Strings.name.get(context)}: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(name),
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          "${Strings.taskCreatedOn.get(context)}: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(DateFormat("MMM-d H:m")
                            .format(widget.task.createdAt)),
                      ],
                    ),
                    _getStatusText(widget.task.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
