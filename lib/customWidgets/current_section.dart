import 'package:flutter/material.dart';
import 'package:weather_forecasting/apiModels/current_weather_model.dart';
import 'package:weather_forecasting/utils/constants.dart';
import 'package:weather_forecasting/utils/extensions.dart';

class CurrentWeatherSection extends StatelessWidget {
  final CurrentWeatherModel currentWeatherModel;
  final String unitSymbol;

  const CurrentWeatherSection({
    super.key,
    required this.currentWeatherModel,
    required this.unitSymbol
  });

  @override
  Widget build(BuildContext context) {
    // Safe access to nested properties
    final dateTime = currentWeatherModel.dt;
    final cityName = currentWeatherModel.name;
    final country = currentWeatherModel.sys?.country;
    final temp = currentWeatherModel.main?.temp;
    final feelsLike = currentWeatherModel.main?.feelsLike;
    final weatherIcon = currentWeatherModel.weather?.firstOrNull?.icon;
    final weatherDescription = currentWeatherModel.weather?.firstOrNull?.description;

    return Column(
      children: [
        if (dateTime != null)
          Text(
            getFormattedDateTime(dateTime, pattern: 'EEE MMM dd, yyyy'),
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white60,
            ),
          ),
        const SizedBox(height: 10),
        if (cityName != null && country != null)
          Text(
            '$cityName - $country',
            style: const TextStyle(fontSize: 25),
          ),
        if (temp != null)
          Text(
            '${temp.toStringAsFixed(0)}$degreeSign$unitSymbol',
            style: const TextStyle(fontSize: 80), // Reduced from 120 to prevent overflow
          ),
        if (feelsLike != null)
          Text(
            'Feels Like: ${feelsLike.toStringAsFixed(0)}$degreeSign$unitSymbol',
            style: const TextStyle(fontSize: 25),
          ),
        if (weatherIcon != null || weatherDescription != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (weatherIcon != null)
                Image.network(
                  '$prefixWeatherIconUrl$weatherIcon$suffixWeatherIconUrl',
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
                ),
              if (weatherDescription != null) ...[
                const SizedBox(width: 10),
                Text(
                  weatherDescription,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ],
          ),
      ].where((widget) => widget != null).toList(),
    );
  }
}