import 'package:alterego/blocs/home/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        appBar: _getAppBar(context),
        body: Container(
          child: Text("Hey"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              title: Text("1"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              title: Text("2"),
            ),
          ],
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Incerement",
          child: Icon(Icons.add),
          onPressed: () {},
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}

_getAppBar(context) {
  return AppBar(
    title: Text("Hello"),
  );
}
