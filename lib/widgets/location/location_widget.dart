import 'package:flutter/material.dart';
import 'package:weatherapp/models/location.dart' as location;

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key, required location.Location? location})
      : _location = location;

  final location.Location? _location;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Text(
            "${_location?.city ?? "city"}, ${_location?.state ?? "state"} ${_location?.zip ?? "zip"}"));
  }
}
