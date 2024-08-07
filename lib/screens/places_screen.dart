import 'package:fav_places/providers/user_places_provider.dart';
import 'package:fav_places/screens/add_place_screen.dart';
import 'package:fav_places/widgets/place_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({
    super.key,
  });

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(userPlacesProvider);

    Widget mainContent = places.isEmpty
        ? const Center(
            child: Text('No places added yet!'),
          )
        : ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              return Dismissible(
                  key: ValueKey(places[index].id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    ref
                        .read(userPlacesProvider.notifier)
                        .removePlace(places[index]);
                  },
                  child: PlaceWidget(place: places[index]));
            },
          );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Great Places'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addPlace(context);
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: _placesFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.connectionState == ConnectionState.done
                        ? mainContent
                        : const Center(child: Text('Error'))));
  }

  void _addPlace(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPlaceScreen(),
      ),
    );
  }
}
// commit 1