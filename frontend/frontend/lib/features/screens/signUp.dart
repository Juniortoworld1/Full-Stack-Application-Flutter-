import 'dart:io';
import 'package:flutter/foundation.dart'; // Required to support Web browser previews safely
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/features/screens/utils/forms.utils.dart';
import 'package:frontend/features/screens/utils/image_picker.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Text Form Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Image variables to hold selected images for preview
  XFile? _profileImage;
  XFile? _documentImage;

  // Image Picker Instance
  final ImagePicker _picker = ImagePicker();

  // Function that opens the gallery and updates the UI state
  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          if (type == 'profile') {
            _profileImage = pickedFile;
          } else if (type == 'document') {
            _documentImage = pickedFile;
          }
        });
      }
    } catch (e) {
      print("Error opening gallery: $e");
    }
  }

  // Reusable component for the Image Selection Boxes


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 4),
          height: screenHeight * 0.85, // Height increased to make room for the new options
          width: screenWidth > 600 ? screenWidth * 0.35 : screenWidth * 0.9, // Adjusts width for web vs mobile screens
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 4,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 5,
                    color: Colors.black12)
              ]),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Register",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 16),

                  // --- Your Original Text Fields ---

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: BuildImagePicker(
                          title: "",
                          is_circle: true,
                          imageFile: _profileImage,
                          icon: Icons.camera_alt,
                          onTap: () => _pickImage(ImageSource.gallery, 'profile'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),


                  inputField(
                    label: "FullName",
                    icon: Icons.person,
                    hint: "Enter your full Name",
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter some text';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  inputField(
                    label: "Gmail",
                    hint: "Enter your gmail",
                    icon: Icons.email,
                    controller: gmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter some text';
                      if (!value.contains("@")) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  inputField(
                      label: "Username",
                      hint: "Enter your Username",
                      icon: Icons.perm_identity,
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter something';
                        return null;
                      }),
                  const SizedBox(height: 8),
                  inputField(
                    label: "Password",
                    hint: "Enter your Password",
                    icon: Icons.security,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),

                  // --- Image Selection Option 1: Profile Picture ---


                  // --- Image Selection Option 2: ID Document Image ---
                  BuildImagePicker(
                    title: "CoverImage",
                    imageFile: _documentImage,
                    is_circle: false,
                    icon: Icons.upload_file,
                    onTap: () => _pickImage(ImageSource.gallery, 'document'),
                  ),
                  const SizedBox(height: 24),

                  // Simple Local Submit Button (No Backend)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Just prints data to the console locally to show you it works!
                        print("Full Name: ${fullNameController.text}");
                        print("Profile Image Local Path: ${_profileImage?.path}");
                        print("Document Local Path: ${_documentImage?.path}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Submit Locally",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}