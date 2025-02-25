import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart' as forecast;
import 'package:weatherapp/utils/time.dart' as time;

class ForecastNameWidget extends StatelessWidget {
  const ForecastNameWidget({
    super.key,
    required forecast.Forecast forecast,
  }) : _forecast = forecast;

  final forecast.Forecast _forecast;

  @override
  Widget build(BuildContext context) {
    return Text(
        _forecast.name ??
            time.convertTimestampToDayAndHour(_forecast.startTime),
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold));
  }
}
