import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recepi_app/data/appstate.dart';
import 'package:recepi_app/data/get-it.dart';
import 'package:recepi_app/ui/screens/home.dart';
import 'package:recepi_app/ui/screens/login-screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _appstate = getIt.get<AppState>();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      _appstate.initAuth();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _appstate.isAuthenticated,
        builder: (context, AsyncSnapshot<bool> auth) {
          if (auth.data == true) {
            return HomeScreen();
          } else if (auth.data == false) {
            return LoginScreen();
          }
          return Splash();
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.amberAccent,
                  child: Icon(
                    MdiIcons.bowl,
                    color: Colors.black,
                    size: 70,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "The Recepi",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
