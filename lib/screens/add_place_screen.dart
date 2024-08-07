import 'dart:io';
import 'package:fav_places/models/place_model.dart';
import 'package:fav_places/providers/user_places_provider.dart';
import 'package:fav_places/widgets/image_input.dart';
import 'package:fav_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Title ...'),
              ),
              SizedBox(height: 20),
              ImageInput(
                onImageSelected: (File pickedImage) {
                  _pickedImage = pickedImage;
                },
              ),
              const SizedBox(height: 20),
              LocationInput(
                onLocationSelected: (PlaceLocation location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlace,
                child: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;

      if (title.isEmpty || _pickedImage == null || _selectedLocation == null) {
        return;
      }
      ref.read(userPlacesProvider.notifier).addPlace(
            title,
            _pickedImage!,
            _selectedLocation!,
          );
      // Add your logic to save the newPlace object
      Navigator.of(context).pop();
    }
  }
}
