import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recepi_app/data/get-it.dart';

import 'ui/screens/splash-screen.dart';

void main() async {
  //this Registers a singleton for the global appstate
  new GetItInstance();

  //the following is to set default orientation for the app
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((clbk) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recepi App',
        theme: ThemeData(
            splashColor: Colors.amberAccent,
            fontFamily: "Avenir",
            unselectedWidgetColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            bottomSheetTheme: BottomSheetThemeData(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)))),
            appBarTheme: AppBarTheme(
                color: Colors.amberAccent,
                textTheme: TextTheme(
                    title: TextStyle(color: Colors.black, fontSize: 20)))),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
