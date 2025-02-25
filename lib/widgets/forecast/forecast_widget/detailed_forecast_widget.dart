import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart' as forecast;

class DetailedForecastWidget extends StatelessWidget {
  const DetailedForecastWidget({
    super.key,
    required forecast.Forecast forecast,
  }) : _forecast = forecast;

  final forecast.Forecast _forecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(_forecast.detailedForecast ?? ""),
    );
  }
}
