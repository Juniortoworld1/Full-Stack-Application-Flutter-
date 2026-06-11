// Location: lib/features/routes/routes.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/screens/homepage.dart'; // Kept this one
import 'package:frontend/features/screens/login.dart';
import 'package:frontend/features/screens/signUp.dart';
// Removed the duplicate homepage import line from here

class RoutesPage {
  static const String signup = '/Signup';
  static const String login = '/login';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 1. Handle standard routes
    if (settings.name == signup) {
      return MaterialPageRoute(builder: (context) => const Signup());
    }
    if (settings.name == login) {
      return MaterialPageRoute(builder: (context) => const Login());
    }

    // 2. Handle dynamic /user/{id} routes
    final uri = Uri.parse(settings.name ?? '');
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'user') {
      final userId = uri.pathSegments[1];

      return MaterialPageRoute(
        builder: (context) => Homepage(userId: userId),
        settings: settings,
      );
    }

    // 3. Fallback screen if something completely breaks
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('Route Not Found')),
      ),
    );
  }
}