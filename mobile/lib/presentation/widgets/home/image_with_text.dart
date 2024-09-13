import 'package:flutter/material.dart';

class ImageWithText extends StatelessWidget {
  final String imagePath;
  final String text;
  final double borderRadius;
  final double width;
  final double height;

  const ImageWithText({
    super.key,
    required this.imagePath,
    required this.text,
    required this.width,
    required this.height,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 8, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
            ),
            Positioned(
              top: 5.0,
              left: 10.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
