import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaListCubit, MediaListState>(
      builder: (context, state) {
        var filesAvailable = state is MediaListLoaded ? state.items.length : 0;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return index >= filesAvailable
                  ? CircularProgressIndicator()
                  : Text("Hej ${(state as MediaListLoaded).items[index]}");
            },
            childCount: filesAvailable + 1,
          ),
        );
      },
    );
  }
}
