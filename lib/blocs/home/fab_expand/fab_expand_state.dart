import 'package:equatable/equatable.dart';

abstract class FabExpandState extends Equatable {
  const FabExpandState();

  @override
  List<Object> get props => [];
}

class FabExpandedState extends FabExpandState {}

class FabCollapsedState extends FabExpandState {}
