import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/routes/routes.dart';
import 'package:frontend/features/screens/signUp.dart';


void main(){
  runApp(Main()) ;
}

class Main extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: "Login",
      initialRoute: RoutesPage.signup,
      routes: RoutesPage.getRoutes(),
    );
  }
}
