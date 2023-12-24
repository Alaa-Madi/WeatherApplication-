import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/model/city.dart';
import 'package:weatherapp/model/weather.dart';
import 'package:weatherapp/model/dayWeather.dart';
import 'package:weatherapp/model/hourWeather.dart';

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
      'London',
     'Jerusalem',
      'Algiers',
      'Hebron',
      'Paris',
      'Nablus',
      'Ramallah',
      'Doha',
      'Riyadh',
      'Manama',
      'Dubai',
      'Nicosia',
      'Copenhagen',
      'Beijing',
      'Brussels',
      'Kabul',
      'Mariehamn',
      'Minsk',
      'Athens',
      'Rome',
      'Riga',
      'Kyiv',
      'Moscow',
      'Lisbon',
      'Quite',
      'Lima',
      '	Mexico City',
      '	Manila',
      'Sanaa',
      'Seoul',
      '	Luanda',
      '	Accra',
      '	Rabat',
      'Tunis',
    ];
    final List<Weather> weatherDataList =[];

    for (final city in cities) { // I can use Map function
      final response = await fetchWData(city);
      weatherDataList.add(Weather.fromJson(response));
    }
    return weatherDataList;
  }

  //fetch daily data
  Future<Map<String, dynamic>> fetchDailyData(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch daily forecast data');
    }
  }

  //fetch hourly data
  Future<List<HourlyWeather>> fetchHourlyForecastData(String cityName) async {
    try {
      final response = await fetchDailyData(cityName);


       final forecastDayList = response['forecast']['forecastday'] as List?;

      if (forecastDayList != null && forecastDayList.isNotEmpty) {
        final hourlyData = forecastDayList[0]['hour'] as List?;

        if (hourlyData != null) {
          final List<HourlyWeather> hourlyForecast = hourlyData
              .map((hourData) => HourlyWeather.fromJson(hourData))
              .toList();

          return hourlyForecast;
        }
      }

      throw Exception('Failed to extract hourly forecast data from the response');
    } catch (e) {
      throw Exception('Failed to load hourly forecast data: $e');
    }
  }


}

