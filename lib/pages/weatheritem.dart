import 'package:flutter/material.dart';
import 'package:weatherapp/model/dayWeather.dart';
import 'package:weatherapp/model/weather.dart';
import 'package:weatherapp/weatherServices/weatherApi.dart';
// import 'package:weatherapp/pages/weatheritem.dart';
import 'package:weatherapp/pages/DaysForcastPage.dart';

// ... (previous imports)

class WeatherItem extends StatefulWidget {
  const WeatherItem({Key? key}) : super(key: key);

  @override
  State<WeatherItem> createState() => _WeatherItemState();
}

class _WeatherItemState extends State<WeatherItem> {
  late Future<List<Weather>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData =_fetchCitiesData();
  }
  Future<List<Weather>> _fetchCitiesData() async {
    try {
      final citiesData = await WeatherService().fetchWeatherForCities();
      return citiesData;
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('City Weather', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Weather>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Weather> weatherList = snapshot.data!;
            return _buildWeatherList(weatherList);
          }
        },
      ),
    );
  }

  Widget _buildWeatherList(List<Weather> weatherList) {
    return ListView.builder(
      itemCount: weatherList.length,
      itemBuilder: (context, index) {
        final Weather weather = weatherList[index];
        return GestureDetector(
          onDoubleTap: ()async {
              // List<DayWeather> forecastData = (await WeatherService.city) as List<DayWeather>;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Builder(builder: (context){
                    return dayForcastPage(city: WeatherService.city, weatherData: weatherList);
                  }
                  ),
                ),
              );

          },
          child: _buildWeatherCard(weather),
        );
      },
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.city,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    '${weather.temperature} °C',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    weather.condition,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 1,
              child: Image.network(
                "http:${weather.image}",
                height: 64.0,
                width: 64.0,
              ),
            ),
          ],
        ),
      ),
    );
  }


}