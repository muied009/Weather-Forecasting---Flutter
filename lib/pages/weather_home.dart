import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weather_forecasting/customWidgets/current_section.dart';
import 'package:weather_forecasting/customWidgets/forecast_section.dart';
import 'package:weather_forecasting/pages/settings.dart';
import 'package:weather_forecasting/provider/weather_provider.dart';
import 'package:weather_forecasting/utils/location_service.dart';

import '../utils/constants.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({
    super.key,
  });

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {

  ///Provider er object lagbe karon location er jonno lat lng provider e pathate hobe
  late WeatherProvider weatherProvider;


  @override
  void didChangeDependencies() {
    Provider.of<WeatherProvider>(context, listen: false)
        .getCurrentWeatherData();
    Provider.of<WeatherProvider>(context, listen: false)
        .getForecastWeatherData();

    //getLocation();

    super.didChangeDependencies();
  }

  getLocation() async {
    final position = await determinePosition();
    weatherProvider.setNewLocation(position.latitude, position.longitude);
    weatherProvider.getDataAfterNewLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Weather Forecasting'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.my_location),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child)  =>

          ///true hoile column return korbe

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ToggleSwitch(
                minHeight: 30,
                minWidth: 40,
                cornerRadius: 20,
                fontSize: 20,
                activeBgColors: const [[Colors.green], [Colors.blue]],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const [
                  '$degreeSign$celsius',
                  '$degreeSign$fahrenheit'
                ],
                onToggle: (index) {
                  print('selected Item position $index');
                },
              ),

              ///jehetu provider e nullable ache but current section e null assertion tai eikhane ( ! ) dite hobe

              CurrentWeatherSection(
                  currentWeatherModel: weatherProvider
                      .currentWeatherModel!),
              ForecastSection(forecastItems: weatherProvider.forecastWeatherModel!.list!),

            ],
          )

          /*weatherProvider.hasDataLoaded ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ToggleSwitch(
                  minHeight: 30,
                  minWidth: 40,
                  cornerRadius: 20,
                  fontSize: 20,
                  activeBgColors: const [[Colors.green], [Colors.blue]],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const [
                    '$degreeSign$celsius',
                    '$degreeSign$fahrenheit'
                  ],
                  onToggle: (index) {
                    print('selected Item position $index');
                  },
                ),

                ///jehetu provider e nullable ache but current section e null assertion tai eikhane ( ! ) dite hobe

                CurrentWeatherSection(
                    currentWeatherModel: weatherProvider
                        .currentWeatherModel!),
                ForecastSection(forecastItems: weatherProvider.forecastWeatherModel!.list!),

              ],
            ) : const Center(
              child: Text('Please Wait..'),
            ),*/
        ),
      ),
    );
  }
}