import 'package:flutter/material.dart';
import 'package:weatherapp/weatherServices/weatherApi.dart';
import 'package:weatherapp/model/hourWeather.dart';

class HourForcastPage extends StatelessWidget {
  final String cityName;

  const HourForcastPage({Key? key, required this.cityName})
      : super(key: key);

  Future<List<HourlyWeather>> _fetchHourlyForecastData(String cityName) async {
    try {
      final List<HourlyWeather> hourlyForecast =
      await WeatherService().fetchHourlyForecastData(cityName);
      print('Hourly Forecast Data: $hourlyForecast');
      return hourlyForecast;
    } catch (e) {
      throw Exception('Failed to load hourly forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hourly Forecast - $cityName',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
        // Background Image from URL
        Image.asset(
        'assets/BACK.jpg',
        fit: BoxFit.cover, // Set the fit property to cover the full page
      ),
          FutureBuilder<List<HourlyWeather>>(
        future: _fetchHourlyForecastData(cityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<HourlyWeather> hourlyForecast = snapshot.data!;
            return Center(
              child: _buildHourlyForecastList(hourlyForecast));
          }
        },
          )],
      )
    );
  }


  Widget _buildHourlyForecastList(List<HourlyWeather> hourlyForecast) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: hourlyForecast
              .map(
                (hourlyWeather) => Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${hourlyWeather.time.day}-${hourlyWeather.time.month}-${hourlyWeather.time.year}'
                          '\n${hourlyWeather.time.hour}:${hourlyWeather.time.minute}',
                    ),
                    const SizedBox(height: 8.0),
                    Text('${hourlyWeather.temperature} °C'),
                    const SizedBox(height: 8.0),
                    Image.network("http:${hourlyWeather.icon}"),
                  ],
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}


