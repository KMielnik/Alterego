import 'dart:math';
import 'dart:ui';

import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
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
  HomeFAB fab;

  @override
  void initState() {
    _scrollController = ScrollController();
    fab = HomeFAB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<MediaListCubit<IImageApiClient>>(
          create: (context) => MediaListCubit<IImageApiClient>(
            mediaAPIClient: context.repository<IImageApiClient>(),
          ),
        ),
        BlocProvider<MediaListCubit<IDrivingVideoApiClient>>(
          create: (context) => MediaListCubit<IDrivingVideoApiClient>(
            mediaAPIClient: context.repository<IDrivingVideoApiClient>(),
          ),
        ),
        BlocProvider<MediaListCubit<IResultVideoApiClient>>(
          create: (context) => MediaListCubit<IResultVideoApiClient>(
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
            body: Stack(
              children: [
                RefreshIndicator(
                  strokeWidth: 3,
                  onRefresh: () async {
                    if (state is ImagesPageLoaded)
                      await context
                          .bloc<MediaListCubit<IImageApiClient>>()
                          .getAllMedia();
                    if (state is DrivingVideosPageLoaded)
                      await context
                          .bloc<MediaListCubit<IDrivingVideoApiClient>>()
                          .getAllMedia();
                    if (state is ResultVideosPageLoaded)
                      await context
                          .bloc<MediaListCubit<IResultVideoApiClient>>()
                          .getAllMedia();
                  },
                  child: CustomScrollView(
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
                ),
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
            floatingActionButton: fab,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
          );
        },
      ),
    );
  }
}

class HomeFAB extends StatefulWidget {
  HomeFAB({Key key}) : super(key: key);

  @override
  _HomeFABState createState() => _HomeFABState();
}

class _HomeFABState extends State<HomeFAB> with TickerProviderStateMixin {
  AnimationController _controller;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    );
  }

  Widget _mainFAB() {
    void _mainFABClicked() {
      setState(() {
        if (isExpanded) {
          isExpanded = false;
          _controller.reverse();
        } else {
          isExpanded = true;
          _controller.forward();
        }
      });
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) => RotationTransition(
        turns: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      ),
      child: FloatingActionButton(
        key: ValueKey(isExpanded),
        elevation: isExpanded ? 6 : 2,
        highlightElevation: isExpanded ? 8 : 4,
        onPressed: _mainFABClicked,
        child: Icon(Icons.add),
        mini: !isExpanded,
      ),
    );
  }

  Widget _hiddenFAB(
    int positionNumber,
    Icon icon,
    Color color, {
    Function() func,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(_controller),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset.fromDirection(pi / 6 * (5 + (positionNumber * 2)), 2.0),
        ).animate(_controller),
        child: FloatingActionButton(
          backgroundColor: color,
          onPressed: isExpanded ? func : null,
          child: icon,
          mini: true,
          heroTag: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        _hiddenFAB(
          1,
          Icon(HomePageType.images.icon),
          Colors.green,
          func: () {},
        ),
        _hiddenFAB(
          2,
          Icon(HomePageType.dashboard.icon),
          Colors.orange,
          func: () {},
        ),
        _hiddenFAB(
          3,
          Icon(HomePageType.drivingvideos.icon),
          Colors.red,
          func: () {},
        ),
        _mainFAB(),
      ],
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
