import 'package:alterego/blocs/home/home_pages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomePageLoading(HomePageType.dashboard));

  Future navigatePage(HomePageType pageType) async {
    emit(HomePageLoading(pageType));

    switch (pageType) {
      case HomePageType.dashboard:
        await _navigateDashboardpage();
        break;
      case HomePageType.images:
        await _navigateImagesPage();
        break;
      case HomePageType.drivingvideos:
        await _navigateDrivingVideosPage();
        break;
    }
  }

  Future _navigateDashboardpage() async {
    emit(HomePageLoading(HomePageType.dashboard));

    emit(DashboardPageLoaded());
  }

  Future _navigateImagesPage() async {
    emit(HomePageLoading(HomePageType.images));

    emit(ImagesPageLoaded());
  }

  Future _navigateDrivingVideosPage() async {
    emit(HomePageLoading(HomePageType.drivingvideos));

    emit(DrivingVideosPageLoaded());
  }
}
