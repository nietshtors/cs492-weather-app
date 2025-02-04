import 'forecast.dart' as forecast;
import 'location.dart' as location;

// void main() async {
//   testForecast();
// }

void testLocation() async {

  List<Map<String, String>> testLocations = [];
  testLocations.add({"city": "Portland", "state": "OR", "zip": "97206"});
  testLocations.add({"city": "Portland", "state": "ME", "zip": ""});
  testLocations.add({"city": "Seattle", "state": "WA", "zip": ""});
  testLocations.add({"city": "New York", "state": "NY", "zip": ""});
  testLocations.add({"city": "Santa Clause", "state": "IN", "zip": ""});

  for (Map<String, String> testLocation in testLocations) {
    location.Location? loc = await location.getLocationFromAddress(testLocation["city"]!, testLocation["state"]!, testLocation["zip"]!);
    continue;
  }
  

}

void testGps(){
  location.getLocationFromGps();
}


void testForecast() async {
// testing with Bend, OR coordinates
  // double lat = 44.05;
  // double lon = -121.31;
  List<List<double>> coords = [
    [44.05, -121.31],
    [40.71, -74.006],
    [41.878, -87.629],
    [25.7617, -80.1918],
    [35.0844, -106.65]
  ];

  for (List<double> coord in coords){
    List<forecast.Forecast> forecasts = await forecast.getForecastFromPoints(coord[0], coord[1]);
    List<forecast.Forecast> forecastsHourly = await forecast.getForecastHourlyFromPoints(coord[0],coord[1]);
  }
}