import 'package:flutter/material.dart';
import 'package:weather_forecasting/apiModels/current_weather_model.dart';
import 'package:weather_forecasting/utils/constants.dart';
import 'package:weather_forecasting/utils/extensions.dart';

class CurrentWeatherSection extends StatelessWidget {
  final CurrentWeatherModel currentWeatherModel;
  final String unitSymbol;

  const CurrentWeatherSection({super.key, required this.currentWeatherModel, required this.unitSymbol});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          getFormattedDateTime(currentWeatherModel.dt!,
              pattern: 'EEE MMM dd, yyyy'),
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white60,
          ),
        ),
    const SizedBox(height: 10,),
        Text(
          '${currentWeatherModel.name!} - ${currentWeatherModel.sys!.country!}',
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
        Text(
          '${currentWeatherModel.main!.temp!.toStringAsFixed(0)}$degreeSign$unitSymbol',
          style: const TextStyle(
            fontSize: 120,
          ),
        ),
        Text(
          'Feels Like: ${currentWeatherModel.main!.feelsLike!.toStringAsFixed(0)}$degreeSign$unitSymbol',
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                '$prefixWeatherIconUrl${currentWeatherModel.weather![0].icon}$suffixWeatherIconUrl'
            ),
            const SizedBox(width: 10,),
            Text(
              currentWeatherModel.weather![0].description!,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        )

      ],
    );
  }
}
