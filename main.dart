import 'package:flutter/material.dart';
import 'package:weatherapp/pages/logoPage.dart';
// import 'package:weatherapp/pages//WeatherItem.dart';
import 'package:weatherapp/pages//home.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/logo',
      routes: {
        '/logo': (context) => LogoPage(),
        '/home': (context) => Home(),
      },
    );
  }
}
