import 'package:fav_places/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location =
          const PlaceLocation(latitude: 37, longitude: -122, address: ''),
      this.isSelecting = true});

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting
            ? 'Select a location on the map'
            : 'Your location on the map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save_as),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
          myLocationButtonEnabled: true,
          onLongPress: (argument) {},
          onTap: widget.isSelecting
              ? (position) {
                  setState(() {
                    _pickedLocation = position;
                  });
                }
              : null,
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.location.latitude, widget.location.longitude),
              zoom: 16),
          markers: (_pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                      markerId: const MarkerId('m1'),
                      position: _pickedLocation ??
                          LatLng(widget.location.latitude,
                              widget.location.longitude))
                }),
    );
  }
}
