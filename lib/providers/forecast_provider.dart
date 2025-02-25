import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart' as forecast;
import 'package:weatherapp/models/location.dart' as location;
import 'package:weatherapp/utils/time.dart' as time;

class ForecastProvider extends ChangeNotifier {
  List<forecast.Forecast> _filteredForecastsHourly = [];
  List<forecast.Forecast> _forecasts = [];
  List<forecast.Forecast> _forecastsHourly = [];
  List<forecast.Forecast> _forecastsDaily = [];

  forecast.Forecast? _activeForecast;

  List<forecast.Forecast> get filteredForecastsHourly =>
      _filteredForecastsHourly;
  List<forecast.Forecast> get forecastsHourly => _forecastsHourly;
  List<forecast.Forecast> get forecastsDaily => _forecastsDaily;
  forecast.Forecast? get activeForecast => _activeForecast;

  void initForecasts(location.Location currentLocation) async {
    await _setForecasts(currentLocation);
    await _setHourlyForecasts(currentLocation);
    if (_forecastsDaily.isNotEmpty) {
      setActiveForecast(_forecastsDaily[0]);
    }
  }

  Future<void> _setForecasts(location.Location currentLocation) async {
    _forecasts = await forecast.getForecastFromPoints(
        currentLocation.latitude, currentLocation.longitude);
    _setDailyForecasts();
    notifyListeners();
  }

  Future<void> _setHourlyForecasts(location.Location currentLocation) async {
    _forecastsHourly = await forecast.getForecastHourlyFromPoints(
        currentLocation.latitude, currentLocation.longitude);
    notifyListeners();
  }

  void _setDailyForecasts() {
    _forecastsDaily = [];
    for (int i = 0; i < _forecasts.length - 1; i++) {
      if (i % 2 == 0) {
        _forecastsDaily
            .add(forecast.getForecastDaily(_forecasts[i], _forecasts[i + 1]));
      }
    }
  }

  void setActiveForecast(forecast.Forecast currentForecast) {
    _activeForecast = currentForecast;
    setFilteredForecasts();
    notifyListeners();
  }

  void setFilteredForecasts() {
    if (_activeForecast != null) {
      _filteredForecastsHourly = _forecastsHourly
          .where(
              (f) => time.equalDates(f.startTime, _activeForecast!.startTime))
          .toList();
      notifyListeners();
    }
  }
}
