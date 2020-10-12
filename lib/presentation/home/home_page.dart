import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alterego/blocs/home/home_pages.dart';

import 'media_lists/media_lists.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<MediaListCubit<IImageApiClient>>(
          create: (_) => MediaListCubit<IImageApiClient>(
            mediaAPIClient: context.repository<IImageApiClient>(),
          ),
        ),
        BlocProvider<MediaListCubit<IDrivingVideoApiClient>>(
          create: (_) => MediaListCubit<IDrivingVideoApiClient>(
            mediaAPIClient: context.repository<IDrivingVideoApiClient>(),
          ),
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state.pageType.index == 0
                ? AppBar(title: Text(state.pageType.name))
                : null,
            body: CustomScrollView(
              controller: _scrollController,
              physics: state.pageType.index == 0
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              slivers: [
                if (state.pageType.index != 0) _getAppBar(context, state),
                if (state is DashboardPageLoaded)
                  SliverFillRemaining(
                    child: Center(
                      child: Text("IN PROGRESS"),
                    ),
                  ),
                if (state is ImagesPageLoaded)
                  MediaListWidget<IImageApiClient>(),
                if (state is DrivingVideosPageLoaded)
                  MediaListWidget<IDrivingVideoApiClient>(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.pageType.index,
              items: HomePageType.values
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: Icon(e.icon),
                      label: e.name,
                    ),
                  )
                  .toList(),
              backgroundColor: Colors.white,
              onTap: (index) {
                if (state.pageType.index == index) return;
                context
                    .bloc<HomeCubit>()
                    .navigatePage(HomePageType.values[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

_getAppBar(BuildContext context, HomeState state) {
  return SliverAppBar(
    title: Text(state.pageType.name),
    floating: true,
    snap: true,
  );
}
