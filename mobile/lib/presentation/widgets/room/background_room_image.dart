import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BackgroundRoomImage extends StatelessWidget {
  final String image;
  const BackgroundRoomImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: AssetImage(image),
      fit: BoxFit.cover,
    );
  }
}
