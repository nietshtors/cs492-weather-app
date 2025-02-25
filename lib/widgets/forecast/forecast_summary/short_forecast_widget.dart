import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart' as forecast;

class ShortForecastWidget extends StatelessWidget {
  const ShortForecastWidget({
    super.key,
    required forecast.Forecast forecast,
  }) : _forecast = forecast;

  final forecast.Forecast _forecast;

  @override
  Widget build(BuildContext context) {
    return Text(_forecast.shortForecast,
        textAlign: TextAlign.center, style: TextStyle(fontSize: 9.0));
  }
}
