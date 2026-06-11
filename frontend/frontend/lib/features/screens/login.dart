import 'package:flutter/material.dart';
import 'package:frontend/features/controllers/api.login.controller.dart';
import 'package:frontend/features/screens/utils/forms.utils.dart';
import 'package:frontend/main.dart';

import '../controllers/api.controller.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override


  TextEditingController gmailController = TextEditingController() ;
  TextEditingController passwordController = TextEditingController() ;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(

          colors: [
            Color(0xFF7580B8), // Start color (your custom code)
            Colors.white60, // End color (example matching shade)
          ],
        ),
      ),
      child: Center(
        child: Container(
          height: 400, // Height increased to make room for the new options
          width: 350 ,  // Adjusts width for web vs mobile screens
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),


              boxShadow: const [
                BoxShadow(
                    blurRadius: 20,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 10,
                    color: Colors.black)
              ]),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Login",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.question_answer_outlined) ,
                            Text("Forgot" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                          ],
                        )

                      ],
                    ) ,

                    SizedBox(height: 18,) ,





                    // submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {

                          final ApiHandler apiHandler = ApiHandler() ;

                          final Map<String , dynamic> response = await ApiLogin().fetchdata(gmailController.text, passwordController.text) ;

                          if(response['success']!=false){
                            print("form submitted Successsfully") ;
                          }
                          else{
                            print("Submission falied ") ;
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "LoginIn",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    SizedBox(height: 8,) ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("----------OR----------" , ),
                      ],
                    ),
                    SizedBox(height: 18,) ,

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (){

                          Navigator.pushNamed(context, '/Signup'); // Replace '/home' with your defined route name


                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "LoginIn",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]

              ),





            ),
          ),
        ),
      ),
    ),
    );
  }
}
