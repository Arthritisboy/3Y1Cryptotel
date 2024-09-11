import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.darken,
      ),
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: AssetImage('assets/images/others/homepage.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}
