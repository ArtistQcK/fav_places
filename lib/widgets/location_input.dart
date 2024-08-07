import 'dart:convert';

import 'package:fav_places/models/place_model.dart';
import 'package:fav_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onLocationSelected});
  final void Function(PlaceLocation location) onLocationSelected;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  String get locationImageUrl {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation?.latitude;
    final lng = _pickedLocation?.longitude;
    print(lat);
    print(lng);
    return '''https://maps.googleapis.com/maps/api/staticmap?center=
  $lat,$lng&zoom=7&size=600x300&maptype=roadmap
&markers=color:red%7Clabel:A%7C$lat,$lng
&key=AIzaSyCNZfNXUq8O885jvA7lDAO90jrz8NjzwmM''';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lng = locationData.longitude;
    final lat = locationData.latitude;
    if (lng == null || lat == null) {
      return;
    }
    _savePlace(lat, lng);
  }

  void _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCNZfNXUq8O885jvA7lDAO90jrz8NjzwmM');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    final adress = data['results'][0]['formatted_address'];
    print(adress);

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: adress);
      _isGettingLocation = false;
    });
    widget.onLocationSelected(_pickedLocation!);
  }

  void _selectOnMap() async {
    final pickedLocation =
        await Navigator.push<LatLng>(context, MaterialPageRoute(builder: (ctx) {
      return const MapScreen();
    }));
    if (pickedLocation == null) {
      return;
      
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text('No Location Chosen');
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: previewContent,
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
