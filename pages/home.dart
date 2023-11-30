// import 'package:flutter/material.dart';
// import 'package:weatherapp/model/weather.dart';
// import 'package:weatherapp/weatherServices/weatherApi.dart';
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   late Future<List<Weather>> weatherData;
//
//   @override
//   void initState() {
//     super.initState();
//     weatherData = WeatherService().fetchWeatherForCities();
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Weather Application', style: TextStyle(color: Colors.white)),
//       ),
//       body: FutureBuilder<List<Weather>>(
//         future: weatherData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.blue,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final List<Weather> weatherList = snapshot.data!;
//             final Weather londonWeather = _getLondonWeather(weatherList);
//             return _buildWeatherUI(londonWeather);
//           }
//         },
//       ),
//     );
//   }
//
//   Weather _getLondonWeather(List<Weather> weatherList) {
//
//     return weatherList.firstWhere((weather) => weather.city == 'London');
//   }
//
//   Widget _buildWeatherUI(Weather weather) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             weather.city,
//             style: const TextStyle(fontSize: 24.0),
//           ),
//           const SizedBox(height: 16.0),
//           Text(
//             '${weather.temperature} °C',
//             style: const TextStyle(fontSize: 24.0),
//           ),
//           const SizedBox(height: 16.0),
//           Text(
//             weather.condition,
//             style: const TextStyle(fontSize: 24.0),
//           ),
//           const SizedBox(height: 16.0),
//           Image.network(
//             "http:${weather.image}",
//             height: 64.0,
//             width: 64.0,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather.dart';
import 'package:weatherapp/weatherServices/weatherApi.dart';
import 'package:weatherapp/pages/weatheritem.dart'; // Import the WeatherItem page

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Weather>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = WeatherService().fetchWeatherForCities();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Weather Application', style: TextStyle(color: Colors.black)),
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
            final Weather londonWeather = _getLondonWeather(weatherList);
            return _buildWeatherUI(context, londonWeather);
          }
        },
      ),
    );
  }

  Weather _getLondonWeather(List<Weather> weatherList) {
    // Assuming 'London' is present in the weatherList
    return weatherList.firstWhere((weather) => weather.city == 'London');
  }

  Widget _buildWeatherUI(BuildContext context, Weather weather) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 16.0),
          Image.network(
            "http:${weather.image}",
            height: 64.0,
            width: 64.0,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherItem()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Go to WeatherItem',
                style: TextStyle(fontSize: 12.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
