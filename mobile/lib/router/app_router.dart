import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/presentation/admin/admin_screen.dart';
import 'package:hotel_flutter/presentation/screens/drawerScreens/history_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/onboarding_screen.dart';
import 'package:hotel_flutter/presentation/screens/drawerScreens/crypto_wallet.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/forgot_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/drawerScreens/help_support_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/tab_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/login_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/signup_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/update_password_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/upload_picture_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/verify_code_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/welcome_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/email_reset_token_screen.dart';
import 'package:hotel_flutter/presentation/screens/authScreens/reset_password.dart';
import 'package:hotel_flutter/presentation/screens/drawerScreens/profile_screen.dart';
import 'package:hotel_flutter/presentation/screens/drawerScreens/favorite_screen.dart';

class AppRouter {
  final BookingBloc bookingBloc; // Pass BookingBloc to the router

  AppRouter(this.bookingBloc);

  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case '/homescreen':
        return MaterialPageRoute(builder: (_) => TabScreen());

      case '/forgotPassword':
        return MaterialPageRoute(builder: (_) => const ForgotPassword());

      case '/emailResetToken':
        return MaterialPageRoute(builder: (_) => const EmailResetTokenScreen());

      case '/resetPassword':
        final args = routeSettings.arguments as Map<String, dynamic>;
        final token = args['token'] as String;

        return MaterialPageRoute(
          builder: (_) => ResetPassword(token: token),
        );

      case '/profile':
        final args = routeSettings.arguments as Map<String, dynamic>?;

        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(
              firstName: args['firstName'] ?? 'Guest',
              lastName: args['lastName'] ?? '',
              email: args['email'] ?? '',
              profile: args['profile'] ?? '',
              phoneNumber: args['phoneNumber'] ?? '',
              gender: args['gender'] ?? 'Male',
            ),
          );
        } else {
          return null;
        }

      case '/cryptoTransaction':
        return MaterialPageRoute(builder: (_) => CryptoWallet());

      case '/verifyCode':
        final args = routeSettings.arguments as Map<String, dynamic>?;

        if (args != null && args.containsKey('email')) {
          return MaterialPageRoute(
            builder: (_) => VerificationCodeScreen(email: args['email']),
          );
        } else {
          return null;
        }

      case '/updatePassword':
        return MaterialPageRoute(builder: (_) => UpdatePasswordScreen());

      case '/favorite':
        final args = routeSettings.arguments as Map<String, dynamic>?;

        if (args != null && args.containsKey('userId')) {
          return MaterialPageRoute(
            builder: (_) => FavoriteScreen(userId: args['userId']),
          );
        } else {
          // Handle the case when userId is not provided
          return null; // Or show an error or redirect as needed
        }

      case '/help':
        return MaterialPageRoute(builder: (_) => HelpSupportScreen());

      case '/history':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bookingBloc,
            child: const HistoryScreen(),
          ),
        );

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());

      case '/uploadPicture':
        final args = routeSettings.arguments as Map<String, dynamic>?;

        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => UploadPictureScreen(
              firstName: args['firstName'],
              lastName: args['lastName'],
              email: args['email'],
              password: args['password'],
              confirmPassword: args['confirmPassword'],
              phoneNumber: args['phoneNumber'],
              gender: args['gender'],
              roles: args['roles'],
            ),
          );
        } else {
          return null;
        }

      case '/logout':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminScreen());

      default:
        return null;
    }
  }
}
