import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/view/weather_services/weather_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //api key
  final _weatherService = WeatherService("23474f85c62038615d08f2d30942d65e");
  WeatherModel? _weatherModel;

  //fetching of weather
  fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weatherModel = weather;
      });
    }
    //if any errors
    catch (e) {
      print(e);
    }
  }

  //whether animations

  String getWhetherAnimation(String? mainCondition) {
    if (mainCondition == null)
      return "assets/animations/Animation - 1709534821879.json";

    switch (mainCondition.toLowerCase()) {
      case "clouds":
        return "assets/animations/Animation - 1709534692905.json";

      default:
        return "assets/animations/Animation - 1709534821879.json";
    }
  }

  //init state

  @override
  void initState() {
    super.initState();
    //fetching the weather

    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weatherModel?.cityName ?? "Loading city...."),
            Lottie.asset(getWhetherAnimation(_weatherModel?.mainCondition)),

            //temperature
            Text("${_weatherModel?.temperature.round()} *C"),
            //weather condition
            Text(_weatherModel?.mainCondition ?? " ")
          ],
        ),
      ),
    );
  }
}
