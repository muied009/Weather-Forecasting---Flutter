import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weather_forecasting/customWidgets/current_section.dart';
import 'package:weather_forecasting/customWidgets/forecast_section.dart';
import 'package:weather_forecasting/pages/settings.dart';
import 'package:weather_forecasting/provider/weather_provider.dart';
import 'package:weather_forecasting/utils/extensions.dart';
import 'package:weather_forecasting/utils/location_service.dart';

import '../customWidgets/parallax_background.dart';
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
            onPressed: () {
              showSearch(
                context: context, 
                delegate: _CitySearchDelegate(),
              ).then((value) {
                if(value != null && value.isNotEmpty){
                  weatherProvider.convertCityToCoordinate(value)
                  .then((value) {
                    showSnackBarMsg(context, value);
                  });
                }
              });
              ///upore value ta holo 1ta string jeta search theke query te ase

            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              getLocation();
            },
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

          weatherProvider.hasDataLoaded ? Stack(
            children: [
              ParallaxBackground(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //temperatureSwitch(),
                    customToggleSwitch(),


                    ///jehetu provider e nullable ache but current section e null assertion tai eikhane ( ! ) dite hobe

                    CurrentWeatherSection(
                        currentWeatherModel: weatherProvider.currentWeatherModel!,
                      unitSymbol: weatherProvider.tempUnitSymbol,
                    ),
                    ForecastSection(forecastItems: weatherProvider.forecastWeatherModel!.list!),
                  ],
                ),
            ],
          ) : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Data Is Loading....."),
              SizedBox(height: 20,),
              SpinKitCircle(
                color: Colors.white, // Choose your desired color
                size: 50.0, // Adjust the size as needed
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isOn == 0 ? Colors.blue : Colors.grey,
              ),
              child: const Text(
                '$degreeSign$celsius',
                style: TextStyle(color: Colors.white,fontSize: 20),
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isOn == 1 ? Colors.green : Colors.grey,
              ),
              child: const Text(
                '$degreeSign$fahrenheit',
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String>{

  ////Search Page er appbar e ki ki rakhbo seta List akare return korte hobe
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = '';
      }, icon: const Icon(Icons.clear),
      )
    ];
  }

  ////example = kuno page e gele leading icon thake seita kemon hobe setar jonno
  @override
  Widget? buildLeading(BuildContext context) {
    return
      IconButton(onPressed: (){
        close(context, '');
      }, icon: const Icon(Icons.arrow_back),
      );
  }

  /////search er por result ta show korar jonno/kon widget e show korbo
  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: (){
        close(context, query);
      },
      title: Text(query),
      leading: const Icon(Icons.search),
    );
  }


  /////suggestion e kisu show koraite chaile
  @override
  Widget buildSuggestions(BuildContext context) {
    ///query = user jeta type korbe
    final filterList = query.isEmpty ? cities : cities.where((city) =>
        city.toLowerCase().startsWith(query)).toList() ;

    return ListView.builder(itemBuilder: (context, index) => ListTile(
    onTap: (){
      //// close = serach interface ta close kore dibe
      close(context, filterList[index]);
    },
      title: Text(filterList[index]),
    ),
    itemCount: filterList.length,);
  }
  
}
