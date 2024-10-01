import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
