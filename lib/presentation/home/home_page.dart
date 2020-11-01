import 'dart:math';
import 'dart:ui';

import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:alterego/localizations/localization.al.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IDrivingVideoApiClient.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IResultVideoApiClient.dart';
import 'package:alterego/presentation/create_task/create_task_page.dart';
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
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is ImagesPageLoaded)
            context.bloc<MediaListCubit<IImageApiClient>>().getAllMedia();
          if (state is DrivingVideosPageLoaded)
            context
                .bloc<MediaListCubit<IDrivingVideoApiClient>>()
                .getAllMedia();
          if (state is ResultVideosPageLoaded)
            context.bloc<MediaListCubit<IResultVideoApiClient>>().getAllMedia();

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            extendBody: true,
            body: Stack(
              children: [
                RefreshIndicator(
                  strokeWidth: 3,
                  onRefresh: () async {
                    if (state is ImagesPageLoaded)
                      await context
                          .bloc<MediaListCubit<IImageApiClient>>()
                          .refreshMedia();
                    if (state is DrivingVideosPageLoaded)
                      await context
                          .bloc<MediaListCubit<IDrivingVideoApiClient>>()
                          .refreshMedia();
                    if (state is ResultVideosPageLoaded)
                      await context
                          .bloc<MediaListCubit<IResultVideoApiClient>>()
                          .refreshMedia();
                  },
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: state.pageType.index == 0
                          ? NeverScrollableScrollPhysics()
                          : BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        _MediaPageAppBar(
                          state: state,
                          key: ValueKey(state.pageType),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(top: 12),
                        ),
                        if (state is DashboardPageLoaded)
                          SliverFillRemaining(
                            child: Center(
                              child: Text("IN PROGRESS"),
                            ),
                          ),
                        if (state is ImagesPageLoaded)
                          MediaListWidget<IImageApiClient>(
                            key: ValueKey(IImageApiClient),
                          ),
                        if (state is DrivingVideosPageLoaded)
                          MediaListWidget<IDrivingVideoApiClient>(
                            key: ValueKey(IDrivingVideoApiClient),
                          ),
                        if (state is ResultVideosPageLoaded)
                          MediaListWidget<IResultVideoApiClient>(
                              key: ValueKey(IResultVideoApiClient)),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 58,
                            width: double.infinity,
                          ),
                        )
                      ],
                    ),
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
      scale: Tween<double>(begin: 0.0, end: 1).animate(_controller),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset.fromDirection(pi / 6 * (5 + (positionNumber * 2)), 2.0),
        ).animate(_controller),
        child: FloatingActionButton(
          backgroundColor: color,
          onPressed: func,
          child: icon,
          heroTag: positionNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          bottom: 34,
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.loose,
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
                func: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateTaskPage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
              _hiddenFAB(
                3,
                Icon(HomePageType.drivingvideos.icon),
                Colors.red,
                func: () {},
              ),
              _mainFAB(),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomNavigationBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20;
    double dockRadius = 22;

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

class _MediaPageAppBar extends StatefulWidget {
  final HomeState state;

  _MediaPageAppBar({Key key, this.state}) : super(key: key);

  @override
  __MediaPageAppBarState createState() => __MediaPageAppBarState();
}

class __MediaPageAppBarState extends State<_MediaPageAppBar> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(() {});
  }

  _onSearchbarChanged(String string) {
    MediaListCubit medialistCubit;

    if (widget.state is ImagesPageLoaded)
      medialistCubit = context.bloc<MediaListCubit<IImageApiClient>>();
    else if (widget.state is DrivingVideosPageLoaded)
      medialistCubit = context.bloc<MediaListCubit<IDrivingVideoApiClient>>();
    else if (widget.state is ResultVideosPageLoaded)
      medialistCubit = context.bloc<MediaListCubit<IResultVideoApiClient>>();

    medialistCubit.getFilteredList(string);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 28, left: 15),
        title: Text(widget.state.pageType.name),
      ),
      bottom: PreferredSize(
        child: Transform.translate(
          offset: Offset(MediaQuery.of(context).size.width * 0.15, 12),
          child: Container(
            height: 36,
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              controller: _searchController,
              onChanged: _onSearchbarChanged,
              decoration: new InputDecoration(
                isDense: true,
                labelText: Strings.search.get(context),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.white,
                filled: true,
                suffix: _searchController.text.length > 0
                    ? IconButton(
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchbarChanged("");
                          FocusScope.of(context).requestFocus(FocusNode());
                        })
                    : null,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(0),
      ),
      floating: true,
      snap: true,
    );
  }
}
