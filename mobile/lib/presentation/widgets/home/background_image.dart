import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BackgroundImage extends StatelessWidget {
  final String image;
  const BackgroundImage({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: AssetImage(image),
      fit: BoxFit.cover,
    );
  }
}
