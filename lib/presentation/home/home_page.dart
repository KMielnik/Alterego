import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:alterego/blocs/media_list/media_list_cubit.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alterego/blocs/home/home_pages.dart';

import 'media_lists/media_lists.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<MediaListCubit>(
          create: (_) => MediaListCubit(
            imageApiClient: context.repository<IImageApiClient>(),
          ),
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                _getAppBar(context, state),
                if (state is ImagesPageLoaded) MediaListWidget(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.pageType.index,
              items: HomePageType.values
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: Icon(e.icon),
                      title: Text(e.name),
                    ),
                  )
                  .toList(),
              backgroundColor: Colors.white,
              onTap: (index) {
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
  );
}
