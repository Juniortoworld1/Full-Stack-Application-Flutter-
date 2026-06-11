import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Capitalized class name following Dart naming conventions
class BuildImagePicker extends StatelessWidget {
  final String title;
  final XFile? imageFile;
  final IconData icon;
  final VoidCallback onTap;
  final bool is_circle ;

  const BuildImagePicker({
    super.key,
    required this.title,
    required this.imageFile,
    required this.icon,
    required this.onTap,
    required this.is_circle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 110,
            width: 110, // Made width equal to height to make it a perfect circle
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: is_circle?BoxShape.circle:BoxShape.rectangle, // Forces the container boundary to be circular
              border: Border.all(color: Colors.grey.shade400),
            ),
            // ClipOval ensures any child widget respects the circular border bounds
            child: ClipOval(
              child: imageFile != null
                  ? (kIsWeb
                  ? CircleAvatar(
                radius: 55, // Fits the 110 height/width perfectly
                backgroundImage: NetworkImage(imageFile!.path),
              )
                  : Image.file(
                File(imageFile!.path),
                fit: BoxFit.cover, // Ensures local file fills the circle perfectly
              ))
                  : Column( // Stacked icon and text vertically to fit the circular profile look
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    "Add",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
