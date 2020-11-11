import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/dashboard/dashboard_cubit.dart';
import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:alterego/models/animator/animation_task_dto.dart';
import 'package:alterego/presentation/home/dashboard/task_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, authenticationState) {
        return BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardStateInitial) {
              context.bloc<DashboardCubit>().refresh();
              return Container();
            }
            return Container(
              child: Column(
                children: [
                  Text(
                      "Hey ${(authenticationState as AuthenticationAuthenticated).nickname}"),
                  OutlinedButton(
                    onPressed: () => context.bloc<DashboardCubit>().refresh(),
                    child: Text("Refresh"),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Builder(
                      builder: (context) {
                        if (state is DashboardStateInitial)
                          return Container();
                        else if (state is DashboardStateLoading)
                          return Center(child: CircularProgressIndicator());
                        else if (state is DashboardStateLoaded)
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.items.length,
                            itemBuilder: (context, i) {
                              return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4),
                                  child: TaskItemWidget(state.items[i]));
                            },
                          );
                        else
                          return Container();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
