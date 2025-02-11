import 'package:flutter/material.dart';
import 'package:weatherapp/scripts/location.dart' as location;

class LocationTabWidget extends StatelessWidget {
  const LocationTabWidget({
    super.key,
    required Function setLocation,
    required location.Location? activeLocation
  }) : _setLocation = setLocation, _location = activeLocation;

  final Function _setLocation;
  final location.Location? _location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationDisplayWidget(activeLocation: _location),
        LoctionInputWidget(setLocation: _setLocation),
        ElevatedButton(onPressed: ()=>{_setLocation()},child: const Text("Get From GPS"))
      ],
    );
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

class LoctionInputWidget extends StatelessWidget {
  const LoctionInputWidget({
    super.key,
    required Function setLocation
  }) : _setLocation = setLocation;

  final Function _setLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              LocationTextWidget(width: 100, text: "city"),
              LocationTextWidget(width: 75, text: "state"),
              LocationTextWidget(width: 100, text: "zip"),
            ],
          ),
          ElevatedButton(onPressed: () {_setLocation(["New York", "New York", ""]);}, child: Text("Get From Address"))
        ],
      ),
    );
  }
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({
    super.key,
    required double width,
    required String text
  }): _width = width, _text = text;

  final double _width;
  final String _text;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: TextField(decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: _text
      )),
    );
  }
}