// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:weatherapp/model/city.dart';
// import 'package:weatherapp/model/weather.dart';
//
//
// class DatabaseProvider extends ChangeNotifier {
//   DatabaseProvider._privateConstructor();
//
//   static final DatabaseProvider db = DatabaseProvider._privateConstructor();
//   static Database? _database;
//   static const int version = 1;
//   final String tableName = 'Cities';
//
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await initDB();
//     return _database!;
//   }
//
//   Future<Database> initDB() async {
//     String path = join(await getDatabasesPath(), 'uniDB.db');
//     path = join(path, 'Cities.db');
//     return  openDatabase(
//         path,
//         version: version,
//         onCreate: (db, int version) async {
//           await db.execute(
//               '''
//           CREATE TABLE $tableName (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             CityName TEXT NOT NULL UNIQUE
//           )
//             '''
//           );
//         },
//         onUpgrade: (Database db, int oldversion, int newversion){
//
//         }
//     );
//   }
//
//   add(City city) async {
//     final db = await database;
//     db.insert('city', city.toMap());
//     notifyListeners();
//   }
//
//   void delete(Weather weather) async {
//     final db = await database;
//     await db.delete(
//       'cities',
//       where: 'cityName = ?',
//       whereArgs: [weather.city],
//     );
//     notifyListeners();
//   }
//
//
//   Future<List<City>> getAllCities() async {
//     final db = await database;
//     List<Map<String, dynamic>> results = await db.query(tableName);
//     List<City> cities = [];
//     for (var element in results) {
//       City city = City.fromMap(element);
//       cities.add(city);
//     }
//     return cities;
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weatherapp/model/city.dart';
import 'package:weatherapp/model/weather.dart';

class DatabaseProvider  extends ChangeNotifier {
  DatabaseProvider._privateConstructor();
  List<City>city=[];
  static final DatabaseProvider db = DatabaseProvider._privateConstructor();
  static Database? _database;
  static const int version = 1;
  final String tableName = 'Cities';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'uniDB.db');
    path = join(path, 'Cities.db');
    return openDatabase(
      path,
      version: version,
      onCreate: (db, int version) async {
        await db.execute(
            '''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            CityName TEXT NOT NULL UNIQUE
          )
          '''
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        // Handle database upgrade if needed
      },
    );
  }

  add(City city) async {
    final db = await database;
    db.insert(tableName, city.toMap());
    notifyListeners();
  }

  void deleteCity(City city) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'CityName = ?',
      whereArgs: [city.cityName],
    );
    notifyListeners();
  }

  Future<void> deleteWeather(Weather weather) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'CityName = ?',
      whereArgs: [weather.city],
    );
    notifyListeners();
  }


  Future<List<City>> getAllCities() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(tableName);
    List<City> cities = [];
    for (var element in results) {
      City city = City.fromMap(element);
      cities.add(city);
    }
    return cities;
  }
}
