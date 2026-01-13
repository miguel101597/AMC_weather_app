import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'services/weather_service.dart';
import 'models/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherScreen(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;
  final String _cityName = 'Manila'; // Default city

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService.getWeather(_cityName);
  }


  Widget _getWeatherIcon(String iconCode) {
    final String iconUrl = 'https://openweathermap.org/img/wn/$iconCode@4x.png';
    return Image.network(
      iconUrl,
      width: 150,
      height: 150,
      fit: BoxFit.cover,

      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(
          width: 150,
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      // Optional: Add an error builder for the icon
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.cloud_off, size: 150, color: Colors.white70);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(

        child: FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }


            if (snapshot.hasError) {
              // Extract the specific error message from the exception
              final errorMessage = snapshot.error.toString().replaceFirst('Exception: ', '');
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            }


            if (snapshot.hasData) {
              final weather = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      weather.city,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weather.description,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeatherDetail('Humidity', '${weather.humidity}%'),
                        _buildWeatherDetail('Wind', '${weather.windSpeed} m/s'),
                      ],
                    ),
                  ],
                ),
              );
            }


            return const Text('Enter a city to get the weather.');
          },
        ),
      ),
    );
  }


  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}