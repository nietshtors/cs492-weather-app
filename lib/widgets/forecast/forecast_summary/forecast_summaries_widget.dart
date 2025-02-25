import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/models/forecast.dart' as forecast;
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/widgets/forecast/forecast_summary/on_tap_summary_widget.dart';

class ForecastSummariesWidget extends StatelessWidget {
  const ForecastSummariesWidget({
    super.key,
    required List<forecast.Forecast> forecasts,
  }) : _forecasts = forecasts;

  final List<forecast.Forecast> _forecasts;

  List<OnTapSummaryWidget> getForecastWidgets(Function setActiveForecast) {
    List<OnTapSummaryWidget> widgets = [];

    for (int i = 0; i < _forecasts.length; i++) {
      widgets.add(OnTapSummaryWidget(
          forecasts: _forecasts, i: i, setActiveForecast: setActiveForecast));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var forecastProvider = Provider.of<ForecastProvider>(context);

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: getForecastWidgets(forecastProvider.setActiveForecast)));
  }
}
