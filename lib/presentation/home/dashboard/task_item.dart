import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatelessWidget {
  TaskItemWidget(this.task);

  final AnimationTaskDTO task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(task.resultAnimation.originalFilename),
    );
  }
}
