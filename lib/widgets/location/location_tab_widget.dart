import 'package:flutter/material.dart';
import 'package:weatherapp/models/location.dart' as location;
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/location_provider.dart';

class LocationTabWidget extends StatefulWidget {
  const LocationTabWidget({super.key});

  @override
  State<LocationTabWidget> createState() => _LocationTabWidgetState();
}

class _LocationTabWidgetState extends State<LocationTabWidget> {
  var _editMode = false;

  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context);

    return Column(
      children: [
        LocationDisplayWidget(activeLocation: locationProvider.activeLocation),
        LoctionInputWidget(
            setLocation: locationProvider.setLocationFromAddress),
        ElevatedButton(
            onPressed: () => {locationProvider.setLocationFromGps},
            child: const Text("Get From GPS")),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit Saved Locations: "),
            Switch(
                value: _editMode,
                onChanged: (bool value) {
                  setState(() {
                    _editMode = value;
                  });
                }),
          ],
        ),
        SavedLocationsWidget(
          locationService: locationProvider,
          editMode: _editMode,
        )
      ],
    );
  }
}

class SavedLocationsWidget extends StatelessWidget {
  const SavedLocationsWidget(
      {super.key,
      required LocationProvider locationService,
      required bool editMode})
      : _locationService = locationService,
        _editMode = editMode;

  final LocationProvider _locationService;
  final bool _editMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _locationService.savedLocations
          .map((loc) => _editMode
              ? SavedLocationEditWidget(
                  loc: loc, delete: _locationService.deleteLocation)
              : SavedLocationWidget(
                  loc: loc, setLocation: _locationService.setLocation))
          .toList(),
    );
  }
}

class SavedLocationWidget extends StatelessWidget {
  const SavedLocationWidget(
      {super.key,
      required location.Location loc,
      required Function setLocation})
      : _loc = loc,
        _setLocation = setLocation;

  final location.Location _loc;
  final Function _setLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _setLocation(_loc);
        },
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black, width: 2)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
                width: 250,
                child: Text("${_loc.city}, ${_loc.state} ${_loc.zip}")),
          ),
        ));
  }
}

class SavedLocationEditWidget extends StatelessWidget {
  const SavedLocationEditWidget(
      {super.key, required location.Location loc, required Function delete})
      : _loc = loc,
        _delete = delete;

  final location.Location _loc;
  final Function _delete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.red, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_loc.city}, ${_loc.state} ${_loc.zip}"),
                GestureDetector(
                    onTap: () {
                      _delete(_loc);
                    },
                    child: Icon(Icons.delete, color: Colors.red))
              ],
            )),
      ),
    );
  }
}

class LocationDisplayWidget extends StatelessWidget {
  const LocationDisplayWidget(
      {super.key, required location.Location? activeLocation})
      : _location = activeLocation;

  final location.Location? _location;

  @override
  Widget build(BuildContext context) {
    return Text(_location != null
        ? "${_location.city}, ${_location.state} ${_location.zip}"
        : "No Location Set");
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
  void _updateCity(String value) {
    _city = value;
  }

  void _updateState(String value) {
    _state = value;
  }

  void _updateZip(String value) {
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
              LocationTextWidget(
                  width: 100, text: "city", updateText: _updateCity),
              LocationTextWidget(
                  width: 75, text: "state", updateText: _updateState),
              LocationTextWidget(
                  width: 100, text: "zip", updateText: _updateZip),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                widget._setLocation(_city, _state, _zip);
              },
              child: Text("Get From Address"))
        ],
      ),
    );
  }
}

class LocationTextWidget extends StatefulWidget {
  const LocationTextWidget(
      {super.key,
      required double width,
      required String text,
      required Function updateText})
      : _width = width,
        _text = text,
        _updateText = updateText;

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
              border: OutlineInputBorder(), labelText: widget._text)),
    );
  }
}
