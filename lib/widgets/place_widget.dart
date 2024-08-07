import 'package:fav_places/models/place_model.dart';
import 'package:fav_places/screens/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlaceWidget extends StatelessWidget {
  const PlaceWidget({
    super.key,
    required this.place,
  });

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetailsScreen(place: place),
              ),
            );
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: FileImage(place.image),
          ),
          title: Text(place.title,

              // set title large

              style: Theme.of(context).textTheme.titleLarge!),
          subtitle: Text(place.location.address),
        ));
  }
}
