import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/forgot_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/menu_screens.dart';
import 'package:hotel_flutter/presentation/screens/tab_screen.dart';
import 'package:hotel_flutter/presentation/screens/login_screen.dart';
import 'package:hotel_flutter/presentation/screens/signup_screen.dart';
import 'package:hotel_flutter/presentation/screens/welcome_screen.dart';

class AppRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );
      case '/homescreen':
        return MaterialPageRoute(
          builder: (_) => const TabScreen(),
        );
      case '/forgotPassword':
        return MaterialPageRoute(
          builder: (_) => const ForgotPassword(),
        );
      case '/menuscreen':
        return MaterialPageRoute(
          builder: (_) => const MenuScreen(),
        );
      default:
        return null;
    }
  }
}
