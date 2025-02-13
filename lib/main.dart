import 'package:flutter/material.dart';

import 'package:weatherapp/scripts/location.dart' as location;
import 'package:weatherapp/scripts/forecast.dart' as forecast;
import 'package:weatherapp/scripts/time.dart' as time;
import 'package:weatherapp/widgets/forecast_tab_widget.dart';
import 'package:weatherapp/widgets/location_tab_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'CS492 Weather App';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<forecast.Forecast> _forecastsHourly = [];
  List<forecast.Forecast> _filteredForecastsHourly= [];
  List<forecast.Forecast> _forecasts = [];
  List<forecast.Forecast> _dailyForecasts = [];
  forecast.Forecast? _activeForecast;
  location.Location? _location;

  @override
  void initState() {
    super.initState();
    if (_location == null){
      setInitialLocation();
    }
  }

  void setInitialLocation() async {
    setLocation(await location.getLocationFromGps());
  }

  Future<List<forecast.Forecast>> getForecasts(location.Location currentLocation) async {
    return forecast.getForecastFromPoints(currentLocation.latitude, currentLocation.longitude);
  }


  Future<List<forecast.Forecast>> getHourlyForecasts(location.Location currentLocation) async {
    return forecast.getForecastHourlyFromPoints(currentLocation.latitude, currentLocation.longitude);
  }

  void setActiveForecast(int i){
    setState(() {
      _filteredForecastsHourly = getFilteredForecasts(i);
      _activeForecast = _dailyForecasts[i];
    });
  }

  void setActiveHourlyForecast(int i){
    setState(() {
      _activeForecast = _filteredForecastsHourly[i];
    });
  }

  void setDailyForecasts(){
    List<forecast.Forecast> dailyForecasts = [];
    for (int i = 0; i < _forecasts.length-1; i+=2){
      dailyForecasts.add(forecast.getForecastDaily(_forecasts[i], _forecasts[i+1]));
      
    }
    setState(() {
      _dailyForecasts = dailyForecasts;
    });
  }

  List<forecast.Forecast> getFilteredForecasts(int i){
    return _forecastsHourly.where((f)=>time.equalDates(f.startTime, _dailyForecasts[i].startTime)).toList();
  }

  void setLocation(location.Location? currentLocation) async {
    if (currentLocation == null){
      setState(() {
        _location = null;
      });
    }
    else {
      List<forecast.Forecast> currentHourlyForecasts = await getHourlyForecasts(currentLocation);
      List<forecast.Forecast> currentForecasts = await getForecasts(currentLocation);
      setState((){
        _location = currentLocation;
        _location = currentLocation;
        _forecastsHourly = currentHourlyForecasts;
        _forecasts = currentForecasts;
        setDailyForecasts();
        _filteredForecastsHourly = getFilteredForecasts(0);
        _activeForecast = _forecastsHourly[0];
      });
      }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sunny_snowing)),
              Tab(icon: Icon(Icons.edit_location_alt))
            ]
          )
        ),
        body:TabBarView(
          children: [ForecastTabWidget(
            activeLocation: _location, 
            activeForecast: _activeForecast,
            dailyForecasts: _dailyForecasts,
            filteredForecastsHourly: _filteredForecastsHourly,
            setActiveForecast: setActiveForecast,
            setActiveHourlyForecast: setActiveHourlyForecast),
          LocationTabWidget(setLocation: setLocation, activeLocation: _location)]
        ),
      ),
    );
  }
}