import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_forecasting/apiModels/current_weather_model.dart';
import 'package:weather_forecasting/apiModels/forecast_weather_model.dart';
import 'package:weather_forecasting/utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  String? _error;

  String unit = metric;
  CurrentWeatherModel? currentWeatherModel;
  ForecastWeatherModel? forecastWeatherModel;

  // Getter for error
  String? get error => _error;

  // Clear any existing error
  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Set error and notify listeners
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  bool get hasDataLoaded => currentWeatherModel != null &&
      forecastWeatherModel != null;

  setNewLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    _clearError();
  }

  setTempUnit(int? isOn) {
    if (isOn == 1) {
      unit = imperial;
    } else {
      unit = metric;
    }
    _clearError();
  }

  String get tempUnitSymbol => unit == metric ? celsius : fahrenheit;

  Future<String> convertCityToCoordinate(String city) async {
    try {
      final locationList = await locationFromAddress(city);
      if (locationList.isNotEmpty) {
        final location = locationList.first;
        setNewLocation(location.latitude, location.longitude);
        await getDataAfterNewLocation();
        return 'Fetching Data For $city';
      } else {
        _setError('Could Not Find The Location');
        return 'Could Not Find The Location';
      }
    } catch (error) {
      _setError(error.toString());
      return error.toString();
    }
  }

  Future<void> getDataAfterNewLocation() async {
    await _getCurrentWeatherData();
    await _getForecastWeatherData();
  }

  Future<void> _getCurrentWeatherData() async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        currentWeatherModel = CurrentWeatherModel.fromJson(map);
        _clearError();
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        _setError(map['message'] ?? 'Failed to load current weather data');
      }
    } catch (error) {
      _setError(error.toString());
    }
  }

  Future<void> _getForecastWeatherData() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$_latitude&lon=$_longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        forecastWeatherModel = ForecastWeatherModel.fromJson(map);
        _clearError();
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        _setError(map['message'] ?? 'Failed to load forecast data');
      }
    } catch (error) {
      _setError(error.toString());
    }
  }
}