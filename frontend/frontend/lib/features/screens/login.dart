import 'package:flutter/material.dart';
import 'package:frontend/features/controllers/api.login.controller.dart';
import 'package:frontend/features/routes/routes.dart';
import 'package:frontend/features/screens/utils/forms.utils.dart';
import 'package:frontend/main.dart';
import '../controllers/api.controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController gmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false; // Tracks if the API call is in progress ;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine if the screen is narrow (like mobile or split-screen mode)
    final isNarrowScreen = screenWidth < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF7580B8),
      body: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Container(
          // FIX 1: Dynamic width instead of hardcoded 1000 to prevent edge overflow
          width: screenWidth,
          height: screenHeight,
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
              // Allows the entire page to scroll vertically if the height becomes too small in split-screen
              child: Container(
                constraints: BoxConstraints(minHeight: screenHeight),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Flex(
                  // FIX 2: Change layout direction based on available width
                  direction: isNarrowScreen ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome Title
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
                          child: Text(
                            "It perfectly balances\nthe two halves of your pitch—keeping\nup with existing friends while remaining\nopen to meeting new people",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              // Shrink font size slightly if screen is narrow so it fits beautifully
                              fontSize: isNarrowScreen ? 32 : 40,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7580B8), // Better readability than 30% green
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Form Box
                    Center(
                      child: Container(
                        width: 350, // Stays consistent for the form container
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9), // Ensures the form stands out against background
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 10,
                              color: Colors.black12, // Softer shadow for a cleaner web feel
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // shrink-wraps the column vertically
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            inputField(
                              label: "Username or email",
                              hint: "Enter your username or email",
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
                              label: "Password",
                              hint: "Enter your Password",
                              icon: Icons.security,
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              isPassword: true,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.question_answer_outlined, size: 18),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    // Handle forgot password action here
                                  },
                                  child: const Text(
                                    "Forgot?",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    final ApiHandler apiHandler = ApiHandler();
                                    final Map<String, dynamic> response = await ApiLogin().fetchdata(
                                      gmailController.text,
                                      passwordController.text,
                                    );

                                    if (response['success'] != false) {
                                      print("form submitted Successfully");
                                      if (mounted) {
                                        Navigator.pushNamed(context, "/user/${response['_id']}", arguments: response);
                                      }
                                    } else {
                                      // FIX: Replaced print statement with a beautiful error alert
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              children: [
                                                Icon(Icons.error_outline, color: Colors.white),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Login failed. Please check your credentials.",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            duration: const Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    print("An error occurred: $e");
                                    // Optional: Show a network error snackbar here too if the server crashes
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ) ,

                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("---------- OR ----------"),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/Signup');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey, // Changed color slightly to visually differentiate from Login
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  "Sign Up", // FIX 3: Changed text from "LoginIn" to "Sign Up"
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