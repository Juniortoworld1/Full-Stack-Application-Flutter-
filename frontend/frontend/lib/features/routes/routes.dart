import 'package:flutter/material.dart';
import '../screens/signUp.dart';

class RoutesPage{
  static const String signup = '/Signup';

  static Map<String, WidgetBuilder> getRoutes(){
    return {
      signup:(context) => const Signup() ,
    } ;
  }
}