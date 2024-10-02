import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/crypto_wallet.dart';
import 'package:hotel_flutter/presentation/screens/forgot_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/tab_screen.dart';
import 'package:hotel_flutter/presentation/screens/login_screen.dart';
import 'package:hotel_flutter/presentation/screens/signup_screen.dart';
import 'package:hotel_flutter/presentation/screens/update_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/welcome_screen.dart';
import 'package:hotel_flutter/presentation/screens/email_reset_token_screen.dart';
import 'package:hotel_flutter/presentation/screens/reset_password.dart';
import 'package:hotel_flutter/presentation/screens/profile_screen.dart';

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
      case '/emailResetToken':
        return MaterialPageRoute(
          builder: (_) => const EmailResetTokenScreen(),
        );

      case '/resetPassword':
        final args = routeSettings.arguments as Map<String, dynamic>;
        final token = args['token'] as String;

        return MaterialPageRoute(
          builder: (_) => ResetPassword(token: token),
        );

      case '/profile':
        final args = routeSettings.arguments
            as Map<String, dynamic>?; // Make it nullable

        if (args != null) {
          final String firstName = args['firstName'];
          final String lastName = args['lastName'];
          final String email = args['email'];

          return MaterialPageRoute(
            builder: (_) => ProfileScreen(
              firstName: firstName,
              lastName: lastName,
              email: email,
            ),
          );
        } else {
          print("No arguments were passed to the Profile screen.");
          return null;
        }

      case '/cryptoTransaction':
        return MaterialPageRoute(
          builder: (_) => const CryptoWallet(),
        );

      case '/updatePassword':
        return MaterialPageRoute(
          builder: (_) => const UpdatePasswordScreen(),
        );

      default:
        return null;
    }
  }
}
