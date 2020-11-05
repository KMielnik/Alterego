import 'package:flutter_bloc/flutter_bloc.dart';

import 'fab_expand_state.dart';

class FabExpandCubit extends Cubit<FabExpandState> {
  FabExpandCubit() : super(FabCollapsedState());

  Future<void> expandFAB() async {
    emit(FabExpandedState());
  }

  Future<void> collapseFAB() async {
    emit(FabCollapsedState());
  }
}
