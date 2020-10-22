import 'package:alterego/blocs/home/home_pages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomePageLoading(HomePageType.dashboard));

  Future<void> navigatePage(HomePageType pageType) async {
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
      case HomePageType.resultvideos:
        await _navigateResultVideosPage();
        break;
    }
  }

  Future<void> _navigateDashboardpage() async {
    emit(HomePageLoading(HomePageType.dashboard));

    emit(DashboardPageLoaded());
  }

  Future<void> _navigateImagesPage() async {
    emit(HomePageLoading(HomePageType.images));

    emit(ImagesPageLoaded());
  }

  Future<void> _navigateDrivingVideosPage() async {
    emit(HomePageLoading(HomePageType.drivingvideos));

    emit(DrivingVideosPageLoaded());
  }

  Future<void> _navigateResultVideosPage() async {
    emit(HomePageLoading(HomePageType.resultvideos));

    emit(ResultVideosPageLoaded());
  }
}
