import 'package:flutter/material.dart';

class CryptoWithTransaction extends StatelessWidget {
  const CryptoWithTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
      children: [
        // Adds some space from the top of the screen
        Text(
          "Transaction History",
          style: TextStyle(
            fontFamily: 'HammerSmith',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
