import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/DaysForcastPage.dart';

class Weather {
  String city;
  String image;
  double temperature;
  String condition;

  Weather({
    required this.city,
    required this.image,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      return Weather(
        city: json['location']['name']as String  ,
        temperature: json['current']['temp_c'] as double,
        image: json['current']['condition']['icon'] ,
        condition: json['current']['condition']['text'] as String  ,

      );
    } catch (e) {
      print('Error parsing JSON: $e');
      print('JSON: $json');
      return Weather(
        city: 'Unknown',
        temperature: 0.0,
        image: 'Unknown',
        condition: 'Unknown',
      );
    }
  }
}
