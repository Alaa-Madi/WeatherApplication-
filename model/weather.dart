import 'package:http/http.dart' as http;
import 'dart:convert';

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
        city: json['location']['name'] ?? 'Unknown',
        temperature: (json['current']['temp_c'] as num).toDouble() ?? 0.0,
        image: json['current']['condition']['icon'] ?? 'Unknown',
        condition: json['current']['condition']['text'] ?? 'Unknown',
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
