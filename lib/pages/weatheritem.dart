import 'package:flutter/material.dart';
import 'package:weatherapp/model/city.dart';
import 'package:weatherapp/model/weather.dart';
import 'package:weatherapp/weatherServices/weatherApi.dart';
import 'package:weatherapp/pages/DaysForcastPage.dart';
import '../providers/DataBaseProvider.dart';


class WeatherItem extends StatefulWidget {
  const WeatherItem({Key? key}) : super(key: key);

  @override
  State<WeatherItem> createState() => _WeatherItemState();
}

class _WeatherItemState extends State<WeatherItem> {
  late Future<List<Weather>> updatedWeatherData;
  TextEditingController cityNameController = TextEditingController();


  @override
  void initState() {
    super.initState();
    updatedWeatherData = _fetchCitiesData();
  }

  Future<List<Weather>> _fetchCitiesData() async {
    try {
      final citiesData = await WeatherService().fetchWeatherForCities();
      return citiesData;
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }


  Future<List<City>> _fetchDatabaseCities() async {
    try {
      return await DatabaseProvider.db.getAllCities();
    } catch (e) {
      throw Exception('Failed to load cities from the database: $e');
    }
  }

  _showDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add City', style: TextStyle(fontSize: 22.0, color: Colors.indigo)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(color: Colors.black, height: 2),
              TextField(
                controller: cityNameController,
                decoration: const InputDecoration(labelText: 'City Name'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (cityNameController.text.isEmpty) {
                const snackBar = SnackBar(content: Text('Please fill the field'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              City city = City(cityName: cityNameController.text);
              print('City object created: $city'); // Add this line
              DatabaseProvider.db.add(city);

              cityNameController.clear();

              // Wait for the local database data to be updated before updating the UI
              await _updateWeatherData();

              // Show Snackbar with the added city's name
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('City added: ${city.cityName}'),
                  duration: Duration(seconds: 2),
                ),
              );

              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),


          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateWeatherData() async {
    setState(() {
      updatedWeatherData = _fetchDatabaseCities() as Future<List<Weather>>;
    });
  }



  Widget _buildWeatherList(List<Weather> weatherList) {
    return ListView.builder(
      itemCount: weatherList.length,
      itemBuilder: (context, index) {
        final Weather weather = weatherList[index];
        return GestureDetector(
          onDoubleTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => dayForcastPage(city: weather.city, weatherData: weatherList),
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
                  Text(weather.city, style: const TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 16.0),
                  Text('${weather.temperature} °C', style: const TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 16.0),
                  Text(weather.condition, style: const TextStyle(fontSize: 24.0)),
                ],
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.network(
                    "http:${weather.image}",
                    height: 64.0,
                    width: 64.0,
                  ),
                  IconButton(
                    onPressed: () {
                      if (weather is City) {
                        DatabaseProvider.db.deleteCity(weather as City);
                      } else if (weather is Weather) {
                        DatabaseProvider.db.deleteWeather(weather);
                      }
                      setState(() {
                        updatedWeatherData = _fetchCitiesData();
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('City Weather', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch<String>(
                context: context,
                delegate: CitySearchDelegate(weatherList: await updatedWeatherData),
              );

              if (query != null && query.isNotEmpty) {
                final weatherData = await _fetchCitiesData();

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => dayForcastPage(city: query, weatherData: weatherData),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FutureBuilder<List<Weather>>(
            future: updatedWeatherData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<Weather> weatherList = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: _buildWeatherList(weatherList),
                    ),
                    _buildAddButton(),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  final List<Weather> weatherList;

  CitySearchDelegate({required this.weatherList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final result = weatherList.firstWhere(
          (weather) => weather.city.toLowerCase().contains(query.toLowerCase()),
    );

    if (result != null) {
      close(context, result.city);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('City not found'),
            content: Text('The city "$query" was not found. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = weatherList
        .where((weather) => weather.city.toLowerCase().contains(query.toLowerCase()))
        .map((weather) => ListTile(
      title: Text(weather.city),
      onTap: () {
        close(context, weather.city);
      },
    ))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => suggestions[index],
    );
  }
}
