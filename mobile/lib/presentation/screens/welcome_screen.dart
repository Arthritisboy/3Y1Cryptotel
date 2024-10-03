import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/login_screen.dart'; // Import your login screen
import 'package:hotel_flutter/presentation/screens/signup_screen.dart'; // Import your signup screen

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formSignInKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.05,
                      bottom: screenHeight * 0.05),
                  child: Text(
                    'CRYPTOTEL',
                    style: TextStyle(
                      fontFamily: 'HammerSmith',
                      fontSize: screenHeight * 0.03,
                      color: const Color(0xFF1C3473),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.4,
                child: Image.asset(
                  'assets/images/others/temp_image.png',
                  fit: BoxFit.contain,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.05,
                screenWidth * 0.05,
                screenHeight * 0.02,
              ),
              height: screenHeight * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Form(
                key: _formSignInKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'CRYPTOTEL',
                        style: TextStyle(
                          fontFamily: 'HammerSmith',
                          fontSize: screenHeight * 0.02,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'WHERE CRYPTO MEETS COMFORT',
                        style: TextStyle(
                          fontFamily: 'HammerSmith',
                          fontSize: screenHeight * 0.02,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.05,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xFF1C3473)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(_createRoute('/login'));
                        },
                        child: const Text('LOGIN'),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.black, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('OR'),
                        ),
                        Expanded(
                          child: Divider(color: Colors.black, thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.05,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xFF1C3473)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(_createRoute('/signup'));
                        },
                        child: const Text('SIGN UP'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(String routeName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        if (routeName == '/login') {
          return const LoginScreen();
        } else {
          return const SignupScreen();
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
