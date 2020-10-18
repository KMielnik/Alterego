part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  final HomePageType pageType;

  const HomeState(this.pageType);

  @override
  List<Object> get props => [pageType];
}

class HomePageLoading extends HomeState {
  HomePageLoading(HomePageType pageType) : super(pageType);
}

class HomePageError extends HomeState {
  final String error;

  HomePageError(HomePageType pageType, this.error) : super(pageType);

  @override
  List<Object> get props => [pageType, error];
}

class DashboardPageLoaded extends HomeState {
  DashboardPageLoaded() : super(HomePageType.dashboard);
}

class ImagesPageLoaded extends HomeState {
  ImagesPageLoaded() : super(HomePageType.images);
}

class DrivingVideosPageLoaded extends HomeState {
  DrivingVideosPageLoaded() : super(HomePageType.drivingvideos);
}

class ResultVideosPageLoaded extends HomeState {
  ResultVideosPageLoaded() : super(HomePageType.resultvideos);
}
