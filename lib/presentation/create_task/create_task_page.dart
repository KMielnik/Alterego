import 'package:alterego/blocs/create_task/create_task_cubit.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/presentation/home/media_lists/media_item.dart';
import 'package:alterego/presentation/home/media_lists/media_lists.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateTaskCubit>(
      create: (context) => CreateTaskCubit(),
      child: BlocConsumer<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is CreateTaskInitial)
            context.bloc<MediaListCubit<IImageApiClient>>().getAllActive();
          if (state is CreateTaskImageSelected)
            context
                .bloc<MediaListCubit<IDrivingVideoApiClient>>()
                .getAllActive();

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    context.bloc<CreateTaskCubit>().reset();
                  },
                ),
              ],
              elevation: 0,
              title: Text(
                state is CreateTaskInitial
                    ? Strings.createTaskSelectImageTitle.get(context)
                    : Strings.createTaskSelectDrivingvideoTitle.get(context),
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [
                if (state is CreateTaskInitial)
                  MediaListWidget<IImageApiClient>(
                    selectionMode: true,
                  ),
                if (state is CreateTaskImageSelected)
                  MediaListWidget<IDrivingVideoApiClient>(
                    selectionMode: true,
                  ),
              ],
            ),
            bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _MediafileDragTarget(false, state),
                    _MediafileDragTarget(true, state),
                    Expanded(
                        child: IconButton(
                      icon: Icon(
                        Icons.arrow_right_alt,
                        size: 48,
                      ),
                      onPressed: () {
                        //TODO: Creating task and sending it.
                      },
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MediafileDragTarget extends StatelessWidget {
  final bool isDrivingVideo;
  final CreateTaskState state;

  const _MediafileDragTarget(
    this.isDrivingVideo,
    this.state, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediafileInfo = isDrivingVideo ? state.drivingVideo : state.image;

    return Expanded(
      flex: 2,
      child: DragTarget<MediafileInfo>(
        onWillAccept: (mediaFileInfo) => isDrivingVideo
            ? mediaFileInfo.filename.endsWith(".mp4")
            : mediaFileInfo.filename.endsWith(".jpg") ||
                mediaFileInfo.filename.endsWith(".jpeg"),
        onAccept: (mediaFileInfo) {
          isDrivingVideo
              ? context
                  .bloc<CreateTaskCubit>()
                  .selectDrivingVideo(mediaFileInfo)
              : context.bloc<CreateTaskCubit>().selectImage(mediaFileInfo);
        },
        builder: (context, candidates, rejects) {
          return Container(
            margin: EdgeInsets.all(8.0),
            height: double.infinity,
            child: mediafileInfo == null
                ? DottedBorder(
                    padding: EdgeInsets.all(8.0),
                    strokeWidth: 3,
                    dashPattern: [4, 4],
                    child: Center(
                      child: Text(
                        isDrivingVideo
                            ? Strings.createTaskDragHereVideo.get(context)
                            : Strings.createTaskDragHereImage.get(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    color: Colors.black,
                  )
                : Image.memory(mediafileInfo.thumbnail),
          );
        },
      ),
    );
  }
}
