//help for fetching the data

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;
  WeatherService(this.apiKey);

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse("$baseUrl?q=$cityName&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
    //for permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //fetch current location

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert the location into list of placemark object

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extrathe city name from the first placemark
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
