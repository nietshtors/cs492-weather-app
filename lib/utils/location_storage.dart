// CURRENTLY UNUSED
// location_database.dart is used instead

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:weatherapp/models/location.dart' as location;

class LocationStorage {
  // Getting the local path to save the file
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // The file where the locations will be saved
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/locations.json');
  }

  // Going through the contents of the file, decoding it into json, and mapping it to a Location object
  Future<List<location.Location>> readLocations() async {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    // Decode the JSON data to a List of Map objects, then convert each Map to a Location object
    List<dynamic> jsonData = json.decode(contents);
    List<location.Location> locations = jsonData
        .map((jsonLocation) => location.Location.fromJson(jsonLocation))
        .toList();

    return locations;
  }

  // Write a list of locations to the file
  // This will overwrite the contents of the file, so it should not be used to add a single location to the existing ones
  Future<File> writeLocations(List<location.Location> locations) async {
    final file = await _localFile;

    // Convert each Location object to a JSON map and encode it to a JSON string
    List<Map<String, dynamic>> jsonData =
        locations.map((location) => location.toJson()).toList();
    String jsonString = json.encode(jsonData);

    // Write the JSON string to the file
    return file.writeAsString(jsonString);
  }
}
