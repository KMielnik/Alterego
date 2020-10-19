import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alterego/blocs/home/home_pages.dart';
import 'package:flutter_speed_dial_material_design/flutter_speed_dial_material_design.dart';

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
        BlocProvider<MediaListCubit<IResultVideoApiClient>>(
          create: (_) => MediaListCubit<IResultVideoApiClient>(
            mediaAPIClient: context.repository<IResultVideoApiClient>(),
          ),
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state.pageType.index == 0
                ? AppBar(title: Text(state.pageType.name))
                : null,
            extendBody: true,
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
                if (state is ResultVideosPageLoaded)
                  MediaListWidget<IResultVideoApiClient>(),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 58,
                    width: double.infinity,
                  ),
                )
              ],
            ),
            bottomNavigationBar: ClipPath(
              clipper: BottomNavigationBarClipper(),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
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
            ),
            floatingActionButton: SpeedDialFloatingActionButton(
              actions: [
                SpeedDialAction(
                  child: Icon(Icons.image),
                ),
              ],
              childOnFold: Icon(
                Icons.add,
                key: UniqueKey(),
              ),
              childOnUnfold: Icon(Icons.ac_unit),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
          );
        },
      ),
    );
  }
}

class BottomNavigationBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20;
    double dockRadius = 25;

    var path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width / 2 - dockRadius, 0)
      ..arcToPoint(
        Offset(size.width / 2, dockRadius),
        radius: Radius.circular(dockRadius),
        clockwise: false,
      )
      ..arcToPoint(
        Offset(size.width / 2 + dockRadius, 0),
        radius: Radius.circular(dockRadius),
        clockwise: false,
      )
      ..lineTo(size.width / 2 - radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

_getAppBar(BuildContext context, HomeState state) {
  return SliverAppBar(
    title: Text(state.pageType.name),
    floating: true,
    snap: true,
  );
}
