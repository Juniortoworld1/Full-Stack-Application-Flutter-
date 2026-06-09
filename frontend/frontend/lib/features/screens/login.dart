import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width ;
    final screenHeight = MediaQuery.of(context).size.height ;
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 4) ,
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          )
        ),
      ),

    );
  }
}
