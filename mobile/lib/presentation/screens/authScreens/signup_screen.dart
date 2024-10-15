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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderWidget(title: 'CRYPTOTEL'),
              const SizedBox(height: 16),
              const ImageWidget(
                  imagePath: 'assets/images/others/temp_image.png'),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  screenHeight * 0.05,
                  16,
                  screenHeight * 0.02,
                ),
                decoration: const BoxDecoration(color: Colors.white),
                child: const SignupForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
