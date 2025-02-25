import 'package:flutter/material.dart';
import 'package:weatherapp/models/location.dart' as location;
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/utils/location_database.dart';

class LocationProvider extends ChangeNotifier {
  final ForecastProvider forecastProvider;

  location.Location? _activeLocation;
  List<location.Location> _savedLocations = [];
  late LocationDatabase _db;

  LocationProvider(this.forecastProvider) {
    loadLocations();
  }

  location.Location? get activeLocation => _activeLocation;
  List<location.Location> get savedLocations => _savedLocations;

  Future<void> setInitialLocation() async {
    if (_savedLocations.isEmpty) {
      setLocation(await location.getLocationFromGps());
    } else {
      setLocation(_savedLocations[0]);
    }
    notifyListeners();
  }

  void setLocation(location.Location loc) {
    _activeLocation = loc;
    notifyListeners();
    if (_activeLocation != null) {
      forecastProvider.initForecasts(_activeLocation!);
    }
  }

  Future<void> setLocationFromAddress(
      String city, String state, String zip) async {
    _activeLocation = null;
    notifyListeners();

    final newLocation = await location.getLocationFromAddress(city, state, zip);

    if (newLocation != null) {
      _activeLocation = newLocation;
      addLocation(newLocation);
      notifyListeners();
    }
  }

  void setLocationFromGps() async {
    _activeLocation = null;
    notifyListeners();

    final newLocation = await location.getLocationFromGps();
    _activeLocation = newLocation;
    addLocation(newLocation);
    notifyListeners();
  }

  Future<void> addLocation(location.Location newLocation) async {
    if (!_savedLocations.contains(newLocation)) {
      _savedLocations.add(newLocation);
      _db.insertLocation(newLocation);
    }
  }

  Future<void> deleteLocation(location.Location locToDelete) async {
    _savedLocations
        .removeWhere((savedLocation) => savedLocation == locToDelete);
    _db.deleteLocation(locToDelete);
  }

  Future<void> loadLocations() async {
    _db = await LocationDatabase.open();
    _savedLocations = await _db.getLocations();
    setInitialLocation();
  }
}
