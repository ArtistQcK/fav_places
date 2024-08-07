import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onImageSelected});
  final void Function(File pickedImage) onImageSelected;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      label: const Text('Take an image .. '),
      icon: const Icon(Icons.camera_alt_outlined),
    );

    if (_selectedImage != null) {
      content = InkWell(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      alignment: Alignment.center,
      height: 280,
      width: double.infinity,
      child: content,
    );
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Image Source'),
        actions: [
          TextButton(
            child: const Text('Camera'),
            onPressed: () => Navigator.of(ctx).pop(ImageSource.camera),
          ),
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.of(ctx).pop(ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) {
      return;
    }

    final XFile? pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onImageSelected(_selectedImage!);
  }
}