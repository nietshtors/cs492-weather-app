import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() async {
  String pointsURL = "https://api.weather.gov/points/44.058,-121.31";

  Map<String, dynamic> pointsJsonData = await getJsonFromUrl(pointsURL);

  String forecastURL = pointsJsonData["properties"]["forecast"];
  String forecastHourlyURL = pointsJsonData["properties"]["forecastHourly"];

  Map<String, dynamic> forecastJsonData = await getJsonFromUrl(forecastURL);
  Map<String, dynamic> forecastHourlyJsonData = await getJsonFromUrl(forecastHourlyURL);

  processForecasts(forecastJsonData["properties"]["periods"]);
  processForecasts(forecastHourlyJsonData["properties"]["periods"]);

  return;
}

Future<Map<String, dynamic>> getJsonFromUrl(String url) async {
  http.Response r = await http.get(Uri.parse(url));
  return convert.jsonDecode(r.body);
}

void processForecasts(List<dynamic> forecasts){
  
  for (var forecast in forecasts) {
    processForecastEntry(forecast);
  }
}

void processForecastEntry(Map<String, dynamic> forecast){
  String name = forecast["name"];
  String startTime = forecast["startTime"];
  String endTime = forecast["endTime"];
  bool isDaytime = forecast["isDaytime"];
  int temperature = forecast["temperature"];
  String temperatureUnit= forecast["temperatureUnit"];
  String temperatureTrend= forecast["temperatureTrend"];
  int? probabilityOfPrecipitation= forecast["probabilityOfPrecipitation"]["value"];
  String windSpeed = forecast["windSpeed"];
  String windDirection= forecast["windDirection"];
  String shortForecast = forecast["shortForecast"];
  String detailedForecast = forecast["detailedForecast"];
  double dewpoint = (name == "") ? forecast["dewpoint"]["value"] : null;
  int relativeHumidity = (name == "") ? forecast["relativeHumidity"]["value"] : null;
}