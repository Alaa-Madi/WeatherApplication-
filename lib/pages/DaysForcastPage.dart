import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather.dart';
import 'package:weatherapp/weatherServices/weatherApi.dart';
import 'package:weatherapp/model/dayWeather.dart';
import 'package:weatherapp/model/hourWeather.dart';
import 'package:weatherapp/pages/HourForcastPage.dart';

class dayForcastPage extends StatefulWidget {
  final String city;
  final List<Weather> weatherData;

  const dayForcastPage({Key? key, required this.city, required this.weatherData}) : super(key: key);

  @override
  State<dayForcastPage> createState() => _dayForcastPage();
}

class _dayForcastPage extends State<dayForcastPage> {
  late Future<List<DayWeather>> dayData;

  @override
  void initState() {
    super.initState();
    dayData = _fetchDailyData();
  }

  Future<List<DayWeather>> _fetchDailyData() async {
    try {
      final response = await WeatherService().fetchDailyData(widget.city);
      if (response.containsKey('error')) {
        throw Exception('API Error: ${response['error']['message']}');
      }
      final List<DayWeather> forecastData = (response['forecast']['forecastday'] as List).map((dayData) => DayWeather.fromJson(dayData)).toList();
      return forecastData;
    } catch (e) {
      print('Error in _fetchDailyData: $e');

      throw Exception('Failed to load daily forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Daily Forecast - ${widget.city}',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<List<DayWeather>>(
        future: dayData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<DayWeather> dailyForecast = snapshot.data!;
            return _buildDailyForecastList(dailyForecast);
          }
        },
      ),
    );
  }

  Widget _buildDailyForecastList(List<DayWeather> dailyForecast) {
    return ListView.builder(
      itemCount: dailyForecast.length,
      itemBuilder: (context, index) {
        DayWeather dayForecast = dailyForecast[index];
        return GestureDetector(
          onDoubleTap: () {
            _navigateToWeatherDetails(context, dayForecast);
          },
          child: _buildDayForecastItem(dayForecast),
        );
      },
    );
  }

  Widget _buildDayForecastItem(DayWeather dayForecast) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('${dayForecast.date}\n${dayForecast.condition}'),
        subtitle: Text('High: ${dayForecast.high}°C\nLow: ${dayForecast.low}°C'),
        leading: Image.network(
          "http:${dayForecast.icon}",
          height: 40.0,
          width: 40.0,
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HourForcastPage(cityName: widget.city,),
              ),
            );
          },
          child: const Text('Show on Map'),
        ),
      ),
    );
  }
  void _navigateToWeatherDetails(BuildContext context,DayWeather dayWeather) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => HourForcastPage(cityName: WeatherService.city,),
      )
    );
  }
}
