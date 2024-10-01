import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/forgot_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/tab_screen.dart';
import 'package:hotel_flutter/presentation/screens/login_screen.dart';
import 'package:hotel_flutter/presentation/screens/signup_screen.dart';
import 'package:hotel_flutter/presentation/screens/welcome_screen.dart';
import 'package:hotel_flutter/presentation/screens/email_reset_token_screen.dart';
import 'package:hotel_flutter/presentation/screens/reset_password.dart';
import 'package:hotel_flutter/presentation/screens/profile_screen.dart';

class AppRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      case '/signup':
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
        );
      case '/homescreen':
        return MaterialPageRoute(
          builder: (_) => TabScreen(),
        );

      case '/forgotPassword':
        return MaterialPageRoute(
          builder: (_) => ForgotPassword(),
        );
      case '/emailResetToken':
        return MaterialPageRoute(
          builder: (_) => EmailResetTokenScreen(),
        );

      case '/resetPassword':
        final args = routeSettings.arguments as Map<String, dynamic>;
        final token = args['token'] as String;

        return MaterialPageRoute(
          builder: (_) => ResetPassword(token: token),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
        );

      default:
        return null;
    }
  }
}
