import 'package:flutter/material.dart';
import 'package:frontend/features/screens/login.dart';
import '../screens/signUp.dart';

class RoutesPage{
  static const String signup = '/Signup';
  static const String login = '/login';

  static Map<String, WidgetBuilder> getRoutes(){
    return {
      signup:(context) => const Signup() ,
      login:(context)=> const Login() ,
    } ;
  }
}