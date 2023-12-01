import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_forecasting/apiModels/current_weather_model.dart';
import 'package:weather_forecasting/apiModels/forecast_weather_model.dart';
import 'package:weather_forecasting/utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  static const lat = 23.8105;
  static const lng = 90.3372;

  double _latitude = 0.0;
  double _longitude = 0.0;

  String unit = metric;
  CurrentWeatherModel? currentWeatherModel;
  ForecastWeatherModel? forecastWeatherModel;


  /////Data load hoise kkina....
  // currentWeatherModel and forecastWeatherModel ei 2tar
  // jekono 1ta null asle show korabo kich 1ta
  bool get hasDataLoaded => currentWeatherModel != null &&
      forecastWeatherModel != null;



  setNewLocation(double lat, double lng){
    _latitude = lat;
    _longitude = lng;
  }

  getDataAfterNewLocation() {
    getCurrentWeatherData();
    getForecastWeatherData();
  }


  ///server/database/third party file theke data asar somoy anra future er async and await function use korbo
  Future<void> getCurrentWeatherData() async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        currentWeatherModel = CurrentWeatherModel.fromJson(map);
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        print(map['message']);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> getForecastWeatherData() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lng&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        forecastWeatherModel = ForecastWeatherModel.fromJson(map);
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        print(map['message']);
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
