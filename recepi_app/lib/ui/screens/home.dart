import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/ui/screens/profile-screen.dart';

import 'add-recipe-screen.dart';
import 'feeds-screen.dart';

class HomeScreen extends StatelessWidget {
  final _appstate = getIt.get<AppState>();
  final List<Widget> _bodies = [
    FeedsScreen(),
    AddRecipeScreen(),
    ProfileScreen(
      mine: true,
    )
  ];
  final Color _selected = Colors.red;
  final Color _unselected = Colors.black;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0,
      stream: _appstate.currentBottomBarIndex,
      builder: (context, AsyncSnapshot<int> current) {
        return Scaffold(
          body: _bodies[current.data],
          floatingActionButton: FloatingActionButton(
            backgroundColor:
                current.data == 1 ? Colors.redAccent : Colors.amberAccent,
            child: Icon(
              Icons.add,
              size: 30,
              color: current.data == 1 ? Colors.white : _unselected,
            ),
            onPressed: () {
              if (current.data != 1) {
                _appstate.switchScreen(to: 1);
              }
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (current.data != 0) {
                        _appstate.switchScreen(to: 0);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            color: current.data == 0 ? _selected : _unselected,
                          ),
                          Text("Home", style: TextStyle())
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (current.data != 2) {
                        _appstate.switchScreen(to: 2);
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              color:
                                  current.data == 2 ? _selected : _unselected,
                            ),
                            Text("Profile", style: TextStyle())
                          ],
                        )),
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}
