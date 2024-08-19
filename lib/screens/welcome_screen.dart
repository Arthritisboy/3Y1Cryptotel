import 'package:flutter/material.dart';
import 'package:hotel_flutter/screens/signin_screen.dart';
import 'package:hotel_flutter/screens/signup_screen.dart';
import 'package:hotel_flutter/widgets/custom_scaffold.dart';
import 'package:hotel_flutter/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                    child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Cryptotel \n',
                          style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                          text: 'where crypto meets comfort',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                )),
              )),
          const Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                      child: WelcomeButton(
                    buttonText: 'Sign in',
                    onTap: SigninScreen(),
                  )),
                  Expanded(
                      child: WelcomeButton(
                    buttonText: 'Sign up',
                    onTap: SignupScreen(),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
