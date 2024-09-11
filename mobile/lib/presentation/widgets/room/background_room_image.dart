import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BackgroundRoomImage extends StatelessWidget {
  final String image;
  const BackgroundRoomImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5),
          BlendMode.darken,
        ),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
