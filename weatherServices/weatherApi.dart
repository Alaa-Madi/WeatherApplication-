import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weather.dart';

class WeatherService {
  static const String apiKey = 'add69c6b7092436e8ff83106232211';
  static const String city = 'London';

  Future<Map<String, dynamic>> fetchWData(String city) async {
    final response = await http.get(Uri.parse('http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Weather>> fetchWeatherForCities() async {
    const List<String> cities = [
      'Paris',
      'London',
      'Jerusalem',
      'Hebron',
      'Nablus',
      'Ramallah',
      'Doha'
    ];
    final List<Weather> weatherDataList = [];

    for (final city in cities) { // I can use Map function
      final response = await fetchWData(city);
      weatherDataList.add(Weather.fromJson(response));
    }
    // cities.map((city) => )
    return weatherDataList;
  }
}