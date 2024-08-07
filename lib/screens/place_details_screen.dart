import 'package:fav_places/models/place_model.dart';
import 'package:fav_places/screens/map_screen.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final PlaceModel place;

  String get locationImageUrl {
    return '''https://maps.googleapis.com/maps/api/staticmap?center=
  ${place.location.latitude},${place.location.longitude}&zoom=7&size=600x300&maptype=roadmap
&markers=color:red%7Clabel:A%7C${place.location.latitude},${place.location.longitude}
&key=AIzaSyCNZfNXUq8O885jvA7lDAO90jrz8NjzwmM''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.location,
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(locationImageUrl),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.all(10),
                    child: Text(place.location.address),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
