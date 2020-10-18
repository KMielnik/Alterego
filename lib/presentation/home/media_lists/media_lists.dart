import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'media_item.dart';

class MediaListWidget<T extends IMediaApiClient> extends StatefulWidget {
  MediaListWidget({Key key, this.selectionMode = false}) : super(key: key);

  final Type apiType = T;
  final bool selectionMode;

  @override
  _MediaListWidgetState<T> createState() => _MediaListWidgetState();
}

class _MediaListWidgetState<T extends IMediaApiClient>
    extends State<MediaListWidget<T>> {
  @override
  void initState() {
    refreshMedia();
    super.initState();
  }

  void refreshMedia() {
    if (widget.selectionMode)
      context.bloc<MediaListCubit<T>>().getAllActive();
    else
      context.bloc<MediaListCubit<T>>().getAllMedia();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaListCubit<T>, MediaListState>(
      builder: (context, state) {
        if (state is MediaListInitial) {
          refreshMedia();
          return SliverFillRemaining();
        } else if (state is MediaListLoading) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is MediaListLoaded) {
          var filesAvailable =
              state is MediaListLoaded ? state.items.length : 0;

          return SliverStaggeredGrid.countBuilder(
            crossAxisCount: 2,
            itemCount: filesAvailable,
            itemBuilder: (context, index) {
              return MediaItem<T>(
                state.items[index],
                selectionMode: widget.selectionMode,
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 8.0,
          );
        } else {
          return SliverFillRemaining(
            child: Center(
              child: RaisedButton(
                child: Text(Strings.refresh.get(context)),
                onPressed: () => refreshMedia(),
              ),
            ),
          );
        }
      },
      listener: (context, state) {
        if (state is MediaListError)
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
      },
    );
  }
}
