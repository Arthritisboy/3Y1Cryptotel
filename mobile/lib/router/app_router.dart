import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_screen.dart';
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
  final BookingBloc bookingBloc;

  AppRouter(this.bookingBloc);

  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return _buildRoute(const WelcomeScreen(), clearStack: true);

      case '/login':
        return _buildRoute(const LoginScreen(), clearStack: true);

      case '/signup':
        return _buildRoute(const SignupScreen(), clearStack: true);

      case '/forgotPassword':
        return _buildRoute(const ForgotPassword());

      case '/homescreen':
        return _buildRoute(TabScreen(), clearStack: true);

      case '/emailResetToken':
        return _buildRoute(const EmailResetTokenScreen());

      case '/resetPassword':
        final args = routeSettings.arguments as Map<String, dynamic>;
        final token = args['token'] as String;
        return _buildRoute(ResetPassword(token: token));

      case '/profile':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return _buildRoute(ProfileScreen(
            firstName: args['firstName'] ?? 'Guest',
            lastName: args['lastName'] ?? '',
            email: args['email'] ?? '',
            profile: args['profile'] ?? '',
            phoneNumber: args['phoneNumber'] ?? '',
            gender: args['gender'] ?? 'Male',
          ));
        } else {
          return null;
        }

      case '/cryptoTransaction':
        return _buildRoute(CryptoWallet());

      case '/verifyCode':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey('email')) {
          return _buildRoute(VerificationCodeScreen(email: args['email']));
        } else {
          return null;
        }

      case '/updatePassword':
        return _buildRoute(UpdatePasswordScreen());

      case '/favorite':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey('userId')) {
          return _buildRoute(FavoriteScreen(userId: args['userId']));
        } else {
          return null;
        }

      case '/help':
        return _buildRoute(HelpSupportScreen());

      case '/history':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bookingBloc,
            child: const HistoryScreen(),
          ),
        );

      case '/onboarding':
        return _buildRoute(OnboardingScreen());

      case '/uploadPicture':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return _buildRoute(UploadPictureScreen(
            firstName: args['firstName'],
            lastName: args['lastName'],
            email: args['email'],
            password: args['password'],
            confirmPassword: args['confirmPassword'],
            phoneNumber: args['phoneNumber'],
            gender: args['gender'],
            roles: args['roles'],
          ));
        } else {
          return null;
        }

      case '/logout':
        return _buildRoute(const LoginScreen(), clearStack: true);

      case '/admin':
        return _buildRoute(const AdminScreen());

      default:
        return null;
    }
  }

  /// Helper method to build routes with optional stack clearing.
  MaterialPageRoute _buildRoute(Widget child, {bool clearStack = false}) {
    return MaterialPageRoute(
      builder: (context) {
        if (clearStack) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => child),
              (route) => false, // Clears all previous routes from the stack
            );
          });
          return const SizedBox.shrink(); // Temporary placeholder widget
        }
        return child;
      },
    );
  }
}
