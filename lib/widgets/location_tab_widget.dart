import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weatherapp/scripts/location.dart' as location;

// TODO:
// Refer to this documentation:
// https://docs.flutter.dev/cookbook/persistence/reading-writing-files
// Save the saved locations List<location.Location> as json data to a file whenever a new saved location is added
// Load the saved locations from the file on initState
// For now you don't need to worry about deleting data or ensuring no redundant data
// HINT: You will likely want to create a fromJson() factory and a toJson() method to the location.dart Location class

class LocationTabWidget extends StatefulWidget {
  const LocationTabWidget({
    super.key,
    required Function setLocation,
    required location.Location? activeLocation
  }) : _setLocation = setLocation, _location = activeLocation;

  final Function _setLocation;
  final location.Location? _location;

  @override
  State<LocationTabWidget> createState() => _LocationTabWidgetState();
}

class _LocationTabWidgetState extends State<LocationTabWidget> {

  final List<location.Location> _savedLocations = [];

  void _setLocationFromAddress(String city, String state, String zip) async {
    // set location to null temporarily while it finds a new location
    widget._setLocation(null);
    location.Location currentLocation = await location.getLocationFromAddress(city, state, zip) as location.Location;
    widget._setLocation(currentLocation);
    _addLocation(currentLocation);
  }

  void _setLocationFromGps() async {
    // set location to null temporarily while it finds a new location
    widget._setLocation(null);
    location.Location currentLocation = await location.getLocationFromGps();
    widget._setLocation(currentLocation);
  }

  
  void _addLocation(location.Location location){
    setState(() {
      _savedLocations.add(location);
    });
    _savedLocations.map((loc) => (loc.toJson())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationDisplayWidget(activeLocation: widget._location),
        LoctionInputWidget(setLocation: _setLocationFromAddress), // pass in _addLocation
        ElevatedButton(onPressed: ()=>{_setLocationFromGps()},child: const Text("Get From GPS")),
        SavedLocationsWidget(locations: _savedLocations, setLocation: widget._setLocation)
      ],
    );
  }
}

class SavedLocationsWidget extends StatelessWidget {
  const SavedLocationsWidget({
    super.key,
    required List<location.Location> locations,
    required Function setLocation
  }) : _locations = locations, _setLocation = setLocation;

  final List<location.Location> _locations;
  final Function _setLocation;

  @override
  Widget build(BuildContext context) {
    return Column(children: _locations.map((loc)=>SavedLocationWidget(loc: loc, setLocation: _setLocation)).toList(),);
  }
}

class SavedLocationWidget extends StatelessWidget {
  const SavedLocationWidget({
    super.key,
    required location.Location loc,
    required Function setLocation
  }) : _loc = loc, _setLocation = setLocation;

  final location.Location _loc;
  final Function _setLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {_setLocation(_loc);}, child: Text("${_loc.city}, ${_loc.state} ${_loc.zip}"));
  }
}

class LocationDisplayWidget extends StatelessWidget {
  const LocationDisplayWidget({
    super.key,
    required location.Location? activeLocation
  }) : _location = activeLocation;

  final location.Location? _location;

  @override
  Widget build(BuildContext context) {
    return Text(_location != null ? "${_location.city}, ${_location.state} ${_location.zip}" : "No Location Set");
  }
}

class LoctionInputWidget extends StatefulWidget {
  const LoctionInputWidget({
    super.key,
    required Function setLocation,
  }) : _setLocation = setLocation;

  final Function _setLocation;

  @override
  State<LoctionInputWidget> createState() => _LoctionInputWidgetState();
}

class _LoctionInputWidgetState extends State<LoctionInputWidget> {

  // values
  late String _city;
  late String _state;
  late String _zip;
  
  @override
  void initState() {
    super.initState();
    _city = "";
    _state = "";
    _zip = "";

  }

  // update functions
  void _updateCity(String value){
    _city = value;
  }

  void _updateState(String value){
    _state = value;
  }

  void _updateZip(String value){
    _zip = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              LocationTextWidget(width: 100, text: "city", updateText: _updateCity),
              LocationTextWidget(width: 75, text: "state", updateText: _updateState),
              LocationTextWidget(width: 100, text: "zip", updateText: _updateZip),
            ],
          ),
          ElevatedButton(onPressed: () {widget._setLocation(_city, _state, _zip);}, child: Text("Get From Address"))
        ],
      ),
    );
  }
}

class LocationTextWidget extends StatefulWidget {
  const LocationTextWidget({
    super.key,
    required double width,
    required String text,
    required Function updateText
  }): _width = width, _text = text, _updateText = updateText;

  final double _width;
  final String _text;
  final Function _updateText;

  @override
  State<LocationTextWidget> createState() => _LocationTextWidgetState();
}

class _LocationTextWidgetState extends State<LocationTextWidget> {

  // controllers
  late TextEditingController _controller;

  // initialize Controllers
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width,
      child: TextField(
        controller: _controller,
        onChanged: (value) => {widget._updateText(value)},
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget._text
      )),
    );
  }
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/savedLocations.txt');
  }

  Future<List<location.Location>> readLocations() async {
    try {
      final file = await _localFile;

      // Read the file
      final jsonString = await file.readAsString();
      List<Map<String, dynamic>> json = await jsonDecode(jsonString);
      return json.map((loc) => {location.Location.fromJson(loc)}).toList();
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeLocations(Map<String, dynamic> json) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$json');
  }

}