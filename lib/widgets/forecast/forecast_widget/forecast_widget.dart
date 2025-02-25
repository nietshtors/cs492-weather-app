import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/utils/math.dart' as math;
import 'package:weatherapp/widgets/forecast/forecast_widget/detailed_forecast_widget.dart';
import 'package:weatherapp/widgets/forecast/forecast_widget/forecast_name_widget.dart';
import 'package:weatherapp/widgets/location/weather_icon_widget.dart';

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var forecastProvider = Provider.of<ForecastProvider>(context);
    var activeForecast = forecastProvider.activeForecast;

    return activeForecast != null
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ForecastNameWidget(forecast: activeForecast),
                  WeatherIconWidget(
                      iconPath: activeForecast.getIconPath(),
                      height: 100,
                      width: 100),
                  Text(activeForecast.shortForecast),
                  Text(
                      "Wind: ${activeForecast.windSpeed} ${activeForecast.windDirection}"),
                  Text(
                      "Temp: ${activeForecast.temperature}°${activeForecast.temperatureUnit}"),
                  Text(activeForecast.dewpoint != null
                      ? "Dewpoint: ${math.roundToDecimalPlaces(activeForecast.dewpoint, 2)}"
                      : ""),
                  Text(activeForecast.humidity != null
                      ? "Humidity: ${activeForecast.humidity}"
                      : ""),
                  Text(activeForecast.precipitationProbability != null
                      ? "Chance of Rain: ${activeForecast.precipitationProbability}"
                      : ""),
                  DetailedForecastWidget(forecast: activeForecast)
                ],
              ),
            ),
          )
        : Text("");
  }
}
