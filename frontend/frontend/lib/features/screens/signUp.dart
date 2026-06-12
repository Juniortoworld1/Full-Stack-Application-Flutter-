import 'dart:io';
import 'package:flutter/foundation.dart'; // Required to support Web browser previews safely
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/features/screens/utils/forms.utils.dart';
import 'package:frontend/features/screens/utils/image_picker.dart';
import '../controllers/api.controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _signupState();
}

class _signupState extends State<Signup> {
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

  late final ApiHandler apiHandler ;

  @override
  void initState(){
    super.initState() ;
    apiHandler = ApiHandler();
  }

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isNarrowScreen = screenWidth < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF7580B8),
      body: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut, // Swapped from bounceIn to easeOut for smoother responsive snaps
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7580B8),
                Colors.white60,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(minHeight: screenHeight),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Flex(
                  // FIX 1: Swaps between Column and Row dynamically to avoid split-screen crashes
                  direction: isNarrowScreen ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome Header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            "Welcome to GroupIn.com",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // Shrink font size slightly if screen is narrow so it fits beautifully
                              fontSize: isNarrowScreen ? 32 : 40,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7580B8), // Better readability than 30% green
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: kIsWeb?Text(
                            "It perfectly balances\nthe two halves of your pitch—keeping\nup with existing friends while remaining\nopen to meeting new people",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              // Shrink font size slightly if screen is narrow so it fits beautifully
                              fontSize: isNarrowScreen ? 30 : 40,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7580B8), // Better readability than 30% green
                            ),
                          ):Text(""),
                        ),
                      ],
                    ),

                    // Registration Card Container

                    SizedBox(height: isNarrowScreen?18:0,) ,
                    Center(
                      child: Container(
                        width: 400, // Fixed card width for crisp design on desktop & mobile
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9), // Ensures deep form clarity against background
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 10,
                                  color: Colors.black12) // Softened layout shadow
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Shrink-wraps container tightly to text fields
                          children: [
                            const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Image Picker Selection Layer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BuildImagePicker(
                                  title: "Dp",
                                  is_circle: true,
                                  imageFile: _profileImage,
                                  icon: Icons.camera_alt,
                                  onTap: () => _pickImage(ImageSource.gallery, 'profile'),
                                ),
                                BuildImagePicker(
                                  title: "Cover Image",
                                  imageFile: _documentImage,
                                  is_circle: false,
                                  icon: Icons.upload_file,
                                  onTap: () => _pickImage(ImageSource.gallery, 'document'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Form Input Fields
                            inputField(
                              label: "Full Name",
                              icon: Icons.person,
                              hint: "Enter your full name",
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
                              hint: "Enter your username",
                              icon: Icons.perm_identity,
                              controller: userNameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Please enter something';
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            inputField(
                              label: "Password",
                              hint: "Enter your password",
                              icon: Icons.security,
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              isPassword: true,
                            ),
                            const SizedBox(height: 24),

                            // Sign Up Action Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  print("Full Name: ${fullNameController.text}");
                                  print("Profile Image Local Path: ${_profileImage?.path}");
                                  print("Document Local Path: ${_documentImage?.path}");

                                  final Map<String, dynamic> response = await apiHandler.sendInputFields(
                                      fullName: fullNameController.text,
                                      email: gmailController.text,
                                      userName: userNameController.text,
                                      password: passwordController.text,
                                      avatar: _profileImage,
                                      coverImage: _documentImage);

                                  if (response['success'] != false) {
                                    print("form submitted Successfully");
                                    // You can trigger a redirect to login or dashboard here!
                                  } else {
                                    print("Submission failed ");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("---------- OR ----------"),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Login Redirect Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey, // visually separates it from main submission
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}