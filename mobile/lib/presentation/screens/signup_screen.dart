import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/signup/header_widget.dart';
import 'package:hotel_flutter/presentation/widgets/signup/image_widget.dart';
import 'package:hotel_flutter/presentation/widgets/signup/signup_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          const Column(
            children: [
              HeaderWidget(title: 'CRYPTOTEL'),
              ImageWidget(imagePath: 'assets/images/others/temp_image.png'),
              Expanded(child: SizedBox()),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                screenHeight * 0.05,
                16,
                screenHeight * 0.02,
              ),
              height: screenHeight * 0.55,
              decoration: const BoxDecoration(color: Colors.white),
              child: const SignupForm(),
            ),
          ),
        ],
      ),
    );
  }
}
