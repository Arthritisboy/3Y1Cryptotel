import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/crypto_wallet.dart';
import 'package:hotel_flutter/presentation/screens/forgot_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/tab_screen.dart';
import 'package:hotel_flutter/presentation/screens/login_screen.dart';
import 'package:hotel_flutter/presentation/screens/signup_screen.dart';
import 'package:hotel_flutter/presentation/screens/welcome_screen.dart';
import 'package:hotel_flutter/presentation/screens/email_reset_token_screen.dart';
import 'package:hotel_flutter/presentation/screens/reset_password.dart';
import 'package:hotel_flutter/presentation/screens/profile_screen.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_transactions.dart';

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
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
        );

      case '/cryptoTransaction':
        return MaterialPageRoute(
          builder: (_) => CryptoWallet(),
        );

      default:
        return null;
    }
  }
}
