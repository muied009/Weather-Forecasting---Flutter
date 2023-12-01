import 'package:flutter/material.dart';
import 'package:weather_forecasting/utils/constants.dart';
import 'package:weather_forecasting/utils/extensions.dart';

import '../apiModels/forecast_weather_model.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastItem> forecastItems;

  const ForecastSection({super.key, required this.forecastItems});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastItems.length,
        itemBuilder: (context, index) {
          final item = forecastItems[index];
          return AspectRatio(
            aspectRatio: 0.8,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text(getFormattedDateTime(item.dt!,
                          pattern: 'EEE hh:mm a')),
                      Text(
                          '${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}$degreeSign'),
                      Expanded(
                        child: Image.network(
                          '$prefixWeatherIconUrl${item.weather![0].icon}$suffixWeatherIconUrl',
                          width: 60,
                          height: 50,
                        ),
                      ),
                      Text(
                        item.weather![0].description.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
