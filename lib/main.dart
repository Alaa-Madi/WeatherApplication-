import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/pages/logoPage.dart';
import 'package:weatherapp/pages/WeatherItem.dart'; // Corrected import path
import 'package:weatherapp/pages/home.dart'; // Corrected import path
import 'package:weatherapp/providers/DataBaseProvider.dart';
import 'package:sqflite_common/sqlite_api.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/logo',
        routes: {
          '/logo': (context) => LogoPage(),
          '/home': (context) => Home(),
        },
    );
  }
}
