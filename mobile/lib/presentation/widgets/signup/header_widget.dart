import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.05,
          bottom: screenHeight * 0.05,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'HammerSmith',
            fontSize: screenHeight * 0.03,
            color: const Color(0xFF1C3473),
          ),
        ),
      ),
    );
  }
}
