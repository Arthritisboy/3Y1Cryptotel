import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BackgroundImage extends StatelessWidget {
  final String image;
  const BackgroundImage({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.3),
        BlendMode.darken,
      ),
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    );
  }
}
