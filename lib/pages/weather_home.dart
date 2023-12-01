import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weather_forecasting/customWidgets/current_section.dart';
import 'package:weather_forecasting/customWidgets/forecast_section.dart';
import 'package:weather_forecasting/pages/settings.dart';
import 'package:weather_forecasting/provider/weather_provider.dart';
import 'package:weather_forecasting/utils/extensions.dart';
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
  int isOn = 0;
  late Color activeSwitchColor;

  @override
  void initState() {
    getTempIntStatus().then((value) {
      setState(() {
        isOn = value!;
      });
    });
    super.initState();
    // Set the initial color based on isOn value
    //activeSwitchColor = isOn == 0 ? Colors.blue : Colors.green;
  }


  @override
  void didChangeDependencies() {
    weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    getLocation();

    super.didChangeDependencies();
  }

  getLocation() async {
    final position = await determinePosition();
    weatherProvider.setNewLocation(position.latitude, position.longitude);
    weatherProvider.setTempUnit(await getTempIntStatus());
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

          weatherProvider.hasDataLoaded ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //temperatureSwitch(),
                customToggleSwitch(),

                ///jehetu provider e nullable ache but current section e null assertion tai eikhane ( ! ) dite hobe

                CurrentWeatherSection(
                    currentWeatherModel: weatherProvider
                        .currentWeatherModel!),
                ForecastSection(forecastItems: weatherProvider.forecastWeatherModel!.list!),

              ],
            ) : const Center(
              child: Text('Please Wait..'),
            ),
        ),
      ),
    );
  }

  /*Widget temperatureSwitch() {
    return ToggleSwitch(
      minHeight: 30,
      minWidth: 40,
      cornerRadius: 20,
      fontSize: 20,
      activeBgColors: const [[Colors.green],[Colors.blue]],
      activeFgColor: Colors.black,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.black,
      totalSwitches: 2,
      labels: const ['$degreeSign$celsius', '$degreeSign$fahrenheit'],
      onToggle: (value) async {
        setState(() {
          isOn = value!;
        });
        setTempIntStatus(isOn);
        weatherProvider.setTempUnit(isOn);
        weatherProvider.getDataAfterNewLocation();
      },
    );
  }*/

  Widget customToggleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isOn = 0;
              activeSwitchColor = Colors.blue;
            });
            setTempIntStatus(isOn);
            weatherProvider.setTempUnit(isOn);
            weatherProvider.getDataAfterNewLocation();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isOn == 0 ? Colors.blue : Colors.grey,
            ),
            child: const Text(
              '$degreeSign$celsius',
              style: TextStyle(color: Colors.white,fontSize: 25),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isOn = 1;
              activeSwitchColor = Colors.green;
            });
            setTempIntStatus(isOn);
            weatherProvider.setTempUnit(isOn);
            weatherProvider.getDataAfterNewLocation();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isOn == 1 ? Colors.green : Colors.grey,
            ),
            child: const Text(
              '$degreeSign$fahrenheit',
              style: TextStyle(color: Colors.white,fontSize: 25),
            ),
          ),
        ),
      ],
    );
  }

}
