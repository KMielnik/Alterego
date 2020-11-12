import 'package:alterego/blocs/create_task/create_task_cubit.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/interfaces/ITaskApiClient.dart';
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
      create: (context) => CreateTaskCubit(
        context.repository<ITaskApiClient>(),
      ),
      child: BlocConsumer<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          if (state is CreateTaskError)
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
        },
        builder: (context, state) {
          if (state is CreateTaskInitial) {
            context
                .bloc<MediaListCubit<IImageApiClient>>()
                .getAllActive()
                .then(
                  (value) => context
                      .bloc<MediaListCubit<IDrivingVideoApiClient>>()
                      .getAllActive(),
                )
                .then((value) => context.bloc<CreateTaskCubit>().startPicker());
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            extendBody: true,
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
                state is CreateTaskSelectImage
                    ? Strings.createTaskSelectImageTitle.get(context)
                    : Strings.createTaskSelectDrivingvideoTitle.get(context),
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: state is CreateTaskInitial
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      if (state is CreateTaskSelectImage)
                        MediaListWidget<IImageApiClient>(
                          selectionMode: true,
                        ),
                      if (state is CreateTaskSelectVideo)
                        MediaListWidget<IDrivingVideoApiClient>(
                          selectionMode: true,
                        ),
                      if (state is CreateTaskSending)
                        SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _MediafileDragTarget(false, state),
                    _MediafileDragTarget(true, state),
                    Expanded(
                      child: (state is CreateTaskSelectImage ||
                              state is CreateTaskSelectVideo ||
                              state is CreateTaskError)
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_right_alt,
                                size: 48,
                              ),
                              color: Theme.of(context).accentColor,
                              disabledColor: Colors.grey,
                              onPressed: (state.image != null &&
                                      state.drivingVideo != null)
                                  ? () {
                                      context
                                          .bloc<CreateTaskCubit>()
                                          .sendNewTask();
                                    }
                                  : null,
                            )
                          : (state is CreateTaskSending)
                              ? Center(child: CircularProgressIndicator())
                              : (state is CreateTaskSent)
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context).accentColor,
                                      size: 48,
                                    )
                                  : Container(),
                    ),
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
          var empytContainer = Container(
            color: Colors.white,
            child: DottedBorder(
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
            ),
          );

          return Container(
            margin: EdgeInsets.all(candidates.length == 0 ? 8.0 : 4.0),
            height: double.infinity,
            child: mediafileInfo == null
                ? empytContainer
                : Dismissible(
                    background: empytContainer,
                    key: ValueKey(isDrivingVideo),
                    direction: DismissDirection.vertical,
                    child: Center(
                      child: Image.memory(mediafileInfo.thumbnail),
                    ),
                    onDismissed: (direction) {
                      context.bloc<CreateTaskCubit>().reset(
                          resetImage: !isDrivingVideo,
                          resetDrivingVideo: isDrivingVideo);
                    },
                  ),
          );
        },
      ),
    );
  }
}
