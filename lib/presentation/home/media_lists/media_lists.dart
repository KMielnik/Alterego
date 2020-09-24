import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'media_item.dart';

class MediaListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaListCubit, MediaListState>(
      builder: (context, state) {
        var filesAvailable = state is MediaListLoaded ? state.items.length : 0;
        return SliverStaggeredGrid.countBuilder(
          crossAxisCount: 2,
          itemCount: filesAvailable,
          itemBuilder: (context, index) {
            return MediaItem((state as MediaListLoaded).items[index]);
          },
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 8.0,
        );
      },
    );
  }
}
