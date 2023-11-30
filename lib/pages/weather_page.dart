// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather_app/services/weather_service.dart";

import "../models/weather_model.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api keys
  final _weatherService = WeatherService('152b97b0e58165b47ba16aca229b4ccf');
  Weather? _weather;

  // fetch the weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    // get weather for City
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // errors
    catch (e) {
      print(e);
    }
  }

  // wether animations
  String getWeatherAnimation(String? mainCondition) {
    imageCache.clear(); // Clear the image cache

    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // inital state
  @override
  void initState() {
    super.initState();

    // fetch weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // cityName
          Text(_weather?.cityName ?? 'loading city ...'),
          // animation
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          // temperature
          Text('${_weather?.temperature.round()}C'),
        ]),
      ),
    );
  }
}
