import 'package:flutter/material.dart';

class BlueBackground extends StatelessWidget {
  const BlueBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 29, 53, 115),
      height: MediaQuery.of(context).size.height,
      child: const Center(
        child: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
