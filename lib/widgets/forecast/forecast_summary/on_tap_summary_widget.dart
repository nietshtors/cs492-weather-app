import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart' as forecast;
import 'package:weatherapp/widgets/forecast/forecast_summary/forecast_summary_widget.dart';

class OnTapSummaryWidget extends StatelessWidget {
  const OnTapSummaryWidget(
      {super.key,
      required List<forecast.Forecast> forecasts,
      required this.i,
      required Function setActiveForecast})
      : _forecasts = forecasts,
        _setActiveForecast = setActiveForecast;

  final List<forecast.Forecast> _forecasts;
  final int i;
  final Function _setActiveForecast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _setActiveForecast(_forecasts[i]);
        },
        child: ForecastSummaryWidget(currentForecast: _forecasts[i]));
  }
}
