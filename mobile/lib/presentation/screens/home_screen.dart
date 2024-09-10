import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: AssetImage('assets/images/others/homepage.jpg'),
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
