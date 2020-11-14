import 'package:alterego/blocs/authentication/authentication_cubit.dart';
import 'package:alterego/blocs/dashboard/dashboard_cubit.dart';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 16.0),
                        child: Text(
                          "Hey ${(authenticationState as AuthenticationAuthenticated).nickname}",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0),
                          ),
                          color: Theme.of(context).accentColor,
                        ),
                        child: IconButton(
                          iconSize: 28,
                          onPressed: () =>
                              context.bloc<DashboardCubit>().refresh(),
                          icon: Icon(Icons.refresh),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
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
                                              0.45),
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
